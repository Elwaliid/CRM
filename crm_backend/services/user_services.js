const UserModel = require('../models/user_model');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const otpGenerator = require('otp-generator');



class UserService {
    // Register with email & password
    static async registerUser(email, password) {
        try {
            const createUser = new UserModel({ email, password });
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
                    user: process.env.EMAIL_USER, // Set in .env
                    pass: process.env.EMAIL_PASS  // App password
                }
            });

            const mailOptions = {
                from: process.env.EMAIL_USER,
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
}

module.exports = UserService;
