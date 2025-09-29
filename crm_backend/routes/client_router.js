const router = require('express').Router();
const ClientController = require("../controller/client_controller");

router.post('/add-update-contact',ClientController.addOrUpdateContact);
module.exports = router;