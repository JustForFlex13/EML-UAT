@isTest 
public class Convsta_AttachConventionFromEmailTest {
    @testSetup
    static void setup(){        
        Contact etudiant =      TestDataFactory.getContact();
        etudiant.FirstName =    'Etudiant';
        etudiant.LastName =     'EM';
        etudiant.Email =        'testEtudiant@test.com';
        insert etudiant;
    }

    @isTest 
    static void success() {
        Contact etudiant = [SELECT Id
                            FROM Contact
                            WHERE FirstName = 'Etudiant'];

        Case demande = TestObjectFactory.createCase(etudiant);
        demande.RecordTypeId    = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        demande.Convsta_Type_de_demande__c = 'Stage';
        demande.Convsta_TypeContrat__c  = 'Convention de stage de l ecole';
        insert demande;

        demande =  [SELECT Id, CaseNumber
                    FROM Case
                    LIMIT 1];

        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        email.subject = 'Test Subject';
        email.fromName = 'Test Name';
        email.plainTextBody = 'Hello, this a test email body.';
        Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];  
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        String fileName = 'convention-' + demande.CaseNumber + '.pdf';
        binaryAttachment.Filename = fileName;
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('Test'), Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        envelope.fromAddress = 'test@email.com';    


        Test.startTest();
        Convsta_AttachConventionFromEmail catcher = new Convsta_AttachConventionFromEmail();
        Messaging.InboundEmailResult result = catcher.handleInboundEmail(email, envelope);
        Test.stopTest();

        List<ContentDocumentLink> lFile = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :demande.Id];
        demande = [SELECT Convsta_ConventionDocumentId__c  FROM Case WHERE Id =:demande.Id];

        System.assertNotEquals(0, lFile.size());
        System.assertEquals(lFile[0].ContentDocumentId, demande.Convsta_ConventionDocumentId__c);
    }

    @isTest 
    static void caseNotFound() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        email.subject = 'Test Subject';
        email.fromName = 'Test Name';
        email.plainTextBody = 'Hello, this a test email body.';
        Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];  
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        String fileName = 'convention' + 'XXXXXXX' + '.pdf';
        binaryAttachment.Filename = fileName;
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('Test'), Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        envelope.fromAddress = 'test@email.com';    


        Test.startTest();
        Convsta_AttachConventionFromEmail catcher = new Convsta_AttachConventionFromEmail();
        Messaging.InboundEmailResult result = catcher.handleInboundEmail(email, envelope);
        Test.stopTest();

        //Nothing to test
    }
}