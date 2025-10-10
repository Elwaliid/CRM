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
    static async GetProfileImage(userId) {
        try{
            const userRef = db.collection('users').doc(userId);
            await userRef.get({
                
            })
        }catch(err){
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
}

module.exports = UserService;
