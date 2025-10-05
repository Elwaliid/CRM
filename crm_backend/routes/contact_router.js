const router = require('express').Router();
const ContactController = require("../controller/contact_controller");


router.post('/add-update-contact',ContactController.addOrUpdateContact);
router.get('/get-contacts', ContactController.getContacts);
router.delete('/delete-Contact', ContactController.deleteContact);
router.get('/Clients-count', ContactController.getClientsCounts);
router.get('/clients-count-month', ContactController.getClientsCountByMonth);

module.exports = router;
