const TaskService = require('../services/task_services');

exports.addOrUpdateTask = async (req, res) => {
  try {
    const {id,title,type,revenue,cost,phone,email,relatedTo,dueDate,time,endTime,address,website,description,status,} = req.body;

    let task = null;
    if (id) {
      task = await TaskService.existTask(id);
    }

    if (task == null) {
      // Create new task
      await TaskService.addTask(title,type,revenue,cost,phone,email,relatedTo,dueDate,time,endTime,address,website,description,status);
      res.status(201).json({
        status: true,
        message: `${type} added successfully`,
      });
    } else {
      // Update existing task
      await TaskService.updateTask(
        id,title,type,revenue,cost,phone,email,relatedTo,dueDate,time,endTime,address,website,description,status);
      res.status(200).json({ status: true, message: "Task updated successfully" });
    }
  } catch (err) {
    console.error("Task error:", err);
    res.status(500).json({ status: false, message: "Internal server error" });
  }
};

exports.getTasks = async (req, res) => {
  try {
    const tasks = await TaskService.getTasks();
    res.status(200).json({
      status: true,
      tasks: tasks,
    });
  } catch (err) {
    console.error("Get tasks error:", err);
    res.status(500).json({ status: false, message: "Internal server error" });
  }
};
