const UserService = require('../services/user_services');
const admin = require('firebase-admin');

// Ensure Firebase Admin is initialized once in your project entry point (e.g., app.js or server.js)
// admin.initializeApp({ credential: admin.credential.cert(require('../config/firebaseServiceAccountKey.json')) });

const db = admin.firestore();

/**
 * Helper function: create or update Firestore user doc
 */



exports.UserProfileImage = async (req, res) => {
  try {
    const userId = req.user._id;
    const { profileImageURL } = req.body;
    if (!profileImageURL) {
      return res.status(400).json({ status: false, message: 'profileImageURL is required' });
    }
    await UserService.AddUpdateProfileImage(userId, profileImageURL);
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
    await syncUserToFirestore(user._id.toString(), {
      email: user.email,
      name: user.name,
      googleId: user.googleId,
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

    res.status(200).json({
      status: true,
      user: {
        _id: user._id,
        email: user.email,
        name: user.name,
        phone: user.phone,
        avatar: user.avatar,
        role: user.role,
      },
    });
  } catch (err) {
    console.error('Get user error:', err);
    res.status(500).json({ status: false, message: 'Internal server error' });
  }
};

/**
 * SEND EMAIL
 */
exports.sendEmail = async (req, res) => {
  try {
    const { to, subject, text, html } = req.body;
    if (!to || !subject || !text) {
      return res.status(400).json({
        status: false,
        message: 'To, subject, and text are required',
      });
    }

    const result = await UserService.sendEmail(to, subject, text, html);
    res.status(200).json({ status: true, message: result.message });
  } catch (err) {
    console.error('Send email error:', err);
    res.status(500).json({ status: false, message: 'Failed to send email' });
  }
};


