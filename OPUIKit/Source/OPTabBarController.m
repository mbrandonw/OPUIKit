//
//  OPTabBarViewController.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/13/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPTabBarController.h"
#import "OPTabBarItem.h"
#import "OPTabBar.h"
#import "OPMacros.h"
#import "UIView+Opetopic.h"

#define kOPTabBarRotationFudgePixels    8.0f

@interface OPTabBarController (/**/) <OPTabBarDelegate, UINavigationControllerDelegate>
@property (nonatomic, readwrite, strong) OPTabBar *tabBar;
@property (nonatomic, readwrite, strong) NSArray *viewControllers;
@property (nonatomic, readwrite, strong) UIViewController *selectedViewController;
@property (nonatomic, readwrite, assign) NSUInteger selectedIndex;
@end

@implementation OPTabBarController

@synthesize delegate = _delegate;

@synthesize tabBar = _tabBar;
@synthesize tabBarPortraitHeight = _tabBarPortraitHeight;
@synthesize tabBarLandscapeHeight = _tabBarLandscapeHeight;
@synthesize hidesToolbarTitlesInLandscape = _hidesToolbarTitlesInLandscape;

@synthesize viewControllers = _viewControllers;
@synthesize selectedViewController = _selectedViewController;
@synthesize selectedIndex = _selectedIndex;

#pragma mark -
#pragma mark Object Lifecycle
#pragma mark -

-(id) init {
    if (! (self = [super init]))
        return nil;
    
    // default ivars
    self.tabBarPortraitHeight = 49.0f;
    self.tabBarLandscapeHeight = 40.0f;
    
    // init the tab bar
    self.tabBar = [[OPTabBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 0.0f)];
    self.tabBar.delegate = self;
    self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark View Lifecycle
#pragma mark -

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor redColor];
    
    // configure the tab bar
    self.tabBar.frame = CGRectMake(0.0f, 0.0f, self.view.width, UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? self.tabBarPortraitHeight : self.tabBarLandscapeHeight);
    [self.tabBar setNeedsDisplayAndLayout];
    self.tabBar.bottom = self.view.height;
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
#pragma mark View controller management
#pragma mark -

-(void) setViewControllers:(NSArray*)viewControllers withTabBarItems:(NSArray*)tabBarItems {
    
    self.viewControllers = viewControllers;
    self.tabBar.items = tabBarItems;
    
    // wish there was a better way to do this, but unfortunately we need the navigation controller delegate so that we can hide/show the tab bar
    for (UIViewController *controller in self.viewControllers)
        if ([controller isKindOfClass:[UINavigationController class]])
            [(UINavigationController*)controller setDelegate:self];
    
    if (self.selectedIndex < [self.viewControllers count])
        self.selectedIndex = self.selectedIndex;
    else if ([self.viewControllers count] > 0)
        self.selectedIndex = 0;
}

#pragma mark -
#pragma mark Orientation methods
#pragma mark -

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // ask the selected view controller if we should rotate
    return [self.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // adjust the height of the tab bar based on portrait/landscape, and snap it to the bottom of the view
    CGFloat height = UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? self.tabBarPortraitHeight : self.tabBarLandscapeHeight;
    CGFloat heightDelta = height - self.tabBar.height;
    self.tabBar.top += self.tabBar.height - height;
    self.tabBar.height = height;
    
    // hide tab bar item titles if necessary
    for (OPTabBarItem *item in self.tabBar.items)
        item.titleLabel.hidden = self.hidesToolbarTitlesInLandscape && UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    
    // re-layout the tab bar
    [self.tabBar setNeedsDisplayAndLayout];
    
    // make the selected view controller fill the entire containing view so that it autoresizes to remain full view
    self.selectedViewController.view.height += height - heightDelta;
    
    // forward rotation events to the selected view controller
    [self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // adjust the selected view controller's height to stop at the bottom tab bar
    self.selectedViewController.view.height -= self.tabBar.height;
    
    // forward rotation events to the selected view controller
    [self.selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


// These are deprecated now, but still forwarding rotation events to the selected view controller
-(void) willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)anOrientation duration:(NSTimeInterval)aDuration {
	[self.selectedViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:anOrientation duration:aDuration];
}
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)anOrientation duration:(NSTimeInterval)aDuration {
	[self.selectedViewController willAnimateRotationToInterfaceOrientation:anOrientation duration:aDuration];
}
-(void) willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)anOrientation duration:(NSTimeInterval)aDuration {
	[self.selectedViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:anOrientation duration:aDuration];
}

