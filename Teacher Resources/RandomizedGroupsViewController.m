//
//  RandomizedGroupsViewController.m
//  Teacher Resources
//
//  Created by Ethan Hess on 3/6/15.
//  Copyright (c) 2015 PJayRushton. All rights reserved.
//

#import "RandomizedGroupsViewController.h"
#import "MembersCollectionViewCell.h"
#import "RandomizedViewControllerDataSource.h"
#import "Member.h"
#import "UIColor+Category.h"
#import "GroupController.h"

@interface RandomizedGroupsViewController ()


@property (nonatomic, strong) RandomizedViewControllerDataSource * dataSource;
@property (nonatomic, strong) MembersCollectionViewCell * customCell;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIView *configView;
@property (nonatomic, strong) UIButton *twoButton;
@property (nonatomic, strong) UIButton *threeButton;
@property (nonatomic, strong) UIButton *fourButton;
@property (nonatomic, strong) UIButton *configButton;
@property (nonatomic, strong) UIButton *randomizeButton;
@property (nonatomic, assign) BOOL configIsOut;

@end

@implementation RandomizedGroupsViewController

@synthesize screenHeight,screenWidth,customCell;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSource = [RandomizedViewControllerDataSource new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor chalkboardGreen];
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
        
    [self setupNavigationBar];
    
    [self setupCollectionView];
    
    [self setupRandomizeButton];
    
    [self setupConfigView];
    
    [self setupSwipeGestures];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshData];
}

- (void)updateWithGroup:(Group *)group {
    
    self.group = group;
}

#pragma mark - Setup CollectionView

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 105) collectionViewLayout:layout];
    
    //Collection View - Register - Delegate - Datasource
    [self.dataSource registerCollectionView:self.collectionView withGroup:self.group];
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self;
    
    [self.collectionView setBackgroundColor:[UIColor clearColor]];

    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize itemSize = CGSizeMake((screenWidth /numberOfPeopleInGroup) - 6 , ((screenHeight - 64) / 5) / 2);
    return itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Member *currentMember = [GroupController sharedInstance].temporaryStudentList[indexPath.item];
    NSString *message = [NSString stringWithFormat:@"Delete %@ from temporary student list?", currentMember.name];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
    
    self.arrayIndex = indexPath.item;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray: [GroupController sharedInstance].temporaryStudentList];
        [mutableArray removeObjectAtIndex:self.arrayIndex];
        [GroupController sharedInstance].temporaryStudentList = mutableArray;
        [self refreshData];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(2, 4, 2, 4);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout maximumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Setup Navigation Bar

- (void)setupNavigationBar {
    
    self.title = @"Random Groups";
    
    //Config Button
    self.configButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.configButton.frame = CGRectMake(0, 0, 50.0, 20.0);
    [self configureButton:self.configButton withTitle:@"*" andSize:40];
    [self.configButton addTarget:self action:@selector(configButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *configBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.configButton];
    self.navigationItem.rightBarButtonItem = configBarButtonItem;
    
    
}

#pragma mark - Shuffle & Refresh Methods

- (void)setupRandomizeButton {
    self.randomizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self configureButton:self.randomizeButton withTitle:@"New Groups" andSize:20];
    self.randomizeButton.frame = CGRectMake(0, self.view.frame.size.height - 115, self.view.frame.size.width, 50);
    [self.randomizeButton setBackgroundColor:[UIColor clearColor]];
    [self.randomizeButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.randomizeButton];
}

