const router = require('express').Router();
const UserService = require("../services/user_services");
const UserController = require("../controller/user_controller");

router.post('/registeration', UserController.register);
router.post('/login', UserController.login);

router.post("/googleLogin", async (req, res) => {
  try {
    console.log("Received token from client:", req.body.accessToken?.slice(0,20)); 
    const result = await UserService.loginWithGoogleAccessToken(req.body.accessToken);
    res.json(result);
  } catch (err) {
    console.error("Google login error:", err.response?.data || err.message || err);
    res.status(500).json({ error: "Google login failed", details: err.message });
  }
});
router.post("/appleLogin", UserController.appleLogin);

module.exports = router;
