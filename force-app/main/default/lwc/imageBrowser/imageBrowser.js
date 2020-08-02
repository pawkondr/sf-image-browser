import { LightningElement, track } from "lwc";
import fetchAlbums from "@salesforce/apex/ImageBrowserController.fetchAlbums";
import fetchPhotosByAlbumId from "@salesforce/apex/ImageBrowserController.fetchPhotosByAlbumId";
import fetchPhotosBySearchQuery from "@salesforce/apex/ImageBrowserController.fetchPhotosBySearchQuery";

export default class ImageBrowser extends LightningElement {

  @track albums;
  @track selectedAlbumId;
  @track searchQuery;
  @track timer;
  @track photos;
  @track error;
  @track showAlbums = true;
  @track showPhotos = false;

  connectedCallback() {
    this.getAlbums();
  }

  getAlbums() {
    fetchAlbums()
      .then(result => {
        this.albums = result;
        this.error = null;
      })
      .catch(error => {
        this.albums = null;
        this.error = error;
      });
  }

  async getPhotosByAlbumId() {
    fetchPhotosByAlbumId({ albumId: this.selectedAlbumId })
      .then(result => {
        this.photos = result;
        this.error = null;
      })
      .catch(error => {
        this.photos = null;
        this.error = error;
      });
  }

  getPhotosBySearchQuery() {
    fetchPhotosBySearchQuery({ query: this.searchQuery })
      .then(result => {
        this.photos = result;
        this.error = null;
        this.showAlbums = false;
        this.showPhotos = true;
      })
      .catch(error => {
        this.photos = null;
        this.error = error;
      });
    console.log(this.error);
    console.log(this.photos);
  }

  async handleAlbumSelect(event){
    this.selectedAlbumId = event.detail;
    await this.getPhotosByAlbumId();
    this.showAlbums = false;
    this.showPhotos = true;
  }

  backToAlbums(){
    this.showAlbums = true;
    this.showPhotos = false;
  }

  filterPhotos(event){
    this.searchQuery = event.target.value;
    if (this.searchQuery.length > 3) this.getPhotosBySearchQuery();
  }

}
