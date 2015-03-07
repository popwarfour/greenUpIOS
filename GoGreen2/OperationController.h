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
#import "CoreDataHeaders.h"
#import "HomeMessage.h"

#define theOperationController [OperationController shared]


@interface OperationController : NSObject

@property (nonatomic, strong) NSOperationQueue *operationQueue;

+ (OperationController *) shared;

#pragma mark - Heat Map Data

-(void)fetchHeatMapDataForRegion:(MapRegion *)mapRegion
                     withSuccess:(void (^)(NSMutableSet *heatMapData))success
                      andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)uploadHeatMapDataWithSuccess:(void (^)(HomeMessage *message))success
                         andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Map Pins

-(void)fetchMapPinsForRegion:(MapRegion *)mapRegion
                 withSuccess:(void (^)(NSMutableSet *mapPins))success
                  andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)fetchMapPinWithPinID:(NSInteger)pinID
                    success:(void (^)(Marker *marker))success
                 andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Messages

-(void)fetchLatestMessagesWithCurrentMessages:(NSArray *)currentMessages
                                      success:(void (^)(NSMutableSet *newMessages))success
                                   andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)fetchNewestMessages:(NSArray *)currentMessages
                   success:(void (^)(NSMutableSet *newMessages))success
                andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)fetchMessagesForPage:(NSInteger)page
            currentMessages:(NSArray *)currentMessages
                    success:(void (^)(NSMutableSet *messages))success
                 andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)fetchMessageWithMessageID:(NSInteger)messageID
                 currentMessages:(NSArray *)currentMessages
                         success:(void (^)(Message *message))success
                      andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)updateMessage:(Message *)message
             success:(void (^)(HomeMessage *message))success
          andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Other

-(void)fetchHomeMessagesWithSuccess:(void (^)(HomeMessage *message))success
                         andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
