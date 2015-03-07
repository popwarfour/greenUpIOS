//
//  OperationController.m
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import "OperationController.h"

@implementation OperationController

static OperationController *sharedOperationController;

+ (OperationController *) shared
{
    if (sharedOperationController == nil)
    {
        sharedOperationController = [[OperationController alloc] init];
    }
    
    return sharedOperationController;
}

#pragma mark - Heat Map Data

-(void)fetchHeatMapDataForRegion:(MapRegion *)mapRegion
                     withSuccess:(void (^)(NSMutableSet *heatMapData))success
                      andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NetworkOperation *operation = [[NetworkOperation alloc] initForHeatMapDataWithRegion:mapRegion];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableSet *heatMapData = [[NSMutableSet alloc] init];
        
        [theCoreDataController deleteAllObjectsWithEntityName:CORE_DATA_HEATMAPPOINT andPredicate:nil];
        
        NSLog(@"Network - Map: Recieved %lu New Heat Map Points", (unsigned long)[[responseObject objectForKey:@"grid"] count]);
        NSLog(@"--- Data - Map: %@", [responseObject objectForKey:@"grid"]);
        
        for(NSDictionary *pointDictionary in [responseObject objectForKey:@"grid"])
        {
            HeatmapPoint *newPoint = [theCoreDataController insertNewEntityWithName:CORE_DATA_HEATMAPPOINT];
            double lat = [[pointDictionary objectForKey:@"latDegrees"] doubleValue];
            double lon = [[pointDictionary objectForKey:@"lonDegrees"] doubleValue];
            double secWorked = [[pointDictionary objectForKey:@"secondsWorked"] doubleValue];
            
            newPoint.latDegrees = [NSNumber numberWithDouble:lat];
            newPoint.lonDegrees = [NSNumber numberWithDouble:lon];
            newPoint.secondsWorked = [NSNumber numberWithDouble:secWorked];
            newPoint.needsPush = @FALSE;
            
            [heatMapData addObject:newPoint];
        }
        
        [theCoreDataController saveContext];
        
        success(heatMapData);
    } failure:failure];
}

-(void)uploadHeatMapDataWithSuccess:(void (^)())success
                         andFailure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSMutableSet *unpushedHeatMapData = [[NSMutableSet alloc] init];
    
    for(HeatmapPoint *tempHeatMapPoint in [theCoreDataController fetchObjectsWithEntityName:CORE_DATA_HEATMAPPOINT predicate:[NSPredicate predicateWithFormat:@"needsPush == TRUE"] sortDescriptors:nil andBatchNumber:0])
    {
        NSDictionary *tempPayload = [tempHeatMapPoint createJSONPayload];
        [unpushedHeatMapData addObject:tempPayload];
    }
    
    NetworkOperation *operation = [[NetworkOperation alloc] initWithHeatMapUpload:unpushedHeatMapData];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:failure];
}

#pragma mark - Markers

-(void)fetchMapPinsForRegion:(MapRegion *)mapRegion
                 withSuccess:(void (^)(NSMutableSet *mapPins))success
                  andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NetworkOperation *operation = [[NetworkOperation alloc] initForMapPinsWithRegion:mapRegion];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableSet *mapPinData = [[NSMutableSet alloc] init];
#warning PROCESS MapPinData
        success(mapPinData);
    } failure:failure];
}

-(void)fetchMapPinWithPinID:(NSInteger)pinID
                    success:(void (^)(Marker *))success
                 andFailure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NetworkOperation *operation = [[NetworkOperation alloc] initForMapPinWithPinID:pinID];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *markerData = [responseObject objectForKey:@"pin"];
        if(markerData == nil)
        {
            NSException *exception = [[NSException alloc] initWithName:@"No Marker Found" reason:@"Did not find marker in api request" userInfo:nil];
            [exception raise];
        }
        Marker *marker = [Marker parseToObjectiveC:markerData];
        success(marker);
    } failure:failure];
}

#pragma mark - Comments

-(void)fetchLatestMessagesWithCurrentMessages:(NSMutableArray *)currentMessages
                                      success:(void (^)(NSMutableSet *newMessages))success
                                   andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NetworkOperation *operation = [[NetworkOperation alloc] initForMessagesWithPage:0];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *comments = [responseObject objectForKey:@"comments"];
        NSMutableSet *newMessages = [[NSMutableSet alloc] init];
        for(NSDictionary *tempMessage in comments)
        {
            if(![self containsMessageWithMessageID:[tempMessage objectForKey:@"messageID"]
                                andCurrentMessages:currentMessages])
            {
                Message *newMessage = [Message parseToObjectiveC:tempMessage];
                [newMessages addObject:newMessage];
            }
        }
        [currentMessages addObjectsFromArray:newMessages.allObjects];
        success(newMessages);
        
    } failure:failure];
}

-(void)fetchMessageWithMessageID:(NSInteger)messageID
                 currentMessages:(NSMutableArray *)currentMessages
                         success:(void (^)(Message *message))success
                      andFailure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    Message *foundMessage = [self containsMessageWithMessageID:@(messageID)
                                            andCurrentMessages:currentMessages];
    if(foundMessage != nil)
    {
        success(foundMessage);
    }
    else
    {
        __block NSMutableSet *newMessages = [[NSMutableSet alloc] init];
        [self recursivelyFindMessageWithPage:1
                                   messageID:messageID
                                 newMessages:newMessages
                                     success:^(Message *message) {
                                         [currentMessages addObjectsFromArray:newMessages.allObjects];
                                         success(message);
                                     } andFailure:failure];
    }
}

