/**
 * User Service Module - Handles all user authentication and management operations
 * This service layer contains business logic for user registration, login, and OAuth flows
 */

const UserModel = require('../models/user_model'); // User data model
const jwt = require('jsonwebtoken'); // JSON Web Token for authentication
const { OAuth2Client } = require('google-auth-library'); // Google OAuth2 client library
const axios = require('axios'); // HTTP client for API calls
const appleSignin = require('apple-signin-auth'); // Apple Sign-In authentication library

// Initialize Google OAuth2 client with environment configuration
// This client is used to verify Google ID tokens from mobile/desktop applications
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

    // ✅ Login with Google (MOBILE & DESKTOP, using idToken)
    static async loginWithGoogle(idToken) {
        try {
            const ticket = await googleClient.verifyIdToken({
                idToken,
                audience: process.env.GOOGLE_CLIENT_ID,
            });
            const payload = ticket.getPayload();

            let user = await UserModel.findOne({ email: payload.email });
            if (!user) {
                user = new UserModel({ email: payload.email, password: "google-oauth" });
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

    // ✅ Login with Google (WEB, using accessToken)
    static async loginWithGoogleAccessToken(accessToken) {
        try {
            // Call Google userinfo API
            const response = await axios.get("https://www.googleapis.com/oauth2/v3/userinfo", {
                headers: { Authorization: `Bearer ${accessToken}` },
            });

            const profile = response.data; // email, name, picture

            let user = await UserModel.findOne({ email: profile.email });
            if (!user) {
                user = new UserModel({
                    email: profile.email,
                    password: "google-oauth",
                    name: profile.name,
                    picture: profile.picture
                });
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

    // ✅ Login with Apple
    static async loginWithApple(idToken) {
        try {
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
