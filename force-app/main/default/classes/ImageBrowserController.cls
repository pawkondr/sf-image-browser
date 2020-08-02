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

}
