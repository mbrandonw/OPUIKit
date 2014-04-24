//
//  OPNavigationController.m
//  OPUIKit
//
//  Created by Brandon Williams on 5/29/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import "OPNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+Opetopic.h"
#import "UIViewController+OPUIKit.h"
#import "OPGradientView.h"
#import "UIView+Opetopic.h"
#import "OPBarButtonItem.h"
#import "OPMacros.h"
#import "OPBackBarButtonItem.h"

@implementation OPNavigationController

#pragma mark -
#pragma mark Object lifecycle
#pragma mark -

+(id) controller {
  return [self controllerWithRootViewController:nil];
}

+(id) controllerWithRootViewController:(UIViewController*)rootViewController {

	OPNavigationController *controller = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];

  if (rootViewController) {
    controller.viewControllers = @[rootViewController];
  }
	controller.delegate = controller;

	return controller;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
  if (! (self = [super initWithCoder:aDecoder])) {
    return nil;
  }

  // apply stylings
  [[[self class] styling] applyTo:self];

  return self;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  DLogClassAndMethod();
}

#pragma mark -
#pragma mark View lifecycle
#pragma mark -

-(void) viewDidLoad {
  [super viewDidLoad];
  DLogClassAndMethod();
}

#pragma mark -
#pragma mark Overridden UINavigationController methods
#pragma mark -

-(void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self layoutToolbarView];
}

#pragma mark -
#pragma mark UINavigationControllerDelegate methods
#pragma mark -

-(void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

-(void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

@end
