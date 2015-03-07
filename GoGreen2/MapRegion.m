//
//  MapRegion.m
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import "MapRegion.h"

@implementation MapRegion

-(instancetype)initWithLatitude:(NSNumber *)latitude
                      longitude:(NSNumber *)longitude
                       deltaLat:(NSNumber *)deltaLat
                    andDeltaLon:(NSNumber *)deltaLon
{
    if(self = [super init])
    {
        self.latitude = latitude;
        self.longitude = longitude;
        self.deltaLat = deltaLat;
        self.deltaLon = deltaLon;
    }
    
    return self;
}

@end
