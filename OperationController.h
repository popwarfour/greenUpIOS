//
//  OperationController.h
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapRegion.h"
#import "NetworkOperation.h"
#import <AFNetworking/AFNetworking.h>

#define theOperationController [OperationController shared]

typedef void (^VoidBlock)(void);

@interface OperationController : NSObject

@property (nonatomic, strong) NSOperationQueue *operationQueue;

+ (OperationController *) shared;

-(void)fetchHeatMapDataForRegion:(MapRegion *)mapRegion
                     withSuccess:(void (^)(NSMutableSet *heatMapData))success
                      andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)fetchMapPinsForRegion:(MapRegion *)mapRegion
                 withSuccess:(void (^)(NSMutableSet *mapPins))success
                  andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)fetchMessagesWithSuccess:(void (^)(NSMutableSet *messages))success
                     andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)uploadData;

@end
