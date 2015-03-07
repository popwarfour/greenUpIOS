//
//  MapPin.h
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NetworkObject.h"

@class Message;

@interface MapPin : NetworkObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * pinType;
@property (nonatomic, retain) NSNumber * mapPinID;
@property (nonatomic, retain) NSNumber * addressed;
@property (nonatomic, retain) Message *message;

@end
