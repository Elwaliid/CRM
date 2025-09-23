const UserModel = require('../models/user_model');
const jwt = require('jsonwebtoken');



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
}

module.exports = UserService;
