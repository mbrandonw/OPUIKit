//
//  OPTabBarViewController.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/13/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPViewController.h"

@class OPTabBar;
@class OPTabBarController;

@protocol OPTabBarControllerDelegate <UITabBarControllerDelegate>
-(BOOL) tabBarController:(OPTabBarController*)tabBarController shouldSelectViewController:(UIViewController*)viewController;
-(void) tabBarController:(OPTabBarController*)tabBarController didSelectViewController:(UIViewController*)viewController;
@end

@interface OPTabBarController : OPViewController

@property (nonatomic, assign) id<OPTabBarControllerDelegate> delegate;

@property (nonatomic, readonly, strong) OPTabBar *tabBar;   // Don't be a jerk and mess with the tab bar items :-)
@property (nonatomic, assign) CGFloat tabBarPortraitHeight;
@property (nonatomic, assign) CGFloat tabBarLandscapeHeight;
@property (nonatomic, assign) BOOL hidesToolbarTitlesInLandscape;

@property (nonatomic, readonly, strong) NSArray *viewControllers;
@property (nonatomic, readonly, strong) UIViewController *selectedViewController;
@property (nonatomic, readonly, assign) NSUInteger selectedIndex;

-(void) setViewControllers:(NSArray*)viewControllers withTabBarItems:(NSArray*)tabBarItems;

@end
