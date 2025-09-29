const ClientModel = require('../models/client_model');
const jwt = require('jsonwebtoken');


class ClientService {
 static async existContact(email) {
        try {
            return await ClientModel.findOne( email );
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
            static async updateContact(email,second_email,name, adress,identity,phones,website,other_info,type ) {
                try{
                    const contact = ClientModel.findOne( email );
                    if(!contact) throw new Error('Contact not found');
                    contact.email = email;
                    contact.second_email = second_email;
                    contact.name = name;
                    contact.adress = adress;
                    contact.identity = identity;
                    contact.phones = phones;
                    contact.website = website;
                    contact.notes = other_info;
                    contact.type = type;
                    await contact.save();
                    return contact;
                }catch (err) {  throw err;}
            }

}
module.exports = ClientService;