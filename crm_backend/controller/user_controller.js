const UserModel = require('../models/user_model');
const UserService = require('../services/user_services');
const admin = require('firebase-admin');

// Ensure Firebase Admin is initialized once in your project entry point (e.g., app.js or server.js)
// admin.initializeApp({ credential: admin.credential.cert(require('../config/firebaseServiceAccountKey.json')) });

const db = admin.firestore();




exports.UserProfileImage = async (req, res) => {
  try {
    const userId = req.user._id;
    if (!req.file) {
      return res.status(400).json({ status: false, message: 'Image file is required' });
    }

    // Convert image to base64 and create data URL
    const base64 = req.file.buffer.toString('base64');
    const dataUrl = `${base64}`;

    // Update Firestore with the data URL
    await UserService.AddUpdateProfileImage(userId, dataUrl);

    res.status(200).json({ status: true, message: 'Profile image updated successfully' });
  } catch (error) {
    console.error('Update profile image error:', error);
    res.status(500).json({ status: false, message: 'Internal server error' });
  }
}

/**
 * REGISTER USER
 */
exports.register = async (req, res, next) => {
  try {
    const { email, password, name, phone } = req.body;

    const newUser = await UserService.registerUser(email, password, name, phone);

    let tokenData = { _id: newUser._id, email: newUser.email };
    const token = await UserService.generateToken(tokenData, 'secretKey', '1h');

    // 🔥 Create Firestore user doc automatically
    await UserService.syncUserToFirestore(newUser._id.toString(), {
    
      createdAt: new Date(),
    });

    res.status(201).json({
      status: true,
      success: 'User registered successfully',
      token: token,
      user: {
        _id: newUser._id,
      },
    });
  } catch (err) {
    console.error('Register error:', err);
    res.status(500).json({ status: false, message: 'Internal server error' });
  }
};

/**
 * LOGIN USER
 */
exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const user = await UserService.loginUser(email);
    if (!user) {
      return res.status(400).json({ status: false, message: 'Wrong email' });
    }

    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res.status(400).json({ status: false, message: 'Invalid password' });
    }

    let tokenData = { _id: user._id, email: user.email };
    const token = await UserService.generateToken(tokenData, 'secretKey', '1h');

    res.status(200).json({
      status: true,
      token: token,
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ status: false, message: 'Internal server error' });
  }
};

exports.update = async (req,res) => {
  try{
    const { name , nickname , phone } = req.body;
    const id = req.user._id;
     if ( !name || !phone) {
      return res.status(400).json({
        status: false,
        message: 'Missing required fields:  name, phone are required',
      });
    }
     await UserService.updateUser(id,name,phone,nickname);
                res.status(200).json({ status: true, message: "Profile updated successfully" });
  }
  catch(e){
    console.error("Update User error:", e);
    res.status(500).json({ status: false, message: "Internal server error" });}
}

exports.delete = async (req, res) => {
    try{
    const id = req.body.isAdmin === true ? req.body.userId : req.user._id;
    const user = await UserModel.findById(id);
    if(!user){res.status(404).json({ status: false, message: "user not found" }); return;}
    await UserService.deleteUser(id);
    await UserService.deleteUserFromFirestore(id);
    res.status(200).json({ status: true, message: "User deleted successfully" });
    }catch(err){
      console.error("Delete User error:", err);
      res.status(500).json({ status: false, message: "Internal server error" });
    }
}

/**
 * GOOGLE SIGN-IN
 */
exports.googleSignin = async (req, res, next) => {
  try {
    const { email, name, googleId } = req.body;

    if (!email || !name || !googleId) {
      return res.status(400).json({
        status: false,
        message: 'Missing required fields: email, name, and googleId are required',
      });
    }

    console.log('Processing Google Sign-In for:', email);

    let user = await UserService.findOrCreateGoogleUser(email, name, googleId);

    let tokenData = { _id: user._id, email: user.email };
    const token = await UserService.generateToken(tokenData, 'secretKey', '1h');

    // 🔥 Sync Firestore on Google Sign-In
    await UserService.syncUserToFirestore(user._id.toString(), {
      createdAt: new Date(),
    });

    console.log('Google Sign-In successful for:', email);

    res.status(200).json({
      status: true,
      token: token,
      user: {
        _id: user._id,
        email: user.email,
        name: user.name,
        authProvider: user.authProvider,
      },
    });
  } catch (err) {
    console.error('Google Sign-In error:', err);
    res.status(500).json({
      status: false,
      message: 'Internal server error',
      error: process.env.NODE_ENV === 'development' ? err.message : undefined,
    });
  }
};

/**
 * FORGOT PASSWORD (send OTP)
 */
exports.forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    if (!email)
      return res.status(400).json({ status: false, message: 'Email is required' });

    const user = await UserService.loginUser(email);
    if (!user)
      return res.status(404).json({ status: false, message: 'User not found' });

    const otp = UserService.generateOTP();
    const otpExpiry = new Date(Date.now() + 10 * 60 * 1000);

    user.otp = otp;
    user.otpExpiry = otpExpiry;
    await user.save();

    await UserService.sendOTP(email, otp);

    res.status(200).json({ status: true, message: 'OTP sent to your email' });
  } catch (err) {
    console.error('Forgot password error:', err);
    res.status(500).json({ status: false, message: 'Internal server error' });
  }
};

