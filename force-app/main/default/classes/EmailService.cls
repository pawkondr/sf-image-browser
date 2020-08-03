public with sharing class EmailService {

    @TestVisible private static Boolean testEmailSent = false;

    public static void sendEmails(List<Messaging.SingleEmailMessage> messages) {

        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) {
            System.debug('The email was sent successfully.');
            if (Test.isRunningTest()) testEmailSent = true;
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }

    public static Messaging.SingleEmailMessage createSingleEmailMessage(String subject, String body, List<String> toAddresses) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSubject(subject);
        message.setHtmlBody(body);
        message.setToAddresses(toAddresses == null ? new List<String>{} : toAddresses);

        return message;
    }
}