- (void)setupConfigView {
    self.configView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, 200, self.view.frame.size.height - 64)];
    self.configView.backgroundColor = [UIColor chalkboardGreen];
    self.configView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.configView.layer.borderWidth = 3.0f;
    self.configView.layer.cornerRadius = 10;
    
    UILabel *groupsOfLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 190, 40)];
    groupsOfLabel.text = @"Groups Of:";
    groupsOfLabel.textColor = [UIColor whiteColor];
    groupsOfLabel.textAlignment = NSTextAlignmentCenter;
    groupsOfLabel.font = [UIFont fontWithName:@"Chalkduster" size:26];
    
    [self.configView addSubview:groupsOfLabel];
    
    //2 Button
    self.twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.twoButton.frame = CGRectMake(75, 80, 50.0, 20.0);
    [self configureButton:self.twoButton withTitle:@"2" andSize:60];
    [self.twoButton addTarget:self action:@selector(groupsOfTwo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.configView addSubview:self.twoButton];
    
    //3 Button
    self.threeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.threeButton.frame = CGRectMake(75, 160, 50.0, 20.0);
    [self configureButton:self.threeButton withTitle:@"3" andSize:60];
    [self.threeButton addTarget:self action:@selector(groupsOfThree) forControlEvents:UIControlEventTouchUpInside];
    
    [self.configView addSubview:self.threeButton];
    
    //4 Button
    self.fourButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fourButton.frame = CGRectMake(75, 240, 50.0, 20.0);
    [self configureButton:self.fourButton withTitle:@"4" andSize:60];
    [self.fourButton addTarget:self action:@selector(groupsOfFour) forControlEvents:UIControlEventTouchUpInside];
    
    [self.configView addSubview:self.fourButton];
    
    [self.view addSubview:self.configView];
}

- (void)configureButton: (UIButton *)button withTitle:(NSString *)title andSize:(CGFloat)size {
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.tintColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont fontWithName:@"Chalkduster" size:size];
    
}

- (void)groupsOfTwo {
    [self growsOnTouch:self.twoButton withDuration:.3];
    [self refresh];
    numberOfPeopleInGroup = 2;
    [self refreshData];
    [self configButtonPressed];
}

- (void)groupsOfThree {
    [self growsOnTouch:self.threeButton withDuration:.3];
    [self refresh];
    numberOfPeopleInGroup = 3;
    [self refreshData];
    [self configButtonPressed];
}

- (void)groupsOfFour {
    [self growsOnTouch:self.fourButton withDuration:.3];
    [self refresh];
    numberOfPeopleInGroup = 4;
    [self refreshData];
    [self configButtonPressed];
    [self refreshData];
}

- (void)refresh{
    [self growsOnTouch:self.randomizeButton withDuration:.3];
    [GroupController sharedInstance].temporaryStudentList =  [[GroupController sharedInstance] shuffle:[GroupController sharedInstance].temporaryStudentList];
    [self refreshData];
}

- (void)refreshData {
    [self.collectionView reloadData];
}

#pragma mark - Gesture Recognition 

-(void)setupSwipeGestures {
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

-(void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer {
    if (self.configIsOut == YES) {
    }
    else {
        [self configButtonPressed];
    }
}

-(void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer {
    if (self.configIsOut == YES) {
        [self configButtonPressed];
    }
    else {
        }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self refresh];
    } 
}

#pragma mark -  Animations

- (void)moveOver:(UIView *)view thisMuch:(float)distance withDuration:(float)duration {
    
    [UIView animateWithDuration:duration animations:^{
        view.center = CGPointMake(view.center.x + distance, view.center.y);
    }];
}

- (void)configButtonPressed {
    [self growsOnTouch:self.configButton withDuration:.3];

    if ([self.configButton.titleLabel.text isEqualToString:@"*"]) {
        [self moveConfigMenuOver];
        [self.configButton setTitle:@"->" forState:UIControlStateNormal];
        self.configIsOut = YES;
    }
    else if ([self.configButton.titleLabel.text isEqualToString:@"->"]) {
        [self moveConfigMenuBack];
        [self.configButton setTitle:@"*" forState:UIControlStateNormal];
        self.configIsOut = NO;
    }
}

- (void)moveConfigMenuOver {
    [self moveOver:self.configView thisMuch:-200 withDuration:.5];
}

-(void)moveConfigMenuBack {
    [self moveOver:self.configView thisMuch:200 withDuration:.3];
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

