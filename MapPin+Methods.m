//
//  MapPin+Methods.m
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import "MapPin+Methods.h"
#import "Message.h"

@implementation MapPin (Methods)

-(NSDictionary *)createDataPayload
{
    NSMutableDictionary *tempData = [[NSMutableDictionary alloc] initWithDictionary:@{@"latitude":self.latitude,
                                                                                      @"longitude":self.longitude,
                                                                                      @"mapPinID":self.mapPinID,
                                                                                      @"addressed":self.addressed,
                                                                                      @"pinType":self.pinType}];
    if(self.message != nil)
    {
        [tempData setObject:self.message.messageID forKey:@"messageID"];
    }
    return tempData;
}

@end
