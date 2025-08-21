const UserModel = require('../models/user_model');
const jwt = require('jsonwebtoken')
class UserService{
static async registerUser(email,password){
    try{
        const createUser = new UserModel({email,password});
        return await createUser.save();
    }catch(err){
        throw err;
    }
}
static async loginUser(email) {
    try{
        return await UserModel({email});
    }catch(err) {throw err;}
}

static async generateToken(tokenData,secretKey,jwt_expire) {
    return jwt.sign(tokenData, secretKey, { expiresIn: jwt_expire });
}

}
module.exports = UserService;