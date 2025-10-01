const mongoose = require('mongoose');
const db = require('../config/db');
const { Schema } = mongoose;


const contactSchema = new Schema({
  owner: { type: Schema.Types.ObjectId, ref: 'user' },
  name: { type: String, required: true ,unique: true },
  type: { type: String, enum: ['Client', 'Lead', 'Vendor'], default: 'Client' },

  phones: {
    type: [String], // array of phone numbers
    validate: [arr => arr.length <= 10, '{PATH} exceeds the limit of 10'],
  },
  website: { type: String },
  email: { type: String, required: true, unique: true },
  secondEmail: { type: String },
  address: { type: String },
  identity: { type: String },
  notes: { type: String },
  createdAt: { type: Date, default: Date.now },
});

const ContactModel = db.model('Contact', contactSchema);

module.exports = ContactModel;