-(void)recursivelyFindMessageWithPage:(NSInteger)page
                            messageID:(NSInteger)messageID
                          newMessages:(NSMutableSet *)newMessages
                              success:(void (^)(Message *message))success
                           andFailure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NetworkOperation *operation = [[NetworkOperation alloc] initForMessagesWithPage:page];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *comments = [responseObject objectForKey:@"comments"];
        NSMutableSet *newMessages = [[NSMutableSet alloc] init];
        
        Message *foundMessage = nil;
        for(NSDictionary *tempMessage in comments)
        {
            if(![self containsMessageWithMessageID:[tempMessage objectForKey:@"messageID"]
                                andCurrentMessages:newMessages.allObjects])
            {
                Message *newMessage = [Message parseToObjectiveC:tempMessage];
                [newMessages addObject:newMessage];
                
                if([newMessage.messageID isEqualToValue:@(messageID)])
                {
                    foundMessage = newMessage;
                }
            }
        }
        
        if(foundMessage)
        {
            success(foundMessage);
        }
        else
        {
            [self recursivelyFindMessageWithPage:page + 1
                                       messageID:messageID
                                     newMessages:newMessages
                                         success:success
                                      andFailure:failure];
        }
    } failure:failure];
}

-(void)fetchNewestMessages:(NSMutableArray *)currentMessages
                   success:(void (^)(NSMutableSet *newMessages))success
                andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    __block NSMutableSet *newMessages = [[NSMutableSet alloc] init];
    
    [self recursivelyFindNewestMessagesWithPage:1
                                currentMessages:currentMessages
                                    newMessages:newMessages
                                        success:^{
                                            [currentMessages addObjectsFromArray:newMessages.allObjects];
                                            success(newMessages);
                                        } andFailure:failure];
}

-(void)recursivelyFindNewestMessagesWithPage:(NSInteger)page
                             currentMessages:(NSArray *)currentMessages
                                 newMessages:(NSMutableSet *)newMessages
                                     success:(void (^)())success
                                  andFailure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NetworkOperation *operation = [[NetworkOperation alloc] initForMessagesWithPage:page];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *comments = [responseObject objectForKey:@"comments"];
        
        BOOL foundOldMessage = FALSE;
        for(NSDictionary *tempMessage in comments)
        {
            if(![self containsMessageWithMessageID:[tempMessage objectForKey:@"messageID"]
                                andCurrentMessages:currentMessages])
            {
                Message *newMessage = [Message parseToObjectiveC:tempMessage];
                [newMessages addObject:newMessage];
            }
            else
            {
                foundOldMessage = TRUE;
            }
        }
        
        if(foundOldMessage)
        {
            success();
        }
        else
        {
            [self recursivelyFindNewestMessagesWithPage:page + 1
                                        currentMessages:currentMessages
                                            newMessages:newMessages
                                                success:^{
                                                    success(newMessages);
                                                } andFailure:failure];
        }
    } failure:failure];
}

-(void)fetchMessagesForPage:(NSInteger)page
            currentMessages:(NSArray *)currentMessages
                    success:(void (^)(NSMutableSet *))success
                 andFailure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NetworkOperation *operation = [[NetworkOperation alloc] initForMessagesWithPage:page];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *comments = [responseObject objectForKey:@"comments"];
        NSMutableSet *newMessages = [[NSMutableSet alloc] init];
        for(NSDictionary *tempMessage in comments)
        {
            if(![self containsMessageWithMessageID:[tempMessage objectForKey:@"messageID"]
                                andCurrentMessages:currentMessages])
            {
                Message *newMessage = [Message parseToObjectiveC:tempMessage];
                [newMessages addObject:newMessage];
            }
        }
        
        success(newMessages);
        
    } failure:failure];
}

-(void)updateMessage:(Message *)message
             success:(void (^)())success
          andFailure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NetworkOperation *operation = [[NetworkOperation alloc] initWithUpdatedMessage:message];
    [operation setCompletionBlockWithSuccess:success
                                     failure:failure];
}

-(void)sendNewMessage:(NSString *)message
                 type:(NSString *)type
              success:(void (^)())success
           andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NetworkOperation *operation = [[NetworkOperation alloc] initWithNewMessage:message andType:type];
    [operation setCompletionBlockWithSuccess:success
                                     failure:failure];
}

#pragma mark - Other

-(void)fetchHomeMessagesWithSuccess:(void (^)(HomeMessage *message))success
                         andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NetworkOperation *operation = [[NetworkOperation alloc] initForHomeMessages];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        BOOL invalidMessage = FALSE;
        if(![[responseObject allKeys] containsObject:@"message"])
        {
            invalidMessage = TRUE;
        }
        else
        {
            if([[responseObject objectForKey:@"message"] isEqualToString:@""])
            {
                invalidMessage = TRUE;
            }
        }
        if(![[responseObject allKeys] containsObject:@"date"])
        {
            invalidMessage = TRUE;
        }
        else
        {
            if([[responseObject objectForKey:@"date"] isEqualToString:@""])
            {
                invalidMessage = TRUE;
            }
        }
        
        if(invalidMessage)
        {
            failure(nil, nil);
        }
        else
        {
            HomeMessage *homeMessage = [[HomeMessage alloc] initWithMessage:[responseObject objectForKey:@"message"]
                                                               andStartDate:[responseObject objectForKey:@"date"]];
            success(homeMessage);
        }
    } failure:failure];
}

#pragma mark - Utility Methods

-(Message *)containsMessageWithMessageID:(NSNumber *)messageID
                andCurrentMessages:(NSArray *)currentMessages
{
    for(Message *tempMessage in currentMessages)
    {
        if([tempMessage.messageID isEqualToNumber:messageID])
            return tempMessage;
    }
    
    return nil;
}

@end
