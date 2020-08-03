public with sharing class ImageBrowserController {

    @AuraEnabled
    public static List<Album__c> fetchAlbums(){
        return new Query(Album__c.SObjectType)
            .selectAllFields()
            .run();
    }

    @AuraEnabled
    public static List<Photo__c> fetchPhotosByAlbumId(Id albumId){
        return new Query(Photo__c.SObjectType)
            .selectAllFields()
            .lookup('Album__c', albumId)
            .run();
    }

    @AuraEnabled
    public static List<Photo__c> fetchPhotosBySearchQuery(String query){
        return new Query(Photo__c.SObjectType)
            .selectAllFields()
            .addConditionLike(Photo__c.Title__c, '%' + query + '%')
            .run();
    }

    @AuraEnabled
    public static void emailPhotos (List<Photo__c> photos, String emailAddress){
        try {
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
            messages.add(EmailService.createSingleEmailMessage('Selected photos', createEmailBody(photos), new List<String>{emailAddress}));
            EmailService.sendEmails(messages);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    private static String createEmailBody(List<Photo__c> photos){
        String body = '';
        for (Photo__c photo : photos){
            body += '<img src="' + photo.Thumbnail_URL__c + '" />';
            body += '<a href = "' + photo.URL__c +  '"> <h4>' + photo.Title__c + ' </h4></a>';
        }

        return body;
    }
}
