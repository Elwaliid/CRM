const TaskModel = require('../models/task_model');

class TaskService {
  static async existTask(id) {
    try {
      return await TaskModel.findById(id);
    } catch (err) {
      throw err;
    }
  }

  static async addTask(owner,title,type,revenue,cost,phone,email,isMeet,relatedToNames,relatedToIds,dueDate,time,endTime,address,website,description,status) {
    try {
      const addTask = new TaskModel({owner,title,type,revenue,cost,phone,email,isMeet,relatedToNames,relatedToIds,dueDate,time,endTime,address,website,description,status,});
      return await addTask.save();
    } catch (err) {
      throw err;
    }
  }

  static async updateTask(id,title,type,revenue,cost,phone,email,isMeet,relatedToNames,relatedToIds,dueDate,time,endTime,address,website,description,status) {
    try {
      const task = await TaskModel.findById(id);
      if (!task) throw new Error('Task not found');
      task.title = title;
      task.type = type;
      task.revenue = revenue;
      task.cost = cost;
      task.phone = phone;
      task.email = email;
      task.isMeet = isMeet;
      task.relatedToNames = relatedToNames;
      task.relatedToIds = relatedToIds;
      task.dueDate = dueDate;
      task.time = time;
      task.endTime = endTime;
      task.address = address;
      task.website = website;
      task.description = description;
      task.status = status;
      await task.save();
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

  static async deleteTask(id) {
    try {
      return await TaskModel.findByIdAndDelete(id);
    } catch (err) {
      throw err;
    }
  }
  static async deleteIt(id) {
        try{
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
            // If typeFilter is none of the above, count all tasks

            return await TaskModel.countDocuments(query);
        } catch (err) {
            throw err;
        }
    }

}

module.exports = TaskService;
