import { LightningElement, api } from "lwc";

export default class CustomToast extends LightningElement {

  @api toastVisible = false;
  @api toastVariant = ''
  @api message = ''

  get cssClass () {
    console.log(this.toastVariant);
    if (this.toastVariant === 'success') {
      return 'toast show-success';
    } else {
      return 'toast show-error';
    }
  }
}
