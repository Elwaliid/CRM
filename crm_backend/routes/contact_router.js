const router = require('express').Router();
const ContactController = require("../controller/contact_controller");

router.post('/add-update-contact',ContactController.addOrUpdateContact);
module.exports = router;