//
//  OPTabBarViewController.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/13/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPTabBarController.h"
#import <objc/runtime.h>
#import "UIScrollView+Opetopic.h"
#import "OPTabBarItem.h"
#import "OPTabBar.h"
#import "OPMacros.h"
#import "UIView+Opetopic.h"
#import "UIDevice+Opetopic.h"

const struct OPTabBarControllerNotifications OPTabBarControllerNotifications = {
	.willSelectViewController = @"OPTabBarControllerNotifications.willSelectViewController",
	.didSelectViewController = @"OPTabBarControllerNotifications.didSelectViewController",
};

#define kOPTabBarRotationFudgePixels    8.0f

@interface OPTabBarController (/**/) <OPTabBarDelegate, UINavigationControllerDelegate>
@property (nonatomic, readwrite, strong) OPTabBar *tabBar;
@property (nonatomic, strong, readwrite) UIViewController *selectedViewController;
@end

@implementation OPTabBarController

@synthesize delegate = _delegate;

@synthesize tabBar = _tabBar;
@synthesize tabBarHidden = _tabBarHidden;
@synthesize tabBarPortraitHeight = _tabBarPortraitHeight;
@synthesize tabBarLandscapeHeight = _tabBarLandscapeHeight;
@synthesize hidesTabBarTitlesInLandscape = _hidesTabBarTitlesInLandscape;

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
    self.selectedViewController = nil;
    
    // apply stylings
    [[[self class] styling] applyTo:self];
    
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
    self.view.backgroundColor = [UIColor blackColor];
    
    // configure the tab bar
    self.tabBar.frame = CGRectMake(0.0f, 0.0f, self.view.width, UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? self.tabBarPortraitHeight : self.tabBarLandscapeHeight);
    [self.tabBar setNeedsDisplayAndLayout];
    self.tabBar.bottom = self.view.height;
    [self.view addSubview:self.tabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
#pragma mark View controller management
#pragma mark -

-(void) setViewControllers:(NSArray*)viewControllers withTabBarItems:(NSArray*)tabBarItems {
    [self setViewControllers:viewControllers withTabBarItems:tabBarItems animated:NO];
}

-(void) setViewControllers:(NSArray*)viewControllers withTabBarItems:(NSArray*)tabBarItems animated:(BOOL)animated {
    [self setViewControllers:viewControllers withTabBarItems:tabBarItems animated:animated completion:nil];
}

-(void) setViewControllers:(NSArray*)viewControllers withTabBarItems:(NSArray*)tabBarItems animated:(BOOL)animated completion:(void(^)(void))completion {
    
    for (UIViewController *controller in self.childViewControllers) {
        if (! [viewControllers containsObject:controller]) {
            [controller removeFromParentViewController];
        }
    }
    
    for (UIViewController *controller in viewControllers)
    {
        if (controller.parentViewController != self) {
            [controller willMoveToParentViewController:self];
            [self addChildViewController:controller];
            [controller didMoveToParentViewController:self];
        }
        
        // wish there was a better way to do this, but unfortunately we need the navigation controller delegate so that we can hide/show the tab bar
        if ([controller isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)controller setDelegate:self];
        }
    }
    
    [self.tabBar setItems:tabBarItems animated:animated completion:completion];
}

