const router = require('express').Router();
const UserController = require("../controller/user_controller");

router.post('/registeration', UserController.register);
router.post('/login', UserController.login);
router.post('/Oauth', UserController.googleSignin);
router.post('/forgot-password', UserController.forgotPassword);
router.post('/reset-password', UserController.resetPassword);
router.post('/add-update-contact',UserController.addOrUpdateContact);
module.exports = router;