#pragma mark -
#pragma mark Custom getters/setters
#pragma mark -

-(OPTabBar*) tabBar {
    if (! _tabBar && ! [self isViewLoaded]) {
        DLog(@"--------------------------------------------------------");
        DLog(@"OPTabBarController Error:");
        DLog(@"Cannot configure `tabBar` until controller is presented.");
        DLog(@"--------------------------------------------------------");
    }
    return _tabBar;
}

-(void) setTabBarPortraitHeight:(CGFloat)h {
    _tabBarPortraitHeight = h;
    if ([self isViewLoaded] && UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        self.tabBar.frame = CGRectMake(0.0f, self.view.height-h, self.view.width, h);
}

-(void) setTabBarLandscapeHeight:(CGFloat)h {
    _tabBarLandscapeHeight = h;
    if ([self isViewLoaded] && UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        self.tabBar.frame = CGRectMake(0.0f, self.view.height-h, self.view.width, h);
}

-(void) setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    UIViewController *controller = [self.viewControllers objectAtIndex:_selectedIndex];
    UIViewController *previousController = self.selectedViewController;
    self.selectedViewController = controller;
    
    // remove the previous view controller from our view hierarchy
    [previousController viewWillDisappear:NO];
    [previousController.view removeFromSuperview];
    [previousController viewDidDisappear:NO];
    
    // configure the next view controller
    self.selectedViewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
                                                         UIViewAutoresizingFlexibleHeight | 
                                                         UIViewAutoresizingFlexibleBottomMargin);
    self.selectedViewController.view.frame = CGRectMake(0.0f, 0.0f,
                                                        self.view.bounds.size.width, 
                                                        self.view.bounds.size.height - self.tabBar.height);
    
    // add the next view controller to our view hiearchy
    [self.selectedViewController viewWillAppear:NO];
    [self.view addSubviewToBack:self.selectedViewController.view];
    [self.selectedViewController.view setNeedsLayout];
    [self.selectedViewController viewDidAppear:NO];
}

#pragma mark -
#pragma mark OPTabBarDelegate methods
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
        self.selectedIndex = index;
    }
}

#pragma mark -
#pragma mark UINavigationControllerDelegate methods
#pragma mark -

-(void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // check if we should hide/show the tab bar based on the view controller we are pushing onto the stack
    if (viewController.hidesBottomBarWhenPushed && ! self.tabBar.hidden)
    {
        self.selectedViewController.view.height += self.tabBar.height;
        [UIView animateWithDuration:0.35f animations:^{
            self.tabBar.right = 0.0f;
        } completion:^(BOOL finished) {
            self.tabBar.hidden = YES;
        }];
    }
    else if (! viewController.hidesBottomBarWhenPushed && self.tabBar.hidden)
    {
        self.tabBar.hidden = NO;
        [UIView animateWithDuration:0.35f animations:^{
            self.tabBar.left = 0.0f;
        } completion:^(BOOL finished) {
            self.selectedViewController.view.height -= self.tabBar.height;
        }];
    }
    
    // pass the delegate method back to the navigation controller if it can handle it
    if ([navigationController conformsToProtocol:@protocol(UINavigationControllerDelegate)])
        [(id<UINavigationControllerDelegate>)navigationController navigationController:navigationController willShowViewController:viewController animated:animated];
}

-(void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // pass the delegate method back to the navigation controller if it can handle it
    if ([navigationController conformsToProtocol:@protocol(UINavigationControllerDelegate)])
        [(id<UINavigationControllerDelegate>)navigationController navigationController:navigationController didShowViewController:viewController animated:animated];
}


@end
