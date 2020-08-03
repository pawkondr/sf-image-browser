@IsTest
public with sharing class EmailServiceTest {

    @IsTest
    public static void shouldSendEmail() {

        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        messages.add(EmailService.createSingleEmailMessage('Test', 'body', new List<String>{
            'test@test.com'
        }));
        EmailService.sendEmails(messages);

        System.assertEquals(true, EmailService.testEmailSent);

    }

    @IsTest
    public static void shouldNotSendEmailAndThrowException() {

        try {
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
            messages.add(EmailService.createSingleEmailMessage('Test', 'body', null));
            EmailService.sendEmails(messages);
            System.assert(false, 'Exception should be thrown');
        } catch (Exception ex) {
            System.assertEquals(false, EmailService.testEmailSent);
        }
    }

}
