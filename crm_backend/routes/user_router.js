const router = require('express').Router();
const UserController = require("../controller/user_controller");

router.post('/registeration', UserController.register);
router.post('/login', UserController.login);
module.exports = router;
