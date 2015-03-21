//
//  AppearanceController.m
//  Teacher Resources
//
//  Created by Parker Rushton on 3/16/15.
//  Copyright (c) 2015 PJayRushton. All rights reserved.
//

#import "AppearanceController.h"
#import "AppDelegate.h"
#import "UIColor+Category.h"

@implementation AppearanceController

+(void)setupAppearance {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    //Navigation Bar
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Chalkduster" size:24], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor woodColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Chalkduster" size:14]} forState:UIControlStateNormal];
    
    [[UILabel appearance] setTextColor:[UIColor whiteColor]];
}

//Attribution:
//<div>Icons made by <a href="http://www.flaticon.com/authors/dave-gandy" title="Dave Gandy">Dave Gandy</a>, <a href="http://www.flaticon.com/authors/icons8" title="Icons8">Icons8</a>, <a href="http://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a>             is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a></div>
//<div>Icons made by <a href="http://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a>             is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a></div>

//<div>Icons made by <a href="http://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a>             is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a></div>

//<a href="http://icons8.com/web-app/6254/Right2">Right2 icon credits</a>

//<a href="http://icons8.com/web-app/6253/Left2">Free icons by Icons8</a>

//<a href="http://icons8.com/web-app/7789/Right-Filled">Free icons by Icons8</a>



@end
