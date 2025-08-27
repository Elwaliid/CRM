const UserModel = require('../models/user_model');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
const axios = require('axios');
const appleSignin = require('apple-signin-auth');
const { JWT_SECRET, GOOGLE_CLIENT_ID } = require('../config');

// Google client
const googleClient = new OAuth2Client(GOOGLE_CLIENT_ID);

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

    // Generate JWT
    static async generateToken(tokenData, secretKey, jwt_expire) {
        return jwt.sign(tokenData, secretKey, { expiresIn: jwt_expire });
    }

    // Login with Google (using accessToken)
    static async loginWithGoogleAccessToken(accessToken) {
        try {
            // Call Google userinfo API
            const response = await axios.get("https://www.googleapis.com/oauth2/v3/userinfo", {
                headers: { Authorization: `Bearer ${accessToken}` },
            });

            const profile = response.data; // { email, name, picture }

            let user = await UserModel.findOne({ email: profile.email });
            if (!user) {
                user = new UserModel({
                    email: profile.email,
                    password: "google-oauth",
                    name: profile.name,
                    picture: profile.picture,
                });
                await user.save();
            }

            const token = await this.generateToken(
                { id: user._id, email: user.email },
                JWT_SECRET,   // ✅ use value from config.js
                "300h"
            );

            return { user, token };
        } catch (err) {
            console.error("Google login error:", err.message);
            throw err;
        }
    }
}

module.exports = UserService;
