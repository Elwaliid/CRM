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
    password:{type:String, required: function() {
        return !this.googleId; // Password required only if not a Google user
    }},
    name:{type:String, required: false},
    googleId:{type:String, required: false, sparse: true, unique: true},
    authProvider: {type: String, enum: ['local', 'google'], default: 'local'}
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