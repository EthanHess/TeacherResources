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
#import "SWTableViewCell.h"
#import "PageViewController.h"

@interface GroupViewController () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate,UITextFieldDelegate>

//@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIView *addClassCustomView;
@property (strong, nonatomic) UITextField *addTextField;
@property (strong, nonatomic) UIButton *addClassButton;
@property (nonatomic, strong) GroupViewController *groupViewController;
@property (assign, nonatomic) BOOL hasLaunched;

@end

@implementation GroupViewController

- (void)updateWithHasLaunched:(BOOL)hasLaunched {
    self.hasLaunched = hasLaunched;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    self.hasLaunched = [[NSUserDefaults standardUserDefaults] objectForKey:@"launchKey"];
    [self setupViews];
    
    self.view.backgroundColor= [UIColor whiteColor];
    
    //DataSource + Delegate
    [self registerTableView:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.hasLaunched == NO) {
        self.hasLaunched = YES;
        [self presentOnBoard];
        
        [[NSUserDefaults standardUserDefaults] setBool:self.hasLaunched forKey:@"launchKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentOnBoard) name:@"onBoard" object:nil];
}

-(void)presentOnBoard {
    PageViewController *pageViewController = [PageViewController new];
    [self.navigationController presentViewController:pageViewController animated:YES completion:nil];

}

- (void)setupViews {
    //Add Class PLUS button
    self.addClassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addClassButton setTitle:@"+" forState:UIControlStateNormal];
    self.addClassButton.frame = CGRectMake(0, 15.0, 30.0, 20.0);
    self.addClassButton.titleLabel.tintColor = [UIColor whiteColor];
    self.addClassButton.titleLabel.font = [UIFont fontWithName:@"Chalkduster" size:50.0];
    [self.addClassButton addTarget:self action:@selector(animatePlusButton) forControlEvents:UIControlEventTouchDown];
    [self.addClassButton addTarget:self action:@selector(addClassButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithCustomView:self.addClassButton];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //Navigation Bar Title
    self.title = @"Classes";
    self.navigationController.navigationBar.barTintColor = [UIColor woodColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;

    //TableView Config
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor chalkboardGreen];
    [self.view addSubview:self.tableView];

}

- (void)addClassButtonPressed:(id)sender {
    
    //Create Custom Subview for adding groups
    self.addClassCustomView = [[UIView alloc] initWithFrame:CGRectMake(-250, 0, self.view.frame.size.width, 64)];
    self.addClassCustomView.backgroundColor = [UIColor woodColor];
    
    //Add Group TextField
    self.addTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 24, self.view.frame.size.width *0.6, 35)];
    self.addTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.addTextField.delegate = self;
    self.addTextField.placeholder = @"Enter Class Name";
    self.addTextField.font = [UIFont fontWithName:@"Chalkduster" size:14];
    [self.addTextField setReturnKeyType:UIReturnKeyDone];
    [self.addTextField becomeFirstResponder];
    [self.addClassCustomView addSubview:self.addTextField];
    
    //Add addGroup Button Custom View
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton addTarget:self
                     action:@selector(cancelButtonPressed)
           forControlEvents:UIControlEventTouchUpInside];
    
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Chalkduster" size:20];

    cancelButton.tintColor = [UIColor whiteColor];
    cancelButton.frame = CGRectMake(self.view.frame.size.width - 85, 35.0, 80.0, 20.0);
    [self.addClassCustomView addSubview:cancelButton];

    [self.navigationController.view addSubview:self.addClassCustomView];
    [self moveOver:self.addClassCustomView thisMuch:250 withDuration:.2];
    
}

-(void)cancelButtonPressed {

    [self moveOver:self.addClassCustomView thisMuch:-(self.view.frame.size.width) withDuration:.25];
    [self.addTextField resignFirstResponder];
}

