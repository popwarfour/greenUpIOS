//
//  MarkerAnnotation.m
//  GreenUpVt
//
//  Created by Jordan Rouille on 6/1/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#import "MarkerAnnotation.h"

@implementation MarkerAnnotation

-(id)initWithMapPin:(MapPin *)marker;
{
    if(self = [super init])
    {
        self.marker = marker;
        self.coordinate = CLLocationCoordinate2DMake(self.marker.latitude.doubleValue, self.marker.longitude.doubleValue);
    }
    
    return self;
}

@end
