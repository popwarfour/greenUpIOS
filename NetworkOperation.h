//
//  NetworkOperation2.h
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import "MapRegion.h"
#import "DataModelHeaders.h"

@interface NetworkOperation : AFHTTPRequestOperation

-(instancetype)initWithRegion:(MapRegion *)mapRegion;
-(instancetype)initForMapPinsWithRegion:(MapRegion *)mapRegion;
-(instancetype)initForMessages;

-(instancetype)initWithHeatMapUpload:(NSMutableArray *)heatMapData;
-(instancetype)initWithMapPinsUpload:(NSMutableArray *)mapPins;
-(instancetype)initWithMessagesUpload:(NSMutableArray *)messages;

@end
