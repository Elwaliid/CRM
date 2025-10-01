const router = require('express').Router();
const TaskController = require("../controller/task_controller");

router.post('/add-update-task', TaskController.addOrUpdateTask);
router.get('/get-tasks', TaskController.getTasks);

module.exports = router;
