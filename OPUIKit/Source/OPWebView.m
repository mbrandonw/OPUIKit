//
//  OPWebView.m
//  Kickstarter
//
//  Created by Brandon Williams on 6/26/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "OPWebView.h"

@implementation OPWebView

-(instancetype) initWithViewController:(UIViewController*)viewController {
  return [self initWithFrame:CGRectZero viewController:viewController];
}

-(instancetype) initWithFrame:(CGRect)frame viewController:(UIViewController*)viewController {
  self.viewController = viewController;
  return [self initWithFrame:frame];
}

@end
