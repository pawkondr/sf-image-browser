public with sharing class PhotoSchedulable implements System.Schedulable {

    private final String CRON = '0 0 2 * * ? *'; //every night at 2 AM
    private final String JOB_NAME = Test.isRunningTest() ? 'Test' : 'Photo fetch';

    public void execute(SchedulableContext schedulableContext) {
        PhotoService.getPhotosFromApi();
    }

    public Id scheduleJob() {
        return System.schedule(JOB_NAME, CRON, new PhotoSchedulable());
    }

    public void abortJob() {
        System.abortJob(fetchJobId());
    }

    private Id fetchJobId() {
        return new Query('CronTrigger')
            .addConditionIn('CronJobDetailId',
                new Query('CronJobDetail')
                    .addConditionEq('Name', JOB_NAME)
                    .toIdList())
            .toIdList()[0];
    }
}
