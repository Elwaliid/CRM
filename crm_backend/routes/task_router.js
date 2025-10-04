const router = require('express').Router();
const TaskController = require("../controller/task_controller");
const auth = require('../middleware/auth');

router.post('/add-update-task', TaskController.addOrUpdateTask);
router.get('/get-tasks', TaskController.getTasks);
router.delete('/delete-task', TaskController.deleteTask);
router.get('/Tasks-Deals-count', auth, ContactController.getTasksDealsCounts);

module.exports = router;
