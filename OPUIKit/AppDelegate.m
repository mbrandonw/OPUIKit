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
#import "OPGradient.h"
#import "NSNumber+Opetopic.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    OPTabBarController *root = [[OPTabBarController alloc] init];
    
    self.window.rootViewController = root;
    
    root.tabBar.backgroundColor = [UIColor hex:0xbf3030];
    root.tabBar.style = OPTabBarStyleGloss;
    root.tabBar.shadowHeight = 4.0f;
    root.tabBarPortraitHeight = 49.0f;
    root.tabBarLandscapeHeight = 36.0f;
    
    __block OPTabBar *blockTabBar = root.tabBar;
    [root.tabBar addFrontDrawingBlock:^(OPView *v, CGRect r, CGContextRef c) {
        [[blockTabBar.backgroundColor darken:0.5f] set];
        CGContextFillRect(c, CGRectMake(0.0f, 0.0f, r.size.width, 2.0f));
        [[blockTabBar.backgroundColor lighten:0.3f] set];
        CGContextFillRect(c, CGRectMake(0.0f, 2.0f, r.size.width, 1.0f));
    }];
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i++)
    {
        OPTabBarItem *item = [[OPTabBarItem alloc] init];
        item.width = self.window.width/4;
        [items addObject:item];
        
        [item setTitle:[NSString stringWithFormat:@"Item %i", i] forState:UIControlStateNormal];
        [item setTitleColor:[blockTabBar.backgroundColor lighten:0.5f] forState:UIControlStateNormal];
        [item setTitleColor:[blockTabBar.backgroundColor lighten:0.8f] forState:UIControlStateSelected];
        [item setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        item.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        item.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [item setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, -24.0f, 0.0f)];
        
        [item addDrawingBlock:^(OPButton *b, CGRect r, CGContextRef c) {
            
            CGPoint center = CGRectCenter(r);
            center.y -= 5.0f;
            UIImage *icon = [UIImage imageNamed:@"icon.png"];
            [icon drawAtPoint:CGPointMake(center.x - roundf(icon.size.width/2.0f), center.y - roundf(icon.size.height/2.0f))];
            
        } forState:UIControlStateNormal | UIControlStateHighlighted | UIControlStateSelected];
        
        [item addDrawingBlock:^(OPButton *b, CGRect r, CGContextRef c) {
            
            [[OPGradient gradientWithColors:$array([blockTabBar.backgroundColor darken:0.7f], [blockTabBar.backgroundColor darken:0.4f]) 
                                  locations:$array($float(0.0f), $float(0.75f))]
             fillRectLinearly:r];
            
        } forState:UIControlStateSelected];
    }
    [root.tabBar setItems:items];
    root.tabBar.itemDistribution = OPTabBarItemDistributionEvenlySpaced;
    
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
