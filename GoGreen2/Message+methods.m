//
//  Message+methods.m
//  GreenUpVt
//
//  Created by Jordan Rouille on 5/31/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#import "Message+methods.h"
#import "CoreDataHeaders.h"

@implementation Message (methods)

+(Message *)parseToObjectiveC:(NSDictionary *)payload
{
    Message *newMessage = [theCoreDataController insertNewEntityWithName:CORE_DATA_MESSAGE];
    newMessage.message = [payload objectForKey:@"message"];
    newMessage.messageID = [payload objectForKey:@"id"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"y-M-d H:m:s"];
    newMessage.timeStamp = [dateFormatter dateFromString:[payload objectForKey:@"timestamp"]];
    newMessage.messageType = [payload objectForKey:@"type"];
    id pinID = [payload objectForKey:@"pin"];
    if([pinID isKindOfClass:[NSNumber class]])
    {
        [newMessage setMarkerID:pinID];
    }
    else
    {
        newMessage.markerID = nil;
    }
    newMessage.needsPush = @FALSE;
    newMessage.addressed = [payload objectForKey:@"addressed"];
    return newMessage;
}

-(NSDictionary *)createJSONPayload
{
    return @{@"type":self.messageType,
             @"message":self.message,
             @"messageID":self.messageID,
             @"addressed":self.addressed,
             @"markerID":self.markerID};
}
@end
