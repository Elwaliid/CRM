const router = require('express').Router();
const UserController = require("../controller/user_controller");

router.post('/registeration', UserController.register);

module.exports = router;
