const UserModel = require('../models/user_model');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const otpGenerator = require('otp-generator');
const admin = require('firebase-admin');

const db = admin.firestore();


class UserService {
    // Register with email & password
    static async registerUser(email, password, name, phone) {
        try {
            const createUser = new UserModel({ email, password, name, phone });
            return await createUser.save();
        } catch (err) {
            throw err;
        }
    }

    // Login with email & password
    static async loginUser(email) {
        try {
            return await UserModel.findOne({ email });
        } catch (err) {
            throw err;
        }
    }
  
     static async updateUser(id,name,phone,nickname){
 try{
         const user = await UserModel.findById(id);
         if(!user) throw new Error('user not found');
         if (nickname!==undefined)  user.nickname = nickname;
         user.name = name;
         user.phone = phone;
         await user.save();
         return user;
    }catch (err) {  
        throw err;
    }
}

 static async deleteUser(id) {
        try{
            return await UserModel.findByIdAndDelete(id);
        }catch (err) {  throw err;}
    }
    
   static async findOrCreateGoogleUser(email, name, googleId) {
    try {
        // Try to find existing user by email
        let user = await UserModel.findOne({ email });

        if (!user) {
            // Create new user with Google data
            user = new UserModel({
                email,
                name,
                googleId,
                authProvider: 'google'
            });
            await user.save();
            console.log('New Google user created:', email);
        } else {
            // Update existing user with Google data if they don't have it
            if (!user.googleId && !user.name) {
                user.googleId = googleId;
                user.name = name;
                user.authProvider = 'google';
                await user.save();
                console.log('Existing user updated with Google data:', email);
            }
        }

        return user;
    } catch (err) {
        console.error('Error in findOrCreateGoogleUser:', err);
        throw err;
    }
}

// Generate JWT
    static async generateToken(tokenData, secretKey, jwt_expire) {
        return jwt.sign(tokenData, secretKey, { expiresIn: jwt_expire });
    }

    // Generate OTP
    static generateOTP() {
        return otpGenerator.generate(6, { upperCaseAlphabets: false, specialChars: false, lowerCaseAlphabets: false });
    }

    // Send OTP via email
    static async sendOTP(email, otp) {
        try {
            const transporter = nodemailer.createTransport({
                service: 'gmail',
                auth: {
                    user: 'walidboubaidja@gmail.com', // Set in .env
                    pass: 'zmex ewmv ycjx muhl'  // App password
                }
            });

            const mailOptions = {
                from: 'walidboubaidja@gmail.com',
                to: email,
                subject: 'Password Reset OTP',
                text: `Your OTP for password reset is: ${otp}. It expires in 10 minutes.`
            };

            await transporter.sendMail(mailOptions);
            console.log('OTP sent to:', email);
        } catch (err) {
            console.error('Error sending OTP:', err);
            throw err;
        }
    }

    // Verify OTP
    static async verifyOTP(email, otp) {
        try {
            const user = await UserModel.findOne({ email, otp, otpExpiry: { $gt: new Date() } });
            return user;
        } catch (err) {
            throw err;
        }
    }

    // Reset password
    static async resetPassword(email, newPassword) {
        try {
            const user = await UserModel.findOne({ email });
            if (!user) throw new Error('User not found');

            user.password = newPassword;
            user.otp = undefined;
            user.otpExpiry = undefined;
            await user.save();
            return user;
        } catch (err) {
            throw err;
        }
    }

    // Change password
    static async changePassword(userId, oldPassword, newPassword) {
        try {
            const user = await UserModel.findById(userId);
            if (!user) throw new Error('User not found');

            if (user.authProvider !== 'local') throw new Error('Password change not allowed for OAuth users');

            const isMatch = await user.comparePassword(oldPassword);
            if (!isMatch) throw new Error('Old password is incorrect');

            user.password = newPassword;
            await user.save();
            return user;
        } catch (err) {
            throw err;
        }
    }

    // Get user by id
    static async getUserById(id) {
        try {
            return await UserModel.findById(id);
        } catch (err) {
            throw err;
        }
    }

