const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');

const taskSchema = new Schema({
  owner: { type: Schema.Types.ObjectId, ref: 'user' },
  title: { type: String, required: true },
  type: { type: String },
  revenue: { type: Number },
  cost: { type: Number },
  phone: { type: String },
  email: { type: String },
  relatedTo: { type: [String], required: true , ref: 'Contact' },
  dueDate: { type: String },
  time: { type: String },
  endTime: { type: String },
  address: { type: String },
  website: { type: String },
  description: { type: String },
  status: { type: String, default: 'Pending' },
  createdAt: { type: Date, default: Date.now },
});

const TaskModel = db.model('Task', taskSchema);
module.exports = TaskModel;