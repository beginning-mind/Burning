//
//  BurningNavControl.m
//  Burning
//
//  Created by 李想 on 15/5/22.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BurningNavControl.h"

@implementation BurningNavControl

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.bgNav = [[UIView alloc]init];
        self.bgNav.userInteractionEnabled = YES;
        [self.bgNav setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.bgNav];
        //left contraint
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.bgNav attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
        [self addConstraint:constraint];
        //right contraint
        constraint = [NSLayoutConstraint constraintWithItem:self.bgNav attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
        [self addConstraint:constraint];
        //top contraint
        constraint = [NSLayoutConstraint constraintWithItem:self.bgNav attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
        [self addConstraint:constraint];
        //height constraint
        constraint = [NSLayoutConstraint constraintWithItem:self.bgNav attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:64.0f];
        [self.bgNav addConstraint:constraint];
        
        //left button
        self.leftButton = [[UIButton alloc]init];
        [self.leftButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.bgNav addSubview:self.leftButton];
        //top contraint
        constraint = [NSLayoutConstraint constraintWithItem:self.leftButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bgNav attribute:NSLayoutAttributeTop multiplier:1.0f constant:20.0f];
        [self.bgNav addConstraint:constraint];
        //left constrant
        constraint = [NSLayoutConstraint constraintWithItem:self.leftButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.bgNav attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
        [self.bgNav addConstraint:constraint];
        //width constraint
        constraint = [NSLayoutConstraint constraintWithItem:self.leftButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:80.0f];
        [self.leftButton addConstraint:constraint];
        //height constraint
        constraint = [NSLayoutConstraint constraintWithItem:self.leftButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:44.0f];
        [self.leftButton addConstraint:constraint];
        
        //title
        self.title = [[UILabel alloc]init];
        [self.title setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.title.font = [UIFont systemFontOfSize:18];
        [self.bgNav addSubview:self.title];
        //top contraint
        constraint = [NSLayoutConstraint constraintWithItem:self.title attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bgNav attribute:NSLayoutAttributeTop multiplier:1.0f constant:31.0f];
        [self.bgNav addConstraint:constraint];
        //horiztol constrant
        constraint = [NSLayoutConstraint constraintWithItem:self.title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.bgNav attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
        [self.bgNav addConstraint:constraint];
        
        //rightButton
        self.rightButton =[[UIButton alloc]init];
        [self.rightButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.bgNav addSubview:self.rightButton];
        
        //top contraint
        constraint = [NSLayoutConstraint constraintWithItem:self.rightButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bgNav attribute:NSLayoutAttributeTop multiplier:1.0f constant:20.0f];
        [self.bgNav addConstraint:constraint];
        //right constrant
        constraint = [NSLayoutConstraint constraintWithItem:self.rightButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.bgNav attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
        [self.bgNav addConstraint:constraint];
        //width constraint
        constraint = [NSLayoutConstraint constraintWithItem:self.rightButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:44.0f];
        [self.rightButton addConstraint:constraint];
        //height constraint
        constraint = [NSLayoutConstraint constraintWithItem:self.rightButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:44.0f];
        [self.rightButton addConstraint:constraint];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
