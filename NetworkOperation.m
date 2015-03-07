//
//  NetworkOperation2.m
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import "NetworkOperation.h"
#import "NetworkHeaders.h"

@implementation NetworkOperation

#pragma mark - GET Methods

-(instancetype)initForHeatMapWithRegion:(MapRegion *)mapRegion
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", BASE_URL, HEAT_MAP_DATA_URL];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:URLString]];
    [URLRequest setHTTPMethod: @"GET"];
    [URLRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    if (self = [super initWithRequest: URLRequest])
    {
        [self.responseSerializer setAcceptableStatusCodes: [NSIndexSet indexSetWithIndex: 201]];
    }
    
    return self;
}

-(instancetype)initForMapPinsWithRegion:(MapRegion *)mapRegion
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", BASE_URL, MAP_PINS_URL];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:URLString]];
    [URLRequest setHTTPMethod: @"GET"];
    [URLRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    if (self = [super initWithRequest: URLRequest])
    {
        [self.responseSerializer setAcceptableStatusCodes: [NSIndexSet indexSetWithIndex: 201]];
    }
    
    return self;
}

-(instancetype)initForMessages
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", BASE_URL, MESSAGES_URL];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:URLString]];
    [URLRequest setHTTPMethod: @"GET"];
    [URLRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    if (self = [super initWithRequest: URLRequest])
    {
        [self.responseSerializer setAcceptableStatusCodes: [NSIndexSet indexSetWithIndex: 201]];
    }
    
    return self;
}

#pragma mark - POST Methods

-(instancetype)initWithHeatMapUpload:(NSMutableArray *)heatMapData
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", BASE_URL, HEAT_MAP_DATA_URL];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:URLString]];
    [URLRequest setHTTPMethod: @"POST"];
    [URLRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(HeatMapData *tempHeatMapData in heatMapData)
    {
        [dataArray addObject:[tempHeatMapData createDataPayload]];
    }
    
    NSData *data = [self createPayloadFromObject:dataArray];
    [URLRequest setHTTPBody:data];
    
    if (self = [super initWithRequest: URLRequest])
    {
        [self.responseSerializer setAcceptableStatusCodes: [NSIndexSet indexSetWithIndex: 201]];
    }
    
    return self;
}

-(instancetype)initWithMapPinsUpload:(NSMutableArray *)mapPins
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", BASE_URL, MAP_PINS_URL];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:URLString]];
    [URLRequest setHTTPMethod: @"POST"];
    [URLRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(MapPin *tempMapPin in mapPins)
    {
        [dataArray addObject:[tempMapPin createDataPayload]];
    }
    
    NSData *data = [self createPayloadFromObject:dataArray];
    [URLRequest setHTTPBody:data];
    
    if (self = [super initWithRequest: URLRequest])
    {
        [self.responseSerializer setAcceptableStatusCodes: [NSIndexSet indexSetWithIndex: 201]];
    }
    
    return self;
}

-(instancetype)initWithMessagesUpload:(NSMutableArray *)messages
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", BASE_URL, MESSAGES_URL];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:URLString]];
    [URLRequest setHTTPMethod: @"POST"];
    [URLRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(Message *tempMessage in messages)
    {
        [dataArray addObject:[tempMessage createDataPayload]];
    }
    
    NSData *data = [self createPayloadFromObject:dataArray];
    [URLRequest setHTTPBody:data];
    
    if (self = [super initWithRequest: URLRequest])
    {
        [self.responseSerializer setAcceptableStatusCodes: [NSIndexSet indexSetWithIndex: 201]];
    }
    
    return self;
}

#pragma mark - Utility Methods

-(NSData *)createPayloadFromObject:(id)object
{
    if(object == nil)
    {
        NSException *exception = [[NSException alloc] initWithName:@"Cannot package nil object for data upload"
                                                            reason:@"no details"
                                                          userInfo:nil];
        [exception raise];
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error == nil)
    {
        NSException *exception = [[NSException alloc] initWithName:@"Failed To Package Data"
                                                            reason:@"view user info for details"
                                                          userInfo:error.userInfo];
        [exception raise];
    }
    
    return data;
}

@end
