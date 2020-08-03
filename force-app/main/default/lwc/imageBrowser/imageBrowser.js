import { LightningElement, track } from "lwc";
import fetchAlbums from "@salesforce/apex/ImageBrowserController.fetchAlbums";
import fetchPhotosByAlbumId from "@salesforce/apex/ImageBrowserController.fetchPhotosByAlbumId";
import fetchPhotosBySearchQuery from "@salesforce/apex/ImageBrowserController.fetchPhotosBySearchQuery";
import emailPhotos from "@salesforce/apex/ImageBrowserController.emailPhotos";

export default class ImageBrowser extends LightningElement {

  @track albums;
  @track selectedAlbumId;
  @track searchQuery;
  @track emailAddress;
  @track timer;
  @track photos;
  @track error;
  @track loading = true;
  @track showAlbums = true;
  @track showPhotos = false;
  @track toastVisible;
  @track toastVariant;
  @track message;

  connectedCallback() {
    this.getAlbums();
  }

  getAlbums() {
    this.loading = true;
    fetchAlbums()
      .then(result => {
        this.albums = result;
        this.error = null;
      })
      .catch(error => {
        this.albums = null;
        this.error = error;
      })
      .finally(() => {
        this.loading = false;
      });
  }

  async getPhotosByAlbumId() {
    this.photos = null;
    this.loading = true;
    fetchPhotosByAlbumId({ albumId: this.selectedAlbumId })
      .then(result => {
        this.photos = result;
        this.error = null;
      })
      .catch(error => {
        this.photos = null;
        this.error = error;
      })
      .finally(() => {
        this.loading = false;
      });
  }

  getPhotosBySearchQuery(context) {
    context.loading = true;
    fetchPhotosBySearchQuery({ query: context.searchQuery })
      .then(result => {
        context.photos = result;
        context.error = null;
        context.showAlbums = false;
        context.showPhotos = true;
      })
      .catch(error => {
        context.photos = null;
        context.error = error;
      })
      .finally(() => {
        context.loading = false;

      });
  }

  async handleAlbumSelect(event) {
    this.selectedAlbumId = event.detail;
    await this.getPhotosByAlbumId();
    this.showAlbums = false;
    this.showPhotos = true;
  }

  backToAlbums() {
    this.showAlbums = true;
    this.showPhotos = false;
  }

  inputOnChange(event) {
    this[event.target.name] = event.target.value;
  }

  sendEmail() {
    if (!this.emailAddress || !this.emailAddress.includes("@")) {
      this.showToast('error', 'Email address is empty or incorrect');
      return;
    }
    console.log(this.photos);
    if (!this.photos || this.photos.length === 0) {
      this.showToast('error', "Selected photos are empty");
      return;
    }
    this.loading = true;
    emailPhotos({ photos: this.photos, emailAddress: this.emailAddress })
      .then(() => {
        this.showToast('success', "Email sent successfully");
        this.emailAddress = null;
      })
      .catch((error) => {
        this.showToast(false, error);
      })
      .finally(()=> {
        this.loading = false;
      })
  }

  filterPhotos(event) {
    this.searchQuery = event.target.value;
    if (this.searchQuery.length < 3) return;
    clearTimeout(this.timer);
    this.timer = setTimeout(this.getPhotosBySearchQuery, 1000, this);
  }

  showToast(variant, message) {
    this.toastVisible = true;
    this.toastVariant = variant;
    this.message = message;
    setTimeout(() => {
      this.toastVisible = false;
      this.message = null;
      this.toastVariant = null;
    }, 4000);
  }

}
