const router = require('express').Router();
const ContactController = require("../controller/contact_controller");
const auth = require('../middleware/auth');

router.post('/add-update-contact',ContactController.addOrUpdateContact);
router.get('/get-contacts', ContactController.getContacts);
router.delete('/delete-Contact', ContactController.deleteContact);
router.get('/Clients-count', auth, ContactController.getClientsCounts);

module.exports = router;
