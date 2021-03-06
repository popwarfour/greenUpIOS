//
//  Message.h
//  GreenUpVt
//
//  Created by Jordan Rouille on 3/7/15.
//  Copyright (c) 2015 Xenon Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Message : NSManagedObject

@property (nonatomic, retain) NSNumber * addressed;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * messageID;
@property (nonatomic, retain) NSString * messageType;
@property (nonatomic, retain) NSNumber * needsPush;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * markerID;

@end
