const router = require('express').Router();
const UserController = require("../controller/user_controller");
const verifyToken = require('../middleware/auth');
const multer = require('multer');

// Configure multer for file upload
const upload = multer({ storage: multer.memoryStorage() });

router.post('/registeration', UserController.register);
router.post('/login', UserController.login);
router.post('/Oauth', UserController.googleSignin);
router.post('/forgot-password', UserController.forgotPassword);
router.post('/reset-password', UserController.resetPassword);
router.get('/user', verifyToken, UserController.getUser);
router.post('/send-email', UserController.sendEmail);
router.post('/add-update-profile-image', verifyToken, upload.single('image'), UserController.UserProfileImage);
router.get('get-profile-image', verifyToken,UserController.GetProfileImage)
module.exports = router;
