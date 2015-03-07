//
//  HomeMessage.m
//  GreenUpVt
//
//  Created by Jordan Rouille on 3/7/15.
//  Copyright (c) 2015 Xenon Apps. All rights reserved.
//

#import "HomeMessage.h"

@implementation HomeMessage

-(instancetype)initWithMessage:(NSString *)message
                  andStartDate:(NSString *)date
{
    if(self = [super init])
    {
        self.message = message;
        self.date = date;
    }
    
    return self;
}

@end
