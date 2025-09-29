const mongoose = require('mongoose');
const db = require('../config/db');
const { Schema } = mongoose;


const clientSchema = new Schema({
  owner: { type: Schema.Types.ObjectId, ref: 'user', required: true },
  name: { type: String, required: true },
  type: { type: String, enum: ['Client', 'Lead', 'Vendor'], default: 'Client' },

  phones: {
    type: [String], // array of phone numbers
    validate: [arr => arr.length <= 10, '{PATH} exceeds the limit of 10'],
  },

  emails: {
    type: [String],
    validate: [arr => arr.length <= 2, '{PATH} exceeds the limit of 2'],
  },

  company: { type: String },
  notes: { type: String },
  createdAt: { type: Date, default: Date.now },
});

const ClientModel = db.model('Client', clientSchema);

module.exports = ClientModel;