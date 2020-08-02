public with sharing class PhotoService {

    private static final String ENDPOINT = 'https://jsonplaceholder.typicode.com/photos';

    @Future(Callout = true)
    public static void getPhotosFromApi(){

        List<Album__c> albums = new List<Album__c>();
        List<Photo__c> photos = new List<Photo__c>();

        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('GET');

        Http http = new Http();
        HttpResponse response = http.send(request);

        List<PhotoJson> photoJsons = (List<PhotoJson>)JSON.deserialize(response.getBody(), List<PhotoJson>.class);

        for (PhotoJson photoJson : photoJsons){
            Photo__c photo = createPhoto(photoJson);
            Album__c album = createAlbum(photoJson.albumId);
            photo.Album__r = album;
            photos.add(photo);
            if (!albums.contains(album)) albums.add(album);
        }

        upsert albums Album_External_Id__c;
        upsert photos Photo_External_Id__c;

    }

    private static Album__c createAlbum(String externalId){
        return new Album__c(Album_External_Id__c = externalId);
    }

    private static Photo__c createPhoto(PhotoJson photoJson){
        return new Photo__c(
            Photo_External_Id__c = photoJson.id,
            Title__c = photoJson.title,
            URL__c = photoJson.url,
            Thumbnail_URL__c = photoJson.thumbnailUrl
        );
    }

    private class PhotoJson {
        private String albumId;
        private String id;
        private String title;
        private String url;
        private String thumbnailUrl;
    }

}
