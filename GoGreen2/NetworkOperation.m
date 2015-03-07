//
//  NetworkOperation2.m
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import "NetworkOperation.h"
#import "NetworkingConstants.h"

@implementation NetworkOperation

#pragma mark - GET Methods

-(instancetype)initForHeatMapDataWithRegion:(MapRegion *)mapRegion;
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", THEME_BASE_URL, THEME_HEAT_MAP_RELATIVE_URL];
    
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
    NSString *URLString = [NSString stringWithFormat:@"%@%@", THEME_BASE_URL, THEME_PINS_RELATIVE_URL];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:URLString]];
    [URLRequest setHTTPMethod: @"GET"];
    [URLRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    if (self = [super initWithRequest: URLRequest])
    {
        [self.responseSerializer setAcceptableStatusCodes: [NSIndexSet indexSetWithIndex: 201]];
    }
    
    return self;
}

-(instancetype)initForMapPinWithPinID:(NSInteger)pinID
{
    NSString *URLString = [NSString stringWithFormat:@"%@:%d%@?id=%ld", THEME_BASE_URL, THEME_API_PORT, THEME_PINS_RELATIVE_URL, (long)pinID];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:URLString]];
    [URLRequest setHTTPMethod: @"GET"];
    [URLRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    if (self = [super initWithRequest: URLRequest])
    {
        [self.responseSerializer setAcceptableStatusCodes: [NSIndexSet indexSetWithIndex: 201]];
    }
    
    return self;
}

-(instancetype)initForMessagesWithPage:(NSInteger)page;
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@?page=%ld", THEME_BASE_URL, THEME_MESSAGES_RELATIVE_URL, (long)page];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:URLString]];
    [URLRequest setHTTPMethod: @"GET"];
    [URLRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    if (self = [super initWithRequest: URLRequest])
    {
        [self.responseSerializer setAcceptableStatusCodes: [NSIndexSet indexSetWithIndex: 201]];
    }
    
    return self;
}

-(instancetype)initForHomeMessages
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", THEME_BASE_URL, THEME_HOME_MESSAGES_RELATIVE_URL];
    
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

-(instancetype)initWithHeatMapUpload:(NSMutableSet *)heatMapData
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", THEME_BASE_URL, THEME_HEAT_MAP_RELATIVE_URL];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:URLString]];
    [URLRequest setHTTPMethod: @"POST"];
    [URLRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(HeatmapPoint *tempHeatmapPoint in heatMapData)
    {
        [dataArray addObject:[tempHeatmapPoint createJSONPayload]];
    }
    
    NSData *data = [self createPayloadFromObject:dataArray];
    [URLRequest setHTTPBody:data];
    
    if (self = [super initWithRequest: URLRequest])
    {
        [self.responseSerializer setAcceptableStatusCodes: [NSIndexSet indexSetWithIndex: 201]];
    }
    
    return self;
}

-(instancetype)initWithNewMarker:(Marker *)marker
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@?id=%@", THEME_BASE_URL, THEME_PINS_RELATIVE_URL, marker.markerID];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:URLString]];
    [URLRequest setHTTPMethod: @"POST"];
    [URLRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSDictionary *parsedMarker = [marker createJSONPayload];
    
    NSData *data = [self createPayloadFromObject:parsedMarker];
    [URLRequest setHTTPBody:data];
    
    if (self = [super initWithRequest: URLRequest])
    {
        [self.responseSerializer setAcceptableStatusCodes: [NSIndexSet indexSetWithIndex: 201]];
    }
    
    return self;
}

-(instancetype)initWithNewMessage:(Message *)message
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", THEME_BASE_URL, THEME_COMMENTS_RELATIVE_URL];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:URLString]];
    [URLRequest setHTTPMethod: @"POST"];
    [URLRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSDictionary *parsedMessage = [message createJSONPayload];
    
    NSData *data = [self createPayloadFromObject:parsedMessage];
    [URLRequest setHTTPBody:data];
    
    if (self = [super initWithRequest: URLRequest])
    {
        [self.responseSerializer setAcceptableStatusCodes: [NSIndexSet indexSetWithIndex: 201]];
    }
    
    return self;
}

-(instancetype)initWithUpdatedMessage:(Message *)message
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@?id=%@",THEME_BASE_URL, THEME_PINS_RELATIVE_URL, message.markerID.stringValue];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:URLString]];
    [URLRequest setHTTPMethod: @"PUT"];
    [URLRequest setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSDictionary *parsedMessage = [message createJSONPayload];
    
    NSData *data = [self createPayloadFromObject:parsedMessage];
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
