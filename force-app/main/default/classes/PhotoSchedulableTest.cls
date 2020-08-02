@IsTest
public with sharing class PhotoSchedulableTest {

    @IsTest
    public static void shouldScheduleClass(){

        Test.setMock(HttpCalloutMock.class, new PhotoServiceTest.PhotoHttpCalloutMock());

        Test.startTest();
        PhotoSchedulable schedulable = new PhotoSchedulable();
        Id jobId = schedulable.scheduleJob();

        Test.stopTest();

        System.assertNotEquals(null, jobId);

        schedulable.abortJob();

        List<Id> jobIds = new Query('CronTrigger')
            .addConditionIn('CronJobDetailId',
                new Query('CronJobDetail')
                    .addConditionEq('Name', 'Test')
                    .toIdList())
            .toIdList();
        System.assertEquals(0, jobIds.size());

    }

}
