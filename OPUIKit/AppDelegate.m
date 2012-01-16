//
//  OPAppDelegate.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/7/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "AppDelegate.h"
#import "OPTabBar.h"
#import "OPTabBarItem.h"
#import "OPTabBarController.h"
#import "OPMacros.h"
#import "NSArray+Opetopic.h"
#import "UIColor+Opetopic.h"
#import "OPGradientView.h"
#import "UIView+Opetopic.h"
#import "Quartz+Opetopic.h"
#import "NSString+Opetopic.h"
#import "OPGradient.h"
#import "UIDevice+Opetopic.h"
#import "NSNumber+Opetopic.h"
#import "TestViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    OPTabBarController *root = [[OPTabBarController alloc] init];
    
    root.tabBar.backgroundColor = $hex(0xbf3030);
    root.tabBar.shadowHeight = 6.0f;
    [root.tabBar setShadowAlphaStops:$array($float(0.0f),$float(0.2f))];
    root.tabBar.glossAmount = 0.05f;
    root.tabBar.glossOffset = 1.0f;
    root.tabBar.gradientAmount = 0.1f;
    root.tabBar.shadowHeight = [UIDevice isPad] ? 6.0f : 4.0f;
    root.tabBarPortraitHeight = 49.0f;
    root.tabBarLandscapeHeight = [UIDevice isPad] ? 49.0f : 36.0f;
    root.hidesToolbarTitlesInLandscape = [UIDevice isPad] ? NO : YES;
    root.tabBar.itemLayout = [UIDevice isPad] ? OPTabBarItemLayoutCenterGrouped : OPTabBarItemLayoutEvenlySpaced;
    root.tabBar.maxItemWidth = [UIDevice isPad] ? 160.0f : CGFLOAT_MAX;
    
    __block OPTabBar *blockTabBar = root.tabBar;
    
    [root.tabBar addDrawingBlock:^(OPView *v, CGRect r, CGContextRef c) {
        [[blockTabBar.backgroundColor darken:0.5f] set];
        CGContextFillRect(c, CGRectMake(0.0f, 0.0f, r.size.width, 2.0f));
        [[blockTabBar.backgroundColor lighten:0.3f] set];
        CGContextFillRect(c, CGRectMake(0.0f, 2.0f, r.size.width, 1.0f));
    }];
    
    NSArray *titles = $array(@"Playlists", @"Artists", @"Songs", @"Albums");
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < [titles count]; i++)
    {
        OPTabBarItem *item = [[OPTabBarItem alloc] init];
        item.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%i.png", i]];
        item.iconViewInsets = UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f);
        item.titleLabel.text = [titles objectAtIndex:i];
        item.titleLabel.shadowColor = [UIColor blackColor];
        item.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
        item.width = self.window.width/4;
        [items addObject:item];
        
        [item addDrawingBlock:^(OPControl *b, CGRect r, CGContextRef c) {
            
        } forState:UIControlStateNormal];
        
        [item addDrawingBlock:^(OPControl *b, CGRect r, CGContextRef c) {
            
            [[OPGradient gradientWithColors:$array([blockTabBar.backgroundColor darken:0.3f], [blockTabBar.backgroundColor darken:0.1f]) 
                                  locations:$array($float(0.0f), $float(0.75f))]
             fillRectLinearly:CGRectMake(0.0f, 2.0f, r.size.width, r.size.height-2.0f)];
            
            if (i > 0) {
                [[blockTabBar.backgroundColor lighten:0.1f] set];
                CGContextFillRect(c, CGRectMake(0.0f, 2.0f, 1.0f, b.height));
            }
            if (i < [titles count] - 1) {
                [[blockTabBar.backgroundColor lighten:0.1f] set];
                CGContextFillRect(c, CGRectMake(b.width-1.0f, 2.0f, 1.0f, b.height));
            }
            
        } forState:UIControlStateSelected];
    }
    
    NSArray *controllers = [NSArray arrayWithObjects:
                            [[UINavigationController alloc] initWithRootViewController:[TestViewController new]],
                            [[UINavigationController alloc] initWithRootViewController:[TestViewController new]],
                            [[UINavigationController alloc] initWithRootViewController:[TestViewController new]],
                            [[UINavigationController alloc] initWithRootViewController:[TestViewController new]],
                            nil];
    
    [root setViewControllers:controllers withTabBarItems:items];
    
    self.window.rootViewController = root;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
