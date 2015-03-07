//
//  OperationController.m
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import "OperationController.h"

@implementation OperationController

static OperationController *sharedOperationController;

+ (OperationController *) shared
{
    if (sharedOperationController == nil)
    {
        sharedOperationController = [[OperationController alloc] init];
    }
    
    return sharedOperationController;
}

-(void)fetchHeatMapDataForRegion:(MapRegion *)mapRegion
                     withSuccess:(void (^)(NSMutableSet *heatMapData))success
                      andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NetworkOperation *operation = [[NetworkOperation alloc] initWithRegion:mapRegion];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableSet *heatMapData = [[NSMutableSet alloc] init];
#warning PROCESS HeatMapData
        success(heatMapData);
    } failure:failure];
}

-(void)fetchMapPinsForRegion:(MapRegion *)mapRegion
                 withSuccess:(void (^)(NSMutableSet *mapPins))success
                  andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NetworkOperation *operation = [[NetworkOperation alloc] initWithRegion:mapRegion];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableSet *mapPinData = [[NSMutableSet alloc] init];
#warning PROCESS MapPinData
        success(mapPinData);
    } failure:failure];
}

-(void)fetchMessageswithSuccess:(void (^)(NSMutableSet *messages))success
                     andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NetworkOperation *operation = [[NetworkOperation alloc] initForMessages];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableSet *messages = [[NSMutableSet alloc] init];
#warning PROCESS Messages
        success(messages);
    } failure:failure];
}

-(void)uploadData
{
    
}

@end