/**
 * RESET PASSWORD
 */
exports.resetPassword = async (req, res) => {
  try {
    const { email, otp, newPassword } = req.body;
    if (!email || !otp || !newPassword) {
      return res
        .status(400)
        .json({ status: false, message: 'Email, OTP, and new password are required' });
    }

    const user = await UserService.verifyOTP(email, otp);
    if (!user) {
      return res.status(400).json({ status: false, message: 'Invalid or expired OTP' });
    }

    await UserService.resetPassword(email, newPassword);

    res.status(200).json({ status: true, message: 'Password reset successfully' });
  } catch (err) {
    console.error('Reset password error:', err);
    res.status(500).json({ status: false, message: 'Internal server error' });
  }
};

/**
 * GET USER
 */
exports.getUser = async (req, res, next) => {
  try {
    const userId = req.user._id;
    const user = await UserService.getUserById(userId);
    if (!user)
      return res.status(404).json({ status: false, message: 'User not found' });

    const imageUrl = await UserService.GetProfileImage(userId);

    res.status(200).json({
      status: true,
      user: {
        _id: user._id,
        email: user.email,
        name: user.name,
        nickname: user.nickname,
        phone: user.phone,
        avatar: imageUrl,
        role: user.role,
      },
    });
  } catch (err) {
    console.error('Get user error:', err);
    res.status(500).json({ status: false, message: 'Internal server error' });
  }
};

/**
 * CHANGE PASSWORD
 */
exports.changePassword = async (req, res) => {
  try {
    const { oldPassword, newPassword } = req.body;
    const userId = req.user._id;

    if (!oldPassword || !newPassword) {
      return res.status(400).json({
        status: false,
        message: 'Old password and new password are required',
      });
    }

    await UserService.changePassword(userId, oldPassword, newPassword);

    res.status(200).json({ status: true, message: 'Password changed successfully' });
  } catch (err) {
    console.error('Change password error:', err);
    res.status(400).json({ status: false, message: err.message });
  }
};

/**
 * SEND EMAIL
 */
exports.sendEmail = async (req, res) => {
  try {
    const { owner,to, subject, text, html } = req.body;
    if (!to || !subject || !text) {
      return res.status(400).json({
        status: false,
        message: 'To, subject, and text are required',
      });
    }

    const result = await UserService.sendEmail(owner,to, subject, text, html);
    res.status(200).json({ status: true, message: result.message });
  } catch (err) {
    console.error('Send email error:', err);
    res.status(500).json({ status: false, message: 'Failed to send email' });
  }
};

/**
 * GET ALL USERS
 */
exports.getAllUsers = async (req, res) => {
  try {
    const users = await UserService.getAllUsers();
    const usersWithAvatars = await Promise.all(users.map(async (user) => {
      const avatar = await UserService.GetProfileImage(user._id.toString());
      return {
        _id: user._id,
        email: user.email,
        name: user.role== "admin"?"Me":user.name,
        nickname: user.nickname,
        phone: user.phone,
        avatar: avatar,
        role: user.role,
        createdAt: user.createdAt,
      };
    }));
    res.status(200).json({
      status: true,
      users: usersWithAvatars,
    });
  } catch (err) {
    console.error('Get all users error:', err);
    res.status(500).json({ status: false, message: 'Internal server error' });
  }
};

/**
 * GET ALL USERS HISTORY
 */
exports.getAllUsersHistory = async (req, res) => {
  try {
    const usersHistory = await UserService.getAllUsersHistory();
    res.status(200).json({
      status: true,
      usersHistory: usersHistory,
    });
  } catch (err) {
    console.error('Get all users history error:', err);
    res.status(500).json({ status: false, message: 'Internal server error' });
  }
};

/**
 * DELETE HISTORY
 */
exports.deleteHistory = async (req, res) => {
  try {
    const userId = req.user._id;
    const { historyToDelete } = req.body;

    if (!historyToDelete || !Array.isArray(historyToDelete)) {
      return res.status(400).json({ status: false, message: 'historyToDelete must be an array' });
    }

    const result = await UserService.deleteHistory(userId, historyToDelete);
    res.status(200).json({ status: true, message: result.message });
  } catch (err) {
    console.error('Delete history error:', err);
    res.status(500).json({ status: false, message: 'Internal server error' });
  }
};
exports.addtohistoryalso = async (req, res) => {
  try{
 const userId = req.user._id;
  const { websiteURL,title } = req.body;
   const action = `Visited website: ${websiteURL} of a task named ${title}`;
        const actionDate = new Date();
        await UserService.addActionToHistory(userId, action, actionDate);
    res.status(200).json({ status: true, message: "history added " });
  }catch(err){console.error('add history error:', err);
    res.status(500).json({ status: false, message: 'Internal server error' });}
}




