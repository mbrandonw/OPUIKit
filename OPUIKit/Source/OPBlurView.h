//
//  OPBlurView.h
//  Kickstarter
//
//  Created by Brandon Williams on 1/5/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPBlurView : UIView

@property (nonatomic, strong) UIColor *blurTintColor;
-(void) setBlurStyle:(UIBarStyle)style;
-(void) removeBlurTintColor;

@end
