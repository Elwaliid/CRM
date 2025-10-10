const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const db = require('../config/db');

const { Schema } = mongoose;

const userSchema = new Schema({
  email: {
    type: String,
    lowercase: true,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: function () {
      return !this.googleId;
    },
  },
  name: { type: String },
  phone: { type: String },
  avatar: { type: String, default: 'lib/images/defaultAvatar.jpg' }, 
  googleId: { type: String, sparse: true, unique: true },
  authProvider: { type: String, enum: ['local', 'google'], default: 'local' },

  // OTP fields for password reset
  otp: { type: String },
  otpExpiry: { type: Date }, 
  isPined:{type: Boolean,default:false},
  nickname: { type: String },
  // Settings and meta
  role: { type: String, enum: ['user', 'admin'], default: 'user' },
  settings: {
    theme: { type: String, enum: ['light', 'dark'], default: 'light' },
    notifications: { type: Boolean, default: true },
  },
  createdAt: { type: Date, default: Date.now },
});


userSchema.pre('save',async function(){
    try {
        var user = this;
        // Only hash password if it exists (not for Google users)
        if (user.password && user.isModified('password')) {
            const salt = await bcrypt.genSalt(10);
            const hashpass = await bcrypt.hash(user.password, salt);
            user.password = hashpass;
        }
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