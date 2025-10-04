const router = require('express').Router();
const UserController = require("../controller/user_controller");
const verifyToken = require('../middleware/auth');

router.post('/registeration', UserController.register);
router.post('/login', UserController.login);
router.post('/Oauth', UserController.googleSignin);
router.post('/forgot-password', UserController.forgotPassword);
router.post('/reset-password', UserController.resetPassword);
router.get('/user', verifyToken, UserController.getUser);
router.post('/send-email', UserController.sendEmail);

module.exports = router;
