const router = require('express').Router();
const UserService = require("../services/user_services");
const UserController = require("../controller/user_controller");

router.post('/registeration', UserController.register);
router.post('/login', UserController.login);

router.post("/googleLogin", async (req, res) => {
  try {
    const accessToken = req.body.accessToken;
    console.log("Received token from client:", accessToken?.slice(0, 20));

    if (!accessToken) {
      return res.status(400).json({ error: "No access token provided" });
    }

    const result = await UserService.loginWithGoogleAccessToken(accessToken);

    res.json(result);
  } catch (err) {
    console.error(
      "Google login error:",
      err.response?.data || err.message || err
    );
    res.status(500).json({
      error: "Google login failed",
      details: err.message,
    });
  }
});
router.post("/appleLogin", UserController.appleLogin);

module.exports = router;
