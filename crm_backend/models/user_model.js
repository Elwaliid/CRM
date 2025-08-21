const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const db = require('../config/db');

const { Schema } = mongoose;

const userSchema = new Schema({
    email:{type:String,
        lowercase:true,
        required:true,
        unique:true,
    },
    password:{type:String, required:true},
});

userSchema.pre('save',async function(){
    try {
        var user = this;
        const salt = await(bcrypt.genSalt(10));
        const hashpass = await bcrypt.hash(user.password,salt);

        user.password = hashpass;
    } catch (error) {
        throw error;   
    }
})

userSchema.methods.comparePassword = async function(password) {
    try {
        const isMatch = await bcrypt.compare(password, this.password);
        return isMatch;
    } catch (error) {
        throw error;
    }
}

const UserModel = db.model('user', userSchema);

module.exports = UserModel;