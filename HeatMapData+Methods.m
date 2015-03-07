//
//  HeatMapData+Methods.m
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import "HeatMapData+Methods.h"

@implementation HeatMapData (Methods)

-(NSDictionary *)createDataPayload
{
    NSDictionary *tempData = @{@"latitude":self.latitude,
                               @"longitude":self.longitude,
                               @"duration":self.duration};
    return tempData;
}

@end
