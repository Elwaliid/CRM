const TaskModel = require('../models/task_model');
const UserModel = require('../models/user_model');
const UserService = require('./user_services');

class TaskService {
  static async existTask(id) {
    try {
      return await TaskModel.findById(id);
    } catch (err) {
      throw err;
    }
  }

  static async addTask(owner,title,type,revenue,cost,phone,email,isMeet,relatedToNames,relatedToIds,dueDate,time,endTime,address,website,description,status,isPined) {
    try {
      const addTask = new TaskModel({owner,title,type,revenue,cost,phone,email,isMeet,relatedToNames,relatedToIds,dueDate,time,endTime,address,website,description,status,isPined});
      const savedTask = await addTask.save();

      const user = await UserModel.findById(owner);
      if (!user) throw new Error('Owner not found');

      const historyAction = `${user.name} added a Task named ${title}`;
      const ActionDate = new Date();
      await UserService.addActionToHistory(owner, historyAction, ActionDate);

      return savedTask;
    } catch (err) {
      throw err;
    }
  }

  static async updateTask(owner,id,title,type,revenue,cost,phone,email,isMeet,relatedToNames,relatedToIds,dueDate,time,endTime,address,website,description,status,isPined) {
    try {
      const task = await TaskModel.findById(id);
      if (!task) throw new Error('Task not found');

      const oldStatus = task.status;

      if (title !== undefined) task.title = title;
      if (type !== undefined) task.type = type;
      if (revenue !== undefined) task.revenue = revenue;
      if (cost !== undefined) task.cost = cost;
      if (phone !== undefined) task.phone = phone;
      if (email !== undefined) task.email = email;
      if (isMeet !== undefined) task.isMeet = isMeet;
      if (relatedToNames !== undefined) task.relatedToNames = relatedToNames;
      if (relatedToIds !== undefined) task.relatedToIds = relatedToIds;
      if (dueDate !== undefined) task.dueDate = dueDate;
      if (time !== undefined) task.time = time;
      if (endTime !== undefined) task.endTime = endTime;
      if (address !== undefined) task.address = address;
      if (website !== undefined) task.website = website;
      if (description !== undefined) task.description = description;
      if (status !== undefined) task.status = status;
      if (isPined !== undefined) task.isPined = isPined;

      await task.save();

      const user = await UserModel.findById(owner);
      if (!user) throw new Error('Owner not found');

      let historyAction = `${user.name} updated a Task named ${task.title}`;
      if (status !== undefined && oldStatus !== status) {
        historyAction += ` to ${status}`;
      }

      const ActionDate = new Date();
      await UserService.addActionToHistory(owner, historyAction, ActionDate);

      return task;
    } catch (err) {
      throw err;
    }
  }

  static async getTasks() {
    try {
      return await TaskModel.find();
    } catch (err) {
      throw err;
    }
  }

  static async deleteIt(id, owner) {
        try{
            const task = await TaskModel.findById(id);
            if (!task) throw new Error('Task not found');

            const user = await UserModel.findById(owner);
            if (!user) throw new Error('Owner not found');

            const historyAction = `${user.name} deleted a Task named ${task.title}`;
            const ActionDate = new Date();
            await UserService.addActionToHistory(owner, historyAction, ActionDate);

            return await TaskModel.findByIdAndDelete(id);
        }catch (err) {  throw err;}
    }

    static async getTasksCount(typeFilter) {
        try {
            const today = new Date().toISOString().split('T')[0]; // 'YYYY-MM-DD'

            let query = {};

            if (typeFilter === 'Deal' || typeFilter === 'notDeal') {
                query.dueDate = today;
            }

            if (typeFilter === 'Completed') {
                query.status = 'Completed';
            } else if (typeFilter === 'Pending') {
                query.status = 'Pending';
            } else if (typeFilter === 'Deal') {
                query.type = 'Deal';
            } else if (typeFilter === 'notDeal') {
                query.type = { $ne: 'Deal' };
            }

            return await TaskModel.countDocuments(query);
        } catch (err) {
            throw err;
        }
    }

}

module.exports = TaskService;
