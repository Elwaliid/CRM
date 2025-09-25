const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');

const taskSchema = new Schema({
  owner: { type: Schema.Types.ObjectId, ref: 'user', required: true },
  title: { type: String, required: true },
  description: { type: String },
  status: { type: String, enum: ['Pending', 'Completed', 'In Process'], default: 'Pending' },
  type: { type: String, enum: ['Call', 'Email', 'Deal', 'Meeting', 'None'], default: 'None' },

  dueDate: { type: Date },
  assignedTo: { type: Schema.Types.ObjectId, ref: 'user' },
  relatedClient: { type: Schema.Types.ObjectId, ref: 'client' },

  emails: {
    type: [String],
    validate: [arr => arr.length <= 2, '{PATH} exceeds the limit of 2'],
  },

  revenue: { type: Number },
  cost: { type: Number },
  createdAt: { type: Date, default: Date.now },
});

const TaskModel = db.model('Task', taskSchema);
module.exports = TaskModel;