    // Send custom email
    static async sendEmail(to, subject, text, html) {
        try {
            const transporter = nodemailer.createTransport({
                service: 'gmail',
                auth: {
                    user: 'walidboubaidja@gmail.com', // Set in .env
                    pass: 'zmex ewmv ycjx muhl'  // App password
                }
            });

            const mailOptions = {
                from: 'walidboubaidja@gmail.com',
                to: to,
                subject: subject,
                text: text,
                html: html || `<p>${text}</p>`
            };

            await transporter.sendMail(mailOptions);
            console.log('Email sent to:', to);
            return { success: true, message: 'Email sent successfully' };
        } catch (err) {
            console.error('Error sending email:', err);
            throw err;
        }
    }
    static async  syncUserToFirestore(userId, data = {}) {
  try {
    const userRef = db.collection('users').doc(userId);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      await userRef.set({
        history: [],
        historyDate:[],
        profileImageURL: null,
        ...data,
      });
      console.log(`✅ Firestore user created: ${userId}`);
    } else {
      console.log(`ℹ️ Firestore user already exists: ${userId}`);
    }
  } catch (error) {
    console.error('🔥 Firestore sync error:', error);
  }
}
static async addActionToHistory(userId, historyAction, ActionDate) {
  try {
    const userRef = db.collection('users').doc(userId);
    const userDoc = await userRef.get();

    if (userDoc.exists) {
      const currentData = userDoc.data();
      const updatedHistory = [...(currentData.history || []), historyAction];
      const updatedHistoryDate = [...(currentData.historyDate || []), ActionDate];

      await userRef.set({
        history: updatedHistory,
        historyDate: updatedHistoryDate,
      }, { merge: true });
      console.log(`Updated history for user: ${userId}`);
    } else {
      // If document doesn't exist, create it with the new entry
      await userRef.set({
        history: [historyAction],
        historyDate: [ActionDate],
      });
      console.log(`Created history for new user: ${userId}`);
    }
  } catch (error) {
    console.error('Updated history error:', error);
  }
}

static async getAllUsersHistory() {
  try {
    const usersRef = db.collection('users');
    const snapshot = await usersRef.get();
    const usersHistory = [];

    for (const doc of snapshot.docs) {
      const data = doc.data();
      const user = await UserModel.findById(doc.id);
      if (user) {
        const avatar = await UserService.GetProfileImage(doc.id);
        usersHistory.push({
          name: user.name,
          avatar: avatar,
          history: (data.history || []).map(item => typeof item === 'string' ? item : JSON.stringify(item)),
          historyDate: (data.historyDate || []).map(date => date.toDate().toISOString())
        });
      }
    }

    return usersHistory;
  } catch (error) {
    console.error('Error getting all users history:', error);
    throw error;
  }
}

    static async GetProfileImage(userId) {
        try {
            const userRef = db.collection('users').doc(userId);
            const userDoc = await userRef.get();
            if (userDoc.exists) {
                return userDoc.data().profileImageURL || null;
            } else {
                return null;
            }
        } catch (error) {
            console.error('🔥 Firestore profile image get error:', error);
            throw error;
        }
    }

    static async AddUpdateProfileImage(userId, ImageURL) {
      try {
        const userRef = db.collection('users').doc(userId);
        // Use set with merge to create or update the document
        await userRef.set({
          profileImageURL: ImageURL,
        }, { merge: true });
        console.log(`✅ Firestore user profile image updated: ${userId}`);
      } catch (error) {
        console.error('🔥 Firestore profile image update error:', error);
        throw error; // Re-throw to handle in caller
      }
    }
  

    static async deleteHistory(userId, historyToDelete) {
        try {
            const userRef = db.collection('users').doc(userId);
            const userDoc = await userRef.get();

            if (userDoc.exists) {
                const currentData = userDoc.data();
                const currentHistory = currentData.history || [];
                const currentHistoryDate = currentData.historyDate || [];

                // Create a set of items to delete (action + time)
                const deleteSet = new Set(historyToDelete.map(item => `${item.action}|${item.time}`));

                const updatedHistory = [];
                const updatedHistoryDate = [];

                for (let i = 0; i < currentHistory.length; i++) {
                    const key = `${currentHistory[i]}|${currentHistoryDate[i].toDate().toISOString()}`;
                    if (!deleteSet.has(key)) {
                        updatedHistory.push(currentHistory[i]);
                        updatedHistoryDate.push(currentHistoryDate[i]);
                    }
                }

                await userRef.set({
                    history: updatedHistory,
                    historyDate: updatedHistoryDate,
                }, { merge: true });
                console.log(`Deleted history items for user: ${userId}`);
                return { success: true, message: 'History items deleted successfully' };
            } else {
                throw new Error('User not found');
            }
        } catch (error) {
            console.error('Delete history error:', error);
            throw error;
        }
    }

    static async getAllUsers() {
        try {
            return await UserModel.find({});
        } catch (err) {
            throw err;
        }
    }

    static async deleteUserFromFirestore(userId) {
        try {
            const userRef = db.collection('users').doc(userId);
            await userRef.delete();
            console.log(`✅ Firestore user deleted: ${userId}`);
        } catch (error) {
            console.error('🔥 Firestore delete error:', error);
            throw error;
        }
    }
}

module.exports = UserService;
