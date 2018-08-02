public class BusinessPlanNotifyPartnersWhenApproved {
    
   /* public static void postOnChatter(List<Business_Plan__c> Plans)
    {
        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
        Integer MAXSIZE = 10 ;// Select Your size
        for (Business_Plan__c plan : Plans) {
            //  initialize the FeedItemInput
            ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
            input.subjectId = plan.Id;
            
            // initialize the body of the chatter post
            ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
            body.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            // add the mention to the post
            ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
            mentionSegment.id = plan.OwnerId;
            body.messageSegments.add(mentionSegment);
            
            // add the text containing the Product Name and the tracking information
            ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
            textSegment.text = 'Congratulations, the plan you submitted has been approved';
            body.messageSegments.add(textSegment);
            
            input.body = body;
            ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
            
            // add the FeedItemInput instances to a list
            batchInputs.add(batchInput);
            
            // postFeedElementBatch() method can process maximum of 500 feeds at a time
            // if the feeds are 500, post them and re-instantiate the list
            if(batchInputs.size() == MAXSIZE){
                ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
                batchInputs = new List<ConnectApi.BatchInput>();
            }
        }
        // post the feeds  in the list
        if(batchInputs.size() > 0)
            ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
    }*/
}