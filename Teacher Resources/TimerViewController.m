//
//  TimerViewController.m
//  Teacher Resources
//
//  Created by Parker Rushton on 3/10/15.
//  Copyright (c) 2015 PJayRushton. All rights reserved.
//

#import "TimerViewController.h"
#import "Timer.h"

@interface TimerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *startbutton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timer;
@property (weak, nonatomic) IBOutlet UIButton *secButton5;
@property (weak, nonatomic) IBOutlet UIButton *secondTimer10;
@property (weak, nonatomic) IBOutlet UIButton *secondTimer30;
@property (weak, nonatomic) IBOutlet UIButton *minTimer1;
@property (weak, nonatomic) IBOutlet UIButton *minTimer2;
@property (weak, nonatomic) IBOutlet UIButton *minTimer5;

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForNotifications];
    [self.picker selectRow:60 *50 inComponent:1 animated:NO];
    //If Timer is OFF
    if ([Timer sharedInstance].isOn == NO) {
        [self.pauseButton setEnabled:NO];
        [self.timer setHidden:YES];
    }
    //If Timer is ON
    else if ([Timer sharedInstance].isOn == YES) {
        [self hidePicker];
    }
    
}

#pragma - mark UIButtons Pressed

- (IBAction)startButtonPressed:(id)sender {
    //When START is pressed
    if ([self.startbutton.titleLabel.text isEqualToString:@"Start"]) {
        [[Timer sharedInstance] startTimer];
        [self updateTimerLabel];
        [self setUpNotification];

        //VIEWS
        //Timer Label
        [self.timer setHidden:NO];
        //Picker
        [self hidePicker];
        
        //Start Button
        [self.startbutton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.startbutton setTitleColor: [UIColor redColor] forState:UIControlStateNormal];
//        [self.startbutton.titleLabel setFont:[UIFont fontWithName:@"Heiti TC" size:42.0]];
        
        //PauseButton
        [self.pauseButton setEnabled:YES];
    }
    //When CANCEL is pressed
    if ([self.startbutton.titleLabel.text isEqualToString:@"Cancel"]) {
        [[Timer sharedInstance] cancelTimer];
    
        //VIEWS
        //Timer Label
        [self.timer setHidden:YES];
        //Picker
        [self showPicker];
        [self.picker selectRow:60 *50 inComponent:1 animated:NO];
        [self.picker selectRow:0 inComponent:0 animated:NO];

        
        //Start Button
        [self.startbutton setTitle:@"Start" forState:UIControlStateNormal];
        [self.startbutton setTitleColor:[UIColor colorWithRed:0.22 green:0.502 blue:0.141 alpha:1]forState:UIControlStateNormal];
        
        //Pause Button
        [self.pauseButton setEnabled:NO];
        [self.view reloadInputViews];
    }
}

- (IBAction)pauseButtonPressed:(id)sender {
    //When PAUSE is pressed
    if ([self.pauseButton.titleLabel.text isEqualToString:@"Pause"]) {
        [Timer sharedInstance].isOn = NO;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        [self.pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
        [self.pauseButton setTitleColor:[UIColor colorWithRed:0.22 green:0.502 blue:0.141 alpha:1] forState:UIControlStateNormal];

    }
    //When RESUME is pressed
    if ([self.pauseButton.titleLabel.text isEqualToString:@"Resume"]) {
        [[Timer sharedInstance] startTimer];
        [self setUpNotification];
        
        //Add Edit Views
        [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.pauseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
}

-(void)updateTimerLabel {
    self.timer.text = [NSString stringWithFormat: @"%ld:%02ld", (long)[Timer sharedInstance].minutes, (long)[Timer sharedInstance].seconds];
}

-(void)timerComplete {
    [self.timer setHidden:YES];
    [self showPicker];
}

-(void)hidePicker {
    [self.picker removeFromSuperview];
    [self.secondsLabel setHidden:YES];
    [self.minutesLabel setHidden:YES];
}

-(void)showPicker {
    [self.view addSubview:self.picker];
    [self.secondsLabel setHidden:NO];
    [self.minutesLabel setHidden:NO];
}


- (IBAction)secWarning5:(id)sender {
    [self setupAlert:5 type:@"Seconds"];
    
}

- (IBAction)secWarning10:(id)sender {
    [self setupAlert:10 type:@"Seconds"];
}

- (IBAction)secWarning30:(id)sender {
    [self setupAlert:30 type:@"Seconds"];
}

- (IBAction)minWarning1:(id)sender {
    [self setupAlert:1 type:@"Minutes"];
}

- (IBAction)minWarning2:(id)sender {
    [self setupAlert:2 type:@"Minutes"];
}

- (IBAction)minWarning5:(id)sender {
    [self setupAlert:5 type:@"Minutes"];
}

#pragma - mark Notifications & Alerts


- (void)setupAlert: (int)tag type:(NSString *)type{
    if ([type isEqualToString:@"Seconds"] && [Timer sharedInstance].seconds) {
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat: @"%i %@ Remaining!",tag,type] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertController animated:YES completion:nil];
   
    }
    
    
}

-(void)endTimerAlert {
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Time's Up!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self startButtonPressed:nil];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];


}

-(void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTimerLabel) name:secondTickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endTimerAlert) name:timerCompleteNotification object:nil];
    
}

- (void)setUpNotification{
    UILocalNotification *localNotification = [UILocalNotification new];
    NSDate *fireDate = [[NSDate date]dateByAddingTimeInterval: ([Timer sharedInstance].minutes * 60) + [Timer sharedInstance].seconds];
    localNotification.fireDate = fireDate;
    
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = @"bell_tree.mp3";
    localNotification.alertBody = @"Time's Up!";
    localNotification.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
}


#pragma - mark Picker Delegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *numberString = [NSString stringWithFormat:@"%@", [self seconds][row]];
    return numberString;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSNumber *minutes = [self seconds][[pickerView selectedRowInComponent:0]];
    [Timer sharedInstance].minutes = [minutes integerValue];
    
    NSNumber *seconds = [self seconds][[pickerView selectedRowInComponent:1]];
    [Timer sharedInstance].seconds = [seconds integerValue];
    
    [self updateTimerLabel];
}

#pragma - mark Picker Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self seconds] count];
}

-(NSArray *)seconds {
    NSMutableArray *secondsMutable = [[NSMutableArray alloc] init];
    NSArray *secondsArray = [[NSArray alloc] init];
    for (int i = 0; i < 100; i++) {
        
    for (int i = 0; i < 60; i ++) {
        [secondsMutable addObject:[NSNumber numberWithInt:i]];
    }
}
         secondsArray = secondsMutable;
    return secondsArray;
}

@end
