//
//  NetworkOperation2.h
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import "MapRegion.h"
#import "CoreDataHeaders.h"

@interface NetworkOperation : AFHTTPRequestOperation

-(instancetype)initForHeatMapDataWithRegion:(MapRegion *)mapRegion;
-(instancetype)initForMapPinsWithRegion:(MapRegion *)mapRegion;
-(instancetype)initForMapPinWithPinID:(NSInteger)pinID;
-(instancetype)initForMessagesWithPage:(NSInteger)page;
-(instancetype)initForHomeMessages;

-(instancetype)initWithHeatMapUpload:(NSMutableSet *)heatMapData;
-(instancetype)initWithNewMarker:(Marker *)marker;
-(instancetype)initWithNewMessage:(Message *)message;
-(instancetype)initWithUpdatedMessage:(Message *)message;

@end
