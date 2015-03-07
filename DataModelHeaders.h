//
//  DataModelHeaders.h
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#ifndef GreenUpIOS_DataModelHeaders_h
#define GreenUpIOS_DataModelHeaders_h

static NSString * const CORE_DATA_MESSAGE = @"Message";
static NSString * const CORE_DATA_NETWORK_OBJECT = @"NetworkObject";
static NSString * const CORE_DATA_MAP_PIN = @"MapPin";
static NSString * const CORE_DATA_HEAT_MAP_DATA = @"HeatMapData";

#import "HeatMapData.h"
#import "Message.h"
#import "MapPin.h"
#import "NetworkObject.h"

#import "HeatMapData+Methods.h"
#import "Message+Methods.h"
#import "MapPin+Methods.h"
#import "NetworkObject+Methods.h"

#import "CoreDataController.h"

#endif
