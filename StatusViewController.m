//
//  StatusViewController.m
//  GreenUpIOS
//
//  Created by Jordan Rouille on 3/1/15.
//  Copyright (c) 2015 anders. All rights reserved.
//

#import "StatusViewController.h"

@interface StatusViewController ()

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.areaSVGView setImage:[SVGKImage imageNamed:@"areaIcon.svg"]];
    [self.participantsSVGView setImage:[SVGKImage imageNamed:@"peopleIcon.svg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
