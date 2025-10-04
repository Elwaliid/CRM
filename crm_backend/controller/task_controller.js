const TaskService = require('../services/task_services');

exports.addOrUpdateTask = async (req, res) => {
  try {
    const {id,owner,title,type,revenue,cost,phone,email,isMeet,relatedToNames,relatedToIds,dueDate,time,endTime,address,website,description,status,} = req.body;

    let task = null;
    if (id) {
      task = await TaskService.existTask(id);
    }

    if (task == null) {
      // Create new task
      await TaskService.addTask(owner,title,type,revenue,cost,phone,email,isMeet,relatedToNames,relatedToIds,dueDate,time,endTime,address,website,description,status);
      res.status(201).json({
        status: true,
        message: `${type} added successfully`,
      });
    } else {
      // Update existing task
      await TaskService.updateTask(
        id,title,type,revenue,cost,phone,email,isMeet,relatedToNames,relatedToIds,dueDate,time,endTime,address,website,description,status);
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

exports.deleteTask = async (req, res) => {
    try{
    const { id } = req.body;
    const task = await TaskService.existTask(id);
    if(!task){res.status(404).json({ status: false, message: "Task  not found" }); return;}
    await TaskService.deleteIt(id); 
    res.status(200).json({ status: true, message: "Task deleted successfully" });
    }catch(err){console.error("Delete task error:", err);}
}
exports.getTasksDealsCounts = async (req, res) => {
    try {
      
       
        const tasksCount = await TaskService.getTasksDealsCountToday( 'notDeal');
        const dealsCount = await TaskService.getTasksDealsCountToday( 'Deal');
        res.status(200).json({
            status: true,
            counts: {
                tasks: tasksCount,
                deals: dealsCount
            }
        });
    } catch (err) {
        console.error("Tasks counts error:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
}