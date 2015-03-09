//
//  ViewController.h
//  Teacher Resources
//
//  Created by Parker Rushton on 3/6/15.
//  Copyright (c) 2015 PJayRushton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupViewControllerDataSource.h"
#import "GroupDetailViewController.h"
#import "GroupController.h"

@interface GroupViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UILabel *label; 
@property (nonatomic, strong) GroupViewControllerDataSource *dataSource;

@end
