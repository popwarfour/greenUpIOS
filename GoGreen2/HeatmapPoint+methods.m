//
//  HeatmapPoint+methods.m
//  GreenUpVt
//
//  Created by Jordan Rouille on 5/31/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#import "HeatmapPoint+methods.h"
#import "CoreDataHeaders.h"

@implementation HeatmapPoint (methods)

+(HeatmapPoint *)parseToObjectiveC:(NSDictionary *)payload
{
    HeatmapPoint *newHeatmapPoint = [theCoreDataController insertNewEntityWithName:CORE_DATA_HEATMAPPOINT];
    newHeatmapPoint.latDegrees = [payload objectForKey:@"latDegrees"];
    newHeatmapPoint.lonDegrees = [payload objectForKey:@"longDegrees"];
    newHeatmapPoint.secondsWorked = [payload objectForKey:@"secondsWorked"];
    return newHeatmapPoint;
}

-(NSDictionary *)createJSONPayload
{
    return @{@"latDegrees":self.latDegrees,
             @"lonDegrees":self.lonDegrees,
             @"secondsWorked":self.secondsWorked};
}

@end
