//
//  Message.h
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NetworkObject.h"

@class MapPin;

@interface Message : NetworkObject

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * messageID;
@property (nonatomic, retain) MapPin *mapPin;

@end
