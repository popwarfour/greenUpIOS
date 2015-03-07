//
//  MapRegion.h
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapRegion : NSObject

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *deltaLat;
@property (nonatomic, strong) NSNumber *deltaLon;

-(instancetype)initWithLatitude:(NSNumber *)latitude
                      longitude:(NSNumber *)longitude
                       deltaLat:(NSNumber *)deltaLat
                    andDeltaLon:(NSNumber *)deltaLon;

@end