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

   
}

module.exports = UserService;
