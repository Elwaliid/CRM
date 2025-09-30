const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');

const taskSchema = new Schema({
  owner: { type: Schema.Types.ObjectId, ref: 'user' },
  title: { type: String, required: true },
  
 
  type: { type: String, enum: ['Call', 'Email', 'Deal', 'Meeting', 'None'], default: 'None' },
  revenue: { type: Number },
  cost: { type: Number },
  dueDate: { type: Date },
  time: { type: String },
  endTime : { type: String },
  relatedContact: { type: Schema.Types.ObjectId, ref: 'Contact' },
  address : { type: String },
  emails: {
    type: [String],
    validate: [arr => arr.length <= 2, '{PATH} exceeds the limit of 2'],
  },
  website : { type: String },
description: { type: String },

   status: { type: String, enum: ['Pending', 'Completed', 'In Process'], default: 'Pending' },
  createdAt: { type: Date, default: Date.now },
});

const TaskModel = db.model('Task', taskSchema);
module.exports = TaskModel;