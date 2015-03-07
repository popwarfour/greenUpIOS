//
//  HomeMessage.h
//  GreenUpVt
//
//  Created by Jordan Rouille on 3/7/15.
//  Copyright (c) 2015 Xenon Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeMessage : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *date;

-(instancetype)initWithMessage:(NSString *)message
                  andStartDate:(NSString *)date;

@end
