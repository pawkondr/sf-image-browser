@IsTest
public with sharing class ImageBrowserControllerTest {

    @IsTest
    public static void shouldFetchAlbums() {
        Album__c album1 = new Album__c(Album_External_Id__c = '1');
        Album__c album2 = new Album__c(Album_External_Id__c = '2');
        Album__c album3 = new Album__c(Album_External_Id__c = '3');

        insert new List<Album__c>{
            album1, album2, album3
        };

        List<Album__c> fetchedAlbums = ImageBrowserController.fetchAlbums();

        System.assertEquals(3, fetchedAlbums.size());
    }

    @IsTest
    public static void shouldFetchPhotoByAlbum() {
        Album__c album1 = new Album__c(Album_External_Id__c = '1');
        Album__c album2 = new Album__c(Album_External_Id__c = '2');

        insert new List<Album__c>{
            album1, album2
        };

        Photo__c photo1 = new Photo__c(Photo_External_Id__c = '1', Album__c = album1.Id, Title__c = 'Test1');
        Photo__c photo2 = new Photo__c(Photo_External_Id__c = '2', Album__c = album1.Id, Title__c = 'Test2');
        Photo__c photo3 = new Photo__c(Photo_External_Id__c = '3', Album__c = album2.Id, Title__c = 'Test3');
        Photo__c photo4 = new Photo__c(Photo_External_Id__c = '4', Album__c = album2.Id, Title__c = 'Test4');

        insert new List<Photo__c>{
            photo1, photo2, photo3, photo4
        };

        List<Photo__c> fetchedPhotos = ImageBrowserController.fetchPhotosByAlbumId(album1.Id);

        System.assertEquals(2, fetchedPhotos.size());
    }

    @IsTest
    public static void shouldFetchPhotoByTitle() {
        Album__c album1 = new Album__c(Album_External_Id__c = '1');
        Album__c album2 = new Album__c(Album_External_Id__c = '2');

        insert new List<Album__c>{
            album1, album2
        };

        Photo__c photo1 = new Photo__c(Photo_External_Id__c = '1', Album__c = album1.Id, Title__c = 'Test');
        Photo__c photo2 = new Photo__c(Photo_External_Id__c = '2', Album__c = album1.Id, Title__c = 'A big Test');
        Photo__c photo3 = new Photo__c(Photo_External_Id__c = '3', Album__c = album2.Id, Title__c = 'Testing');
        Photo__c photo4 = new Photo__c(Photo_External_Id__c = '4', Album__c = album2.Id, Title__c = 'Not');

        insert new List<Photo__c>{
            photo1, photo2, photo3, photo4
        };

        List<Photo__c> fetchedPhotos = ImageBrowserController.fetchPhotosBySearchQuery('Test');

        System.assertEquals(3, fetchedPhotos.size());
    }

    @IsTest
    public static void shouldSendEmailWithPhotos() {
        Album__c album1 = new Album__c(Album_External_Id__c = '1');

        insert new List<Album__c>{
            album1
        };

        Photo__c photo1 = new Photo__c(Photo_External_Id__c = '1', Album__c = album1.Id, Title__c = 'Test1');
        Photo__c photo2 = new Photo__c(Photo_External_Id__c = '2', Album__c = album1.Id, Title__c = 'Test2');

        List<Photo__c> photos = new List<Photo__c>{
            photo1, photo2
        };

        insert photos;

        ImageBrowserController.emailPhotos(photos, 'test@test.com');

        System.assertEquals(true, EmailService.testEmailSent);
    }

    @IsTest
    public static void shouldNotSendEmailAndThrowException() {
        Album__c album1 = new Album__c(Album_External_Id__c = '1');

        insert new List<Album__c>{
            album1
        };

        Photo__c photo1 = new Photo__c(Photo_External_Id__c = '1', Album__c = album1.Id, Title__c = 'Test1');
        Photo__c photo2 = new Photo__c(Photo_External_Id__c = '2', Album__c = album1.Id, Title__c = 'Test2');

        List<Photo__c> photos = new List<Photo__c>{
            photo1, photo2
        };

        insert photos;

        try{
            ImageBrowserController.emailPhotos(photos, null);
            System.assert(false, 'Exception should be thrown');
        } catch (Exception ex) {
            System.assert(ex instanceof AuraHandledException);
        }

        System.assertEquals(false, EmailService.testEmailSent);
    }

}
