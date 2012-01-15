//
//  OPTabBarViewController.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/13/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPTabBarController.h"
#import "OPTabBar.h"
#import "OPMacros.h"
#import "UIView+Opetopic.h"

#define kOPTabBarRotationFudgePixels    8.0f

@interface OPTabBarController (/**/) <OPTabBarDelegate>
@property (nonatomic, readwrite, strong) OPTabBar *tabBar;
@property (nonatomic, readwrite, strong) NSArray *viewControllers;
@property (nonatomic, readwrite, strong) UIViewController *selectedViewController;
@property (nonatomic, readwrite, assign) NSUInteger selectedIndex;
@end

@implementation OPTabBarController

@synthesize delegate;

@synthesize tabBar;
@synthesize tabBarPortraitHeight;
@synthesize tabBarLandscapeHeight;

@synthesize viewControllers;
@synthesize selectedViewController;
@synthesize selectedIndex;

#pragma mark -
#pragma mark === Object Lifecycle ===
#pragma mark -

-(id) init {
    if (! (self = [super init]))
        return nil;
    
    // default ivars
    self.tabBarPortraitHeight = 49.0f;
    self.tabBarLandscapeHeight = 40.0f;
    
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark === View Lifecycle ===
#pragma mark -

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    
    self.tabBar = [[OPTabBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? self.tabBarPortraitHeight : self.tabBarLandscapeHeight)];
    self.tabBar.delegate = self;
    self.tabBar.bottom = self.view.height;
    self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.tabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark === View controller management ===
#pragma mark -

-(void) setViewControllers:(NSArray*)viewControllers withTabBarItems:(NSArray*)tabBarItems {
    
}

#pragma mark -
#pragma mark === Orientation methods ===
#pragma mark -

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
    // ask the selected view controller if we should rotate
    return [self.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // adjust the height of the tab bar based on portrait/landscape, and snap it to the bottom of the view
    CGFloat height = UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? self.tabBarPortraitHeight : self.tabBarLandscapeHeight;
    self.tabBar.top += self.tabBar.height - height;
    self.tabBar.height = height;
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
}

#pragma mark -
#pragma mark === Custom getters/setters ===
#pragma mark -

-(OPTabBar*) tabBar {
    if (! tabBar && ! [self isViewLoaded]) {
        DLog(@"--------------------------------------------------------");
        DLog(@"OPTabBarController Error:");
        DLog(@"Cannot configure `tabBar` until controller is presented.");
        DLog(@"--------------------------------------------------------");
    }
    
    return tabBar;
}

-(void) setTabBarPortraitHeight:(CGFloat)h {
    tabBarPortraitHeight = h;
    if ([self isViewLoaded] && UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        self.tabBar.frame = CGRectMake(0.0f, self.view.height-h, self.view.width, h);
}

-(void) setTabBarLandscapeHeight:(CGFloat)h {
    tabBarLandscapeHeight = h;
    if ([self isViewLoaded] && UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        self.tabBar.frame = CGRectMake(0.0f, self.view.height-h, self.view.width, h);
}

#pragma mark -
#pragma mark === OPTabBarDelegate methods ===
#pragma mark -

-(void) tabBar:(OPTabBar*)tabBar didSelectItem:(OPTabBarItem*)item atIndex:(NSUInteger)index {
    
    UIViewController *controller = [self.viewControllers objectAtIndex:index];
    
    if (self.selectedViewController == controller)
    {
        if ([self.selectedViewController isKindOfClass:[UINavigationController class]])
            [(UINavigationController*)self.selectedViewController popToRootViewControllerAnimated:YES];
    }
    else
    {
        UIViewController *previousController = self.selectedViewController;
        self.selectedViewController = controller;
        self.selectedIndex = index;
        
        [previousController viewWillDisappear:NO];
        [self.selectedViewController viewWillAppear:NO];
        {
            [previousController.view removeFromSuperview];
            [self.view addSubviewToBack:self.selectedViewController.view];
            
            self.selectedViewController.view.frame = CGRectMake(self.view.bounds.origin.x, 
                                                                self.view.bounds.origin.y, 
                                                                self.view.bounds.size.width, 
                                                                self.view.bounds.size.height - self.tabBar.height);
            self.selectedViewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
                                                                 UIViewAutoresizingFlexibleHeight | 
                                                                 UIViewAutoresizingFlexibleBottomMargin);
            [self.selectedViewController.view setNeedsLayout];
        }
        [previousController viewDidDisappear:NO];
        [self.selectedViewController viewDidAppear:NO];
    }
}


@end
