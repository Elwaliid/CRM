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
        // Try to find existing user
        let user = await UserModel.findOne({ email });
        
        if (!user) {
            // Create new user with Google data
            user = new UserModel({ 
                email, 
                name,
                googleId,
                // You might want to set a default password or handle this differently
            });
            await user.save();
        }
        
        return user;
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
