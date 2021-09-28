import { LightningElement, track, api } from 'lwc';
import getCreatedData from "@salesforce/apex/DataTestLWC.getCreatedData";

export default class DataImportLWC extends LightningElement {

    @track results;
    @track accountCreated;
    @track usernumber;
    @api isLoaded = false;

    handleClick() {
      //  let inp = this.template.querySelector("lightning-input");
        let inp = this.template.querySelector("[data-id=userIdNumber]");
        this.usernumber = inp.value;
        this.isLoaded = true;
        this.error = '';
        this.accountCreated = '';
        console.log('usernumber' + this.usernumber);
        getCreatedData({ userNumber : this.usernumber })
            .then(result => {
                this.accountCreated = result;
                console.log('result ' + result.data);
                this.isLoaded = false;
            })
            .catch(error => {
                this.error = error.body.message;
                this.isLoaded = false;
            });
    }



}