//
//  ViewControllerFive.m
//  Teacher Resources
//
//  Created by Ethan Hess on 3/20/15.
//  Copyright (c) 2015 PJayRushton. All rights reserved.
//

#import "ViewControllerFive.h"
#import "GroupController.h"
#import "UIColor+Category.h"

@interface ViewControllerFive ()

@end

@implementation ViewControllerFive

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor chalkboardGreen];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(0, self.view.frame.size.height/2 - 25, self.view.frame.size.width, 50);
    [button addTarget:self action:@selector(dismissOnboarding:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Chalkduster" size:80]];
    [button setTitle:@"Got it!" forState:UIControlStateNormal];
    
    [self.view addSubview:button];
}

- (void)dismissOnboarding:(id)sender {
    [GroupController new];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
