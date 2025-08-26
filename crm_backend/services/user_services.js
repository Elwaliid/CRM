const UserModel = require('../models/user_model');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
const appleSignin = require('apple-signin-auth');

// Google client
const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

class UserService {
    // ✅ Register with email & password
    static async registerUser(email, password) {
        try {
            const createUser = new UserModel({ email, password });
            return await createUser.save();
        } catch (err) {
            throw err;
        }
    }

    // ✅ Login with email & password
    static async loginUser(email) {
        try {
            return await UserModel.findOne({ email });
        } catch (err) {
            throw err;
        }
    }

    // ✅ Generate JWT
    static async generateToken(tokenData, secretKey, jwt_expire) {
        return jwt.sign(tokenData, secretKey, { expiresIn: jwt_expire });
    }

    // ✅ Login with Google
    static async loginWithGoogle(idToken) {
        try {
            // Verify token with Google
            const ticket = await googleClient.verifyIdToken({
                idToken,
                audience: process.env.GOOGLE_CLIENT_ID,
            });
            const payload = ticket.getPayload();

            // Check if user exists
            let user = await UserModel.findOne({ email: payload.email });
            if (!user) {
                // If new user, create account
                user = new UserModel({ email: payload.email, password: "google-oauth" });
                await user.save();
            }

            // Generate JWT
            const token = await this.generateToken(
                { id: user._id, email: user.email },
                process.env.JWT_SECRET,
                "300h"
            );

            return { user, token };
        } catch (err) {
            throw err;
        }
    }

    // ✅ Login with Apple
    static async loginWithApple(idToken) {
        try {
            // Verify token with Apple
            const appleUser = await appleSignin.verifyIdToken(idToken, {
                audience: process.env.APPLE_CLIENT_ID,
            });

            let user = await UserModel.findOne({ email: appleUser.email });
            if (!user) {
                user = new UserModel({ email: appleUser.email, password: "apple-oauth" });
                await user.save();
            }

            const token = await this.generateToken(
                { id: user._id, email: user.email },
                process.env.JWT_SECRET,
                "300h"
            );

            return { user, token };
        } catch (err) {
            throw err;
        }
    }
}

module.exports = UserService;
