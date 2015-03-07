//
//  Message+Methods.m
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import "Message+Methods.h"
#import "MapPin.h"

@implementation Message (Methods)

-(NSDictionary *)createDataPayload
{
    NSMutableDictionary *tempData = [[NSMutableDictionary alloc] initWithDictionary:@{@"message":self.message,
                                                                                     @"messageID":self.messageID}];
    if(self.mapPin != nil)
    {
        [tempData setObject:self.mapPin.mapPinID forKey:@"mapPinID"];
    }
    
    return tempData;
}

@end
