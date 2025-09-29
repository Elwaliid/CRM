const ClientModel = require('../models/client_model');
const jwt = require('jsonwebtoken');


class ClientService {
 static async existContact(email) {
        try {
            return await ClientModel.findOne({ email });
        } catch (err) {
            throw err;
        }
    }
     static async addContact(  email,second_email,name, adress,identity,phones,website,other_info,type ) {
            try {
                const addContact = new ClientModel({ email,second_email,name,adress,identity,phones,website,other_info,type });
                return await addContact.save();
            } catch (err) {
                throw err;
            }
        }

}
module.exports = ClientService;