//
//  ViewController.m
//  Teacher Resources
//
//  Created by Parker Rushton on 3/6/15.
//  Copyright (c) 2015 PJayRushton. All rights reserved.
//

#import "GroupViewController.h"
#import "UIColor+Category.h"
#import "FeaturesViewController.h"


@interface GroupViewController () <UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UIView *addStudentsCV;
@property (strong, nonatomic) UITextField *addTextField;

@end

@implementation GroupViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    
    //DataSource + Delegate
    self.datasource = [GroupViewControllerDataSource new];
    self.tableView.dataSource = self.datasource;
    self.tableView.delegate = self;
    [self.datasource registerTableView:self.tableView];

    
    //Add Class PLUS button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroup:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    //Navigation Bar Title
    self.title = @"Teacher Resources";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor trBlueColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //Background Color
    self.view.backgroundColor= [UIColor whiteColor];
    
    //TableView Config
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:self.tableView];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    FeaturesViewController *featuresViewController = [FeaturesViewController new];
    
    [self.navigationController pushViewController:featuresViewController animated:YES];
    
}

- (void)addGroup:(id)sender {
    
    //Create Custom Subview for adding groups
    self.addStudentsCV = [[UIView alloc] initWithFrame:CGRectMake(0, 18, self.view.frame.size.width, 44)];
    self.addStudentsCV.backgroundColor = [UIColor trBlueColor];
    
    //Add TextField
    self.addTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 4, 250, 35)];
    self.addTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.addTextField.delegate = self;
    self.addTextField.placeholder = @"Enter Group Title";
    [self.addTextField becomeFirstResponder];
    [self.addStudentsCV addSubview:self.addTextField];
    
    //Add addGroup Button
    UIButton *addGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addGroupButton addTarget:self
                     action:@selector(addGroupButtonPressed)
           forControlEvents:UIControlEventTouchUpInside];
    
    [addGroupButton setTitle:@"Add Group" forState:UIControlStateNormal];
    addGroupButton.tintColor = [UIColor whiteColor];
    addGroupButton.frame = CGRectMake(self.view.frame.size.width - 85, 15.0, 80.0, 20.0);
    [self.addStudentsCV addSubview:addGroupButton];

    [self.navigationController.view addSubview:self.addStudentsCV];

    
}

-(void)addGroupButtonPressed {
    if ([self.addTextField.text isEqualToString:@""]) {
        return;
    }
    [[GroupController sharedInstance] addGroupWithGroupName:self.addTextField.text];
    [self.tableView reloadData];
    [self.addStudentsCV removeFromSuperview];
    [self.addTextField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        [textField resignFirstResponder];
        [self.addStudentsCV removeFromSuperview];
        return YES;
    }
    [self addGroupButtonPressed];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
