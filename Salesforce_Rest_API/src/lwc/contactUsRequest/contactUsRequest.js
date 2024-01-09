/**
 * @description       : 
 * @author            : ilgyu.jeon@dkbmc.com
 * @group             : 
 * @last modified on  : 10-02-2023
 * @last modified by  : ilgyu.jeon@dkbmc.com
**/

import { LightningElement, track, wire} from 'lwc';

// apex class
import getCategoryPickList from '@salesforce/apex/ContactUsRequestController.getCategoryPickList';
import doSubmit from '@salesforce/apex/ContactUsRequestController.doSubmit';

const emailReg = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
export default class ContactUsRequest extends LightningElement {
    
    categoryList;           // Category List
    category;
    email;
    subject;
    description;
    @track files = [];      // file List
    @track emailItem = [];  // email variable

    /* Function to dynamically retrieve picklist values */
    @wire(getCategoryPickList)
    callCategoryList({data, error}) {
        if(data) {
            this.categoryList = [];
            data.forEach(category => {
                this.categoryList.push({label : category, value : category});
            });
        } else {
            console.log('error =>  ', error);
        }
    } // callCateforyList()

    connectedCallback() {
        console.log('connectedCallback function');
    }
    
    /* Set Value function */
    handleCategory(e)   {this.category = e.target.value;}   // handleCategory()
    setEmail(e)         {this.email = e.target.value;}      // setEmail()
    setSubject(e)       {this.subject = e.target.value;}    // setSubject();
    setDescription(e)   {this.description = e.target.value;}// setDescription();

    /* Add CC email */
    setCCEmail(e) {
        if(e.keyCode != 13) return;
        if(e.target.value.match(emailReg)){
            var isOverlap = false;
            this.emailItem.some(email => {
                if(email == e.target.value) {
                    isOverlap = true;
                    return true;
                }
            });
            
            if (isOverlap) {
                this.template.querySelector('c-util-toast').showToast('Email', 'This email already exists.', 'warning'); 
                return;
            } 
            this.emailItem.push(e.target.value);
            e.target.value = '';
        } else this.template.querySelector('c-util-toast').showToast('Email', 'The email format is incorrect.', 'warning');
    }

    /* remove pill */
    handlePillRemove(e) {
        this.emailItem = this.emailItem.filter((email) => email != e.target.label);
    } // handlePillRemove()

    /* file upload finished function */
    handleUploadFinished(e) {
        console.log(e.detail.files);
        e.detail.files.forEach(file => {
            console.log('file =>  ', file);
            this.files.push(file);
        })
        console.log('this.files =>  ', JSON.parse(JSON.stringify(this.files)));
    } // handleUploadFinished()

    /* remove file */
    handleFileRemove(e) {
        this.files = this.files.filter((file) => file.name != e.target.label);
    } // handleFileRemove()

    doSubmit() {
        this.template.querySelector('.submit-btn').disabled = true;

        if(this.category == undefined) {
            this.template.querySelector('c-util-toast').showToast('Category', 'Please choose a category', 'error');
            this.template.querySelector('.category').scrollIntoView({behavior: "smooth", block: "end", inline: "nearest"}); 
            return;
        } else if(this.email == undefined) {
            this.template.querySelector('c-util-toast').showToast('Email', 'Please enter your email.', 'error');
            this.template.querySelector('.email').scrollIntoView({behavior: "smooth", block: "end", inline: "nearest"}); 
            return;
        } else if(!this.email.match(emailReg)) {
            this.template.querySelector('c-util-toast').showToast('Email', 'The email format is incorrect.', 'error');
            this.template.querySelector('.email').scrollIntoView({behavior: "smooth", block: "end", inline: "nearest"}); 
            return;
        } else if(this.subject == undefined) {
            this.template.querySelector('c-util-toast').showToast('Subject', 'Please enter the subject.', 'error');
            this.template.querySelector('.subject').scrollIntoView({behavior: "smooth", block: "start", inline: "nearest"}); 
            return;
        } else if(this.description == undefined) {
            this.template.querySelector('c-util-toast').showToast('Description', 'Please enter the description.', 'error');
            this.template.querySelector('.description').scrollIntoView({behavior: "smooth", block: "start", inline: "nearest"}); 
            return;
        } else {
            console.log('do Submit!!');
            var paramMap = {
                  category    : this.category
                , email       : this.email
                , subject     : this.subject
                , description : this.description
                , files       : this.files.length != 0 ? this.files : null
                , emailItem   : this.emailItem.length != 0 ? this.emailItem : null
            }

            console.log(JSON.parse(JSON.stringify(paramMap)));
            doSubmit({paramMap : paramMap})
            .then(res => {
                console.log(' =>  ', res);
                this.template.querySelector('c-util-toast').showToast('Success', 'Record creation successful', 'success');
                setTimeout(() => {
                    this.template.querySelector('.submit-btn').disabled = false;
                  }, 2000);
            }).catch(error => {
                console.log('catch error =>  ', error);
            })

        }
    }
} // ilgyu