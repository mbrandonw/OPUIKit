//
//  OPWebView.h
//  Kickstarter
//
//  Created by Brandon Williams on 6/26/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPWebView : UIWebView

@property (nonatomic, weak) UIViewController *viewController;

-(instancetype) initWithViewController:(UIViewController*)viewController;
-(instancetype) initWithFrame:(CGRect)frame viewController:(UIViewController*)viewController;

@end
