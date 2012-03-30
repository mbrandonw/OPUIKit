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

@protocol OPTabBarControllerDelegate <NSObject>
@optional
-(BOOL) tabBarController:(OPTabBarController*)tabBarController shouldSelectViewController:(UIViewController*)viewController;
-(void) tabBarController:(OPTabBarController*)tabBarController didSelectViewController:(UIViewController*)viewController;
@end

@interface OPTabBarController : OPViewController

@property (nonatomic, assign) id<OPTabBarControllerDelegate> delegate;

@property (nonatomic, readonly, strong) OPTabBar *tabBar;   // Don't be a jerk and mess with the tab bar items :-)
@property (nonatomic, assign) CGFloat tabBarPortraitHeight;
@property (nonatomic, assign) CGFloat tabBarLandscapeHeight;
@property (nonatomic, assign) BOOL hidesToolbarTitlesInLandscape;
@property (nonatomic, assign) BOOL tabBarHidden;

@property (nonatomic, readonly) NSArray *viewControllers;
@property (nonatomic, strong, readonly) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;

-(void) setViewControllers:(NSArray*)viewControllers withTabBarItems:(NSArray*)tabBarItems;
-(void) setViewControllers:(NSArray*)viewControllers withTabBarItems:(NSArray*)tabBarItems animated:(BOOL)animated;
-(void) setViewControllers:(NSArray*)viewControllers withTabBarItems:(NSArray*)tabBarItems animated:(BOOL)animated completion:(void(^)(void))completion;

-(void) setTabBarHidden:(BOOL)tabBarHidden animated:(BOOL)animated;

@end


/**
 Adds a `tabController` property to all UIViewController instances in order to 
 replicate the `tabBarController` property you get when using the standard
 UIKit components
 */
@interface UIViewController (OPTabBarControllerDelegate)
@property (nonatomic, readonly) OPTabBarController *tabController;
@end
