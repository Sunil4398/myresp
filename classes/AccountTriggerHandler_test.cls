@Istest
public class AccountTriggerHandler_test {
    public static testMethod void cqinterview(){
        
        // Create a new standard user
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'sunilkumar123@example.com',
            Alias = 'testuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        
        // Set a profile for the user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        testUser.ProfileId = profile.Id;
        insert testUser;
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Account_Admin'];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = testUser.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        
        // Insert the user with the "runAs" method
        System.runAs(testUser) {

        //create Account
        Account account = new Account();
        account.Name = 'test';
        insert account;
        
        List<SQX_Team_Members__c> teammembers = [select id from SQX_Team_Members__c where Account__c =: account.Id];
        Account acc = [select id,Active__c from Account where Id =: account.Id];
        //Assert : check records created
        system.assertEquals(2,teammembers.size(),'Two team members records should create but not created');
        //Assert : check active check box is default false
        system.assertEquals(false,acc.Active__c,'Account active status should be false but true');
         
        //Update Account
		account.Active__c = true;
        database.SaveResult SaveResult = Database.update(Account, false);
        
        //Assert: account should not Active
        system.assertEquals(false, saveresult.isSuccess(), 'Cannot activate account without HR or Admin team member record.');
        
        //update team members
        teammembers[0].Member_Type__c = 'HR';
        update teammembers[0];
        teammembers[1].Member_Type__c = 'Admin';
        update teammembers[1];
        
        //update Account
        account.Active__c = true;
        SaveResult = Database.update(Account, false);
        
        //Assert: account should Inactive
        system.assertEquals(true, saveresult.isSuccess(), 'Account should be active but in inactive');
		
    	}
    }
}