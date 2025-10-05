const router = require('express').Router();
const TaskController = require("../controller/task_controller");


router.post('/add-update-task', TaskController.addOrUpdateTask);
router.get('/get-tasks', TaskController.getTasks);
router.delete('/delete-task', TaskController.deleteTask);
router.get('/Tasks-Count', TaskController.getTasksDealsCounts);

module.exports = router;
