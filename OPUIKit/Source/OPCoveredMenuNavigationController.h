//
//  OPCoveredMenuNavigationController.h
//  Kickstarter
//
//  Created by Brandon Williams on 3/30/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPNavigationController.h"

@interface OPCoveredMenuNavigationController : OPNavigationController

@property (nonatomic, strong) UIViewController *coveredViewController;

@property (nonatomic, assign, getter=isCoveredViewControllerHidden) BOOL coveredViewControllerHidden;
-(void) setCoveredViewControllerHidden:(BOOL)hidden animated:(BOOL)animated;

@end