-(NSArray*) viewControllers {
    return self.childViewControllers;
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
        item.titleLabel.hidden = self.hidesTabBarTitlesInLandscape && UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    
    // re-layout the tab bar
    [self.tabBar setNeedsDisplayAndLayout];
    
    // make the selected view controller fill the entire containing view so that it autoresizes to remain full view
    self.selectedViewController.view.height += (height - heightDelta) * (!self.tabBar.hidden);
    
    // forward rotation events to the selected view controller
    [self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // adjust the selected view controller's height to stop at the bottom tab bar
    self.selectedViewController.view.height -= self.tabBar.height * (!self.tabBar.hidden);
    
    [self setTabBarHidden:self.tabBarHidden animated:NO];
    
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
    // lazily load the tab bar
    if (! _tabBar)
    {
        self.tabBar = [[OPTabBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 0.0f)];
        self.tabBar.delegate = self;
        self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
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
    UIViewController *nextController = [self.childViewControllers objectAtIndex:selectedIndex];
    
    if (! [self.delegate respondsToSelector:@selector(tabController:shouldSelectViewController:)] ||
        [self.delegate tabController:self shouldSelectViewController:nextController])
    {
        UIViewController *previousController = self.selectedViewController;
        
        // send out delegate messages
        [[NSNotificationCenter defaultCenter] postNotificationName:OPTabBarControllerNotifications.willSelectViewController object:nextController userInfo:nil];
        if ([self.delegate respondsToSelector:@selector(tabController:willSelectViewController:)])
            [self.delegate tabController:self willSelectViewController:nextController];
        
        for (OPTabBarItem *item in self.tabBar.items)
            [item setSelected:NO];
        [[self.tabBar.items objectAtIndex:selectedIndex] setSelected:YES];
        _selectedIndex = selectedIndex;
        
        self.selectedViewController = nextController;
        
        // remove the previous view controller from our view hierarchy
        if (! [UIDevice isiOS5OrLater])
            [previousController viewWillDisappear:NO];
        [previousController.view removeFromSuperview];
        if (! [UIDevice isiOS5OrLater])
            [previousController viewDidDisappear:NO];
        
        // configure the next view controller
        self.selectedViewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
                                                             UIViewAutoresizingFlexibleHeight | 
                                                             UIViewAutoresizingFlexibleBottomMargin);
        self.selectedViewController.view.frame = CGRectMake(0.0f, 0.0f,
                                                            self.view.bounds.size.width, 
                                                            self.view.bounds.size.height - self.tabBar.height*(!self.tabBar.hidden));
        
        // add the next view controller to our view hiearchy
        if (! [UIDevice isiOS5OrLater])
            [self.selectedViewController viewWillAppear:NO];
        [self.view addSubviewToBack:self.selectedViewController.view];
        [self.selectedViewController.view setNeedsLayout];
        if (! [UIDevice isiOS5OrLater])
            [self.selectedViewController viewDidAppear:NO];
        
        // send out delegate messages
        [[NSNotificationCenter defaultCenter] postNotificationName:OPTabBarControllerNotifications.didSelectViewController object:nextController userInfo:nil];
        if ([self.delegate respondsToSelector:@selector(tabController:didSelectViewController:)])
            [self.delegate tabController:self didSelectViewController:self.selectedViewController];
    }
    else
    {
        [self.tabBar setSelectedItemIndex:self.selectedIndex];
    }
}

-(void) setTabBarHidden:(BOOL)tabBarHidden {
    [self setTabBarHidden:tabBarHidden animated:NO];
}

-(void) setTabBarHidden:(BOOL)tabBarHidden animated:(BOOL)animated {
    _tabBarHidden = tabBarHidden;
    
    CGFloat tabBarHeight = self.tabBar.height;
    CGFloat selfHeight = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? self.view.height : self.view.width;
    
    if (tabBarHidden) {
        self.tabBar.bottom = selfHeight;
        self.selectedViewController.view.height = selfHeight - self.selectedViewController.view.top - tabBarHeight;
    } else {
        self.tabBar.top = selfHeight;
        self.selectedViewController.view.height = selfHeight - self.selectedViewController.view.top;
    }
    
    if (! tabBarHidden)
        self.tabBar.hidden = tabBarHidden;
    [UIView animateWithDuration:(0.3f*animated) animations:^{
        
        if (! tabBarHidden) {
            self.tabBar.bottom = selfHeight;
            self.selectedViewController.view.height = selfHeight - self.selectedViewController.view.top - tabBarHeight;
        } else {
            self.tabBar.top = selfHeight;
            self.selectedViewController.view.height = selfHeight - self.selectedViewController.view.top;
        }
    } asapCompletion:^(BOOL finished) {
        self.tabBar.hidden = tabBarHidden;
    }];
}

#pragma mark -
#pragma mark OPTabBarDelegate methods
#pragma mark -

-(void) tabBar:(OPTabBar*)tabBar didSelectItem:(OPTabBarItem*)item atIndex:(NSUInteger)index {
    
    UIViewController *controller = [self.childViewControllers objectAtIndex:index];
    
    // tapping the tab bar item a 2nd time offers some additional functionality
    if (self.selectedViewController == controller)
    {
        if ([self.selectedViewController isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *navigationController = (UINavigationController*)self.selectedViewController;
            
            // if the selected controller is a navigation controller that is already at its root controller, then we try to scroll its child controller to the top
            if ([navigationController.viewControllers count] == 1)
            {
                if ([[[navigationController.viewControllers lastObject] view] isKindOfClass:[UIScrollView class]]) {
                    UIScrollView *scrollView = (UIScrollView*)[[navigationController.viewControllers lastObject] view];
                    [scrollView setContentOffsetY:-scrollView.contentInsetTop animated:YES];
                }
            }
            // otherwise we just pop the navigation controller to its root
            else
            {
                [(UINavigationController*)self.selectedViewController popToRootViewControllerAnimated:YES];
            }
        }
        // if we can then we will scroll the selected controller to the top
        else if ([self.selectedViewController.view isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *scrollView = (UIScrollView*)self.selectedViewController.view;
            [scrollView setContentOffsetY:scrollView.contentInsetTop animated:YES];
        }
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
        [UIView animateWithDuration:(0.35f * animated) animations:^{
            self.tabBar.right = 0.0f;
        } asapCompletion:^(BOOL finished) {
            self.tabBar.hidden = YES;
        }];
    }
    else if (! viewController.hidesBottomBarWhenPushed && self.tabBar.hidden)
    {
        self.tabBar.hidden = NO;
        [UIView animateWithDuration:(0.35f * animated) animations:^{
            self.tabBar.left = 0.0f;
        } asapCompletion:^(BOOL finished) {
            self.selectedViewController.view.height = self.view.height - self.tabBar.height;
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

@implementation UIViewController (OPTabBarController)

-(OPTabBarController*) tabController {
    
    // walk up the parent tree to find the first tab controller
    UIViewController *c = self;
    while (c) {
        if ([c isKindOfClass:[OPTabBarController class]])
            return (OPTabBarController*)c;
        c = [c parentViewController] ?: [c presentingViewController];
    }
    return nil;
}

@end
