@IsTest
public with sharing class PhotoServiceTest {

    @IsTest
    private static void shouldCallApiGetJsonAndInsertObjects(){

        Test.setMock(HttpCalloutMock.class, new PhotoHttpCalloutMock());

        PhotoService.getPhotosFromApi();

        List<Album__c> albums = new Query(Album__c.SObjectType).run();
        List<Photo__c> photos = new Query(Photo__c.SObjectType).run();

        System.assertEquals(3, albums.size());
        System.assertEquals(6, photos.size());
    }

    public class PhotoHttpCalloutMock implements HttpCalloutMock {

        private final String TEST_JSON = '[\n' +
            '  {\n' +
            '    "albumId": 1,\n' +
            '    "id": 1,\n' +
            '    "title": "accusamus beatae ad facilis cum similique qui sunt",\n' +
            '    "url": "https://via.placeholder.com/600/92c952",\n' +
            '    "thumbnailUrl": "https://via.placeholder.com/150/92c952"\n' +
            '  },\n' +
            '  {\n' +
            '    "albumId": 1,\n' +
            '    "id": 2,\n' +
            '    "title": "reprehenderit est deserunt velit ipsam",\n' +
            '    "url": "https://via.placeholder.com/600/771796",\n' +
            '    "thumbnailUrl": "https://via.placeholder.com/150/771796"\n' +
            '  },\n' +
            '  {\n' +
            '    "albumId": 2,\n' +
            '    "id": 3,\n' +
            '    "title": "officia porro iure quia iusto qui ipsa ut modi",\n' +
            '    "url": "https://via.placeholder.com/600/24f355",\n' +
            '    "thumbnailUrl": "https://via.placeholder.com/150/24f355"\n' +
            '  },\n' +
            '  {\n' +
            '    "albumId": 2,\n' +
            '    "id": 4,\n' +
            '    "title": "culpa odio esse rerum omnis laboriosam voluptate repudiandae",\n' +
            '    "url": "https://via.placeholder.com/600/d32776",\n' +
            '    "thumbnailUrl": "https://via.placeholder.com/150/d32776"\n' +
            '  },\n' +
            '  {\n' +
            '    "albumId": 3,\n' +
            '    "id": 5,\n' +
            '    "title": "natus nisi omnis corporis facere molestiae rerum in",\n' +
            '    "url": "https://via.placeholder.com/600/f66b97",\n' +
            '    "thumbnailUrl": "https://via.placeholder.com/150/f66b97"\n' +
            '  },\n' +
            '  {\n' +
            '    "albumId": 3,\n' +
            '    "id": 6,\n' +
            '    "title": "accusamus ea aliquid et amet sequi nemo",\n' +
            '    "url": "https://via.placeholder.com/600/56a8c2",\n' +
            '    "thumbnailUrl": "https://via.placeholder.com/150/56a8c2"\n' +
            '  }' +
            ']';

        public HttpResponse respond(HttpRequest request){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody(TEST_JSON);
            response.setStatusCode(200);

            return response;
        }
    }


}
