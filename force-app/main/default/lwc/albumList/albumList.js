import { LightningElement, api } from "lwc";

export default class AlbumList extends LightningElement {
  @api albums;

  handleClick(event){
    const albumId = event.target.dataset["sfid"];
    this.dispatchEvent(new CustomEvent('selectedalbum', {detail: albumId}));
  }

}
