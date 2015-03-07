//
//  Marker+methods.m
//  GreenUpVt
//
//  Created by Jordan Rouille on 5/31/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#import "Marker+methods.h"
#import "CoreDataHeaders.h"

@implementation Marker (methods)

+(Marker *)parseToObjectiveC:(NSDictionary *)payload
{
    Marker *newMarker = [theCoreDataController insertNewEntityWithName:CORE_DATA_MARKER];
    newMarker.markerID = [payload objectForKey:@"id"];
    newMarker.messageID = [payload objectForKey:@"messageID"];
    newMarker.latDegrees = [payload objectForKey:@"latDegrees"];
    newMarker.lonDegrees = [payload objectForKey:@"lonDegrees"];
    newMarker.markerType = [payload objectForKey:@"type"];
    newMarker.addressed = [payload objectForKey:@"addressed"];
    newMarker.needsPush = @FALSE;
    return newMarker;
}

-(NSDictionary *)createJSONPayload
{
    return @{@"latDegrees":self.latDegrees,
             @"lonDegrees":self.lonDegrees,
             @"secondsWorked":self.markerType,
             @"addressed":self.addressed};
}

@end
