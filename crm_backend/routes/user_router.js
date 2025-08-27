const router = require('express').Router();
const UserService = require("../services/user_services");
const UserController = require("../controller/user_controller");

router.post('/registeration', UserController.register);
router.post('/login', UserController.login);

router.post("/google-login", async (req, res) => {
  try {
    const { accessToken } = req.body;

    if (!accessToken) {
      return res.status(400).json({ error: "Access token is required" });
    }

    console.log("Received token from client:", accessToken);

    // Call service
    const { user, token } = await UserService.loginWithGoogleAccessToken(accessToken);

    return res.status(200).json({
      message: "Google login successful",
      user,
      token,
    });

  } catch (err) {
    console.error("Google login error:", err.message);
    return res.status(500).json({ error: err.message });
  }
});
router.post("/appleLogin", UserController.appleLogin);

module.exports = router;