#pragma mark - TextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        return NO;
    }
    [[GroupController sharedInstance] addGroupWithGroupName:textField.text];
    [self moveOver:self.addClassCustomView thisMuch:(self.view.frame.size.width) withDuration:.25];
    textField.text = @"";
    [self.tableView reloadData];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TableView DataSource Methods

- (void)registerTableView:(UITableView *)tableView {
    [tableView registerClass:[SWTableViewCell class] forCellReuseIdentifier:@"cellID"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [GroupController sharedInstance].groups.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    
    SWTableViewCell *cell = (SWTableViewCell *)[[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    cell.delegate = self;
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.leftUtilityButtons = [self leftButton];
        cell.rightUtilityButtons = [self rightButton];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];

    }
    cell.leftUtilityButtons = [self leftButton];
    cell.rightUtilityButtons = [self rightButton];
    cell.backgroundColor = [UIColor clearColor];
    
    //Cell Title
    Group *currentGroup = [GroupController sharedInstance].groups[indexPath.row];
    cell.textLabel.text = currentGroup.title;
    cell.textLabel.font = [UIFont fontWithName:@"Chalkduster" size:30];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    //Cell Subtitle
    NSInteger classSize = currentGroup.members.count;
    NSString *numberOfStudents = [NSString stringWithFormat:@"%zd Students",classSize];
    if (classSize == 0) {
        cell.detailTextLabel.text = @"empty";
    }
    else {
        cell.detailTextLabel.text = numberOfStudents;
    }
    cell.detailTextLabel.font = [UIFont fontWithName:@"Chalkduster" size:14];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
     return cell;
}

#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.addClassCustomView removeFromSuperview];
    
    Group *currentGroup = [GroupController sharedInstance].groups[indexPath.row];
    
    FeaturesViewController *featuresViewController = [FeaturesViewController new];
    [featuresViewController updateWithGroup:currentGroup];
    
    //Set Temporary Student List for use
    NSSet *set = [currentGroup.members set];
    [GroupController sharedInstance].temporaryStudentList = [NSArray arrayWithArray:[set allObjects]];

    [self.navigationController pushViewController:featuresViewController animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

#pragma mark - SWTableViewCell Methods

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];

    StudentListViewController *studentListViewController = [StudentListViewController new];
    [studentListViewController updateWithGroup:[[GroupController sharedInstance].groups objectAtIndex:cellIndexPath.row]];
        [self.navigationController presentViewController:studentListViewController animated:YES completion:^{
            [self.tableView reloadData];
        }];

}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    // Delete button was pressed
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    
    [[GroupController sharedInstance] removeGroup:[[GroupController sharedInstance].groups objectAtIndex:cellIndexPath.row]];
    [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
}

- (NSArray *)leftButton {
    
    NSMutableArray *leftUtilityButton = [NSMutableArray new];
    
    [leftUtilityButton sw_addUtilityButtonWithColor:[UIColor clearColor] icon:[UIImage imageNamed:@"plus"]];
    
    return leftUtilityButton;
}

- (NSArray *)rightButton {
    
    NSMutableArray *rightUtilityButton = [NSMutableArray new];
    
    [rightUtilityButton sw_addUtilityButtonWithColor:[UIColor redColor] icon:[UIImage imageNamed:@"cross"]];
    
    return rightUtilityButton;
}

-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

#pragma mark - Animations

-(void)moveOver:(UIView *)view thisMuch:(float)distance withDuration:(float)duration {

    [UIView animateWithDuration:duration animations:^{
        view.center = CGPointMake(view.center.x + distance, view.center.y);
        
    }];
}

- (void)animatePlusButton {
    
    [self growsOnTouch:self.addClassButton withDuration:.3];
}

- (void)growsOnTouch:(UIView *)view withDuration:(float)duration {
    
    CGAffineTransform bigger = CGAffineTransformMakeScale(5, 5);
    CGAffineTransform smaller = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:duration animations:^{
        view.transform = bigger;
        view.transform = smaller;
    }];
}

@end
