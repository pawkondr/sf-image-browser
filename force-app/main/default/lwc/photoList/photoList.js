import { LightningElement, api, track } from "lwc";

export default class PhotoList extends LightningElement {

  @api photos

  get showPictures(){
    if (!this.photos || this.photos.length === 0) {
      return false;
    }
    return true;
  }
}
