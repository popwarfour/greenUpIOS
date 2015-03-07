//
//  StatusViewController.h
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/1/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVGKit/SVGKit.h>

@interface StatusViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *cleaningButton;
@property (weak, nonatomic) IBOutlet SVGKFastImageView *participantsSVGView;
@property (weak, nonatomic) IBOutlet SVGKFastImageView *areaSVGView;
@property (weak, nonatomic) IBOutlet UILabel *participantsLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@end
