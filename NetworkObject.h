//
//  NetworkObject.h
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/2/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NetworkObject : NSManagedObject

@property (nonatomic, retain) NSNumber * creationTimeStamp;
@property (nonatomic, retain) NSNumber * synced;

@end
