trigger Account_Trigger on Account (before update) {
    for(Account acc:trigger.New){
         if(Trigger.isbefore && Trigger.isUpdate )
        {
            Account_Handler.methodname(trigger.new);
        }
	}
}