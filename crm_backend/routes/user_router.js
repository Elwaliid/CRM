const router = require('express').Router();
const UserController = require("../controller/user_controller");

router.post('/registeration', UserController.register);
router.post('/login', UserController.login);

router.post("/googleLogin", UserController.googleLogin);
router.post("/appleLogin", UserController.appleLogin);

module.exports = router;
