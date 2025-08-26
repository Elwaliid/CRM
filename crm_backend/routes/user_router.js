const router = require('express').Router();
const UserController = require("../controller/user_controller");

router.post('/registeration', UserController.register);
router.post('/login', UserController.login);

router.post('/googleLogin', async (req, res) => {
    try {
        const { accessToken } = req.body;
        if (!accessToken) {
            return res.status(400).json({ error: "Access token is required" });
        }

        const result = await UserService.loginWithGoogleAccessToken(accessToken);
        res.json(result);
    } catch (err) {
        console.error("Google login error:", err.message);
        res.status(500).json({ error: "Google login failed" });
    }
});
router.post("/appleLogin", UserController.appleLogin);

module.exports = router;
