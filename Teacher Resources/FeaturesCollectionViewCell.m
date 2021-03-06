//
//  FeaturesCollectionViewCell.m
//  Teacher Resources
//
//  Created by Ethan Hess on 3/11/15.
//  Copyright (c) 2015 PJayRushton. All rights reserved.
//

#import "FeaturesCollectionViewCell.h"
#import "UIColor+Category.h"

@implementation FeaturesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}



-(void)setTitle:(NSString *)title
{
    _title = title;
}

-(void)setupViews
{
    CGFloat backViewHeight = (self.frame.size.height / 4);
    CGFloat viewHeight = self.frame.size.height;
    CGFloat viewWidth = self.frame.size.width;
    
    self.footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, viewHeight - backViewHeight, viewWidth, backViewHeight)];
    self.footerLabel.text = self.title;
    self.footerLabel.numberOfLines = 0;
    self.footerLabel.textColor = [UIColor whiteColor];
    [self.footerLabel setTextAlignment:NSTextAlignmentCenter];
        
    [self addSubview:self.footerLabel];
}

@end
