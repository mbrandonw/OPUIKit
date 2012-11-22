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

#pragma mark Private methods
@interface OPNavigationController (/**/)
@property (nonatomic, strong) UISwipeGestureRecognizer *popRecognizer;
-(void) configurePopRecognizer; // will force a loading of the view
@end
#pragma mark -

@implementation OPNavigationController

@synthesize allowSwipeToPop = _allowSwipeToPop;
@synthesize popRecognizer = _popRecognizer;

#pragma mark -
#pragma mark Object lifecycle
#pragma mark -

+(id) controller {
    return [self controllerWithRootViewController:nil];
}

+(id) controllerWithRootViewController:(UIViewController*)rootViewController {
	
	OPNavigationController *controller = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    
    if (rootViewController)
        controller.viewControllers = @[rootViewController];
	controller.delegate = controller;
    
	return controller;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (! (self = [super initWithCoder:aDecoder]))
        return nil;
    
    // apply stylings
    [[[self class] styling] applyTo:self];
    
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    DLogClassAndMethod();
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark -
#pragma mark View lifecycle
#pragma mark -

-(void) viewDidLoad {
    [super viewDidLoad];
    DLogClassAndMethod();
    [self configurePopRecognizer];
}

#pragma mark -
#pragma mark Custom getters/setters
#pragma mark -

-(void) setAllowSwipeToPop:(NSInteger)a {
    _allowSwipeToPop = a;
    
    // handle gesture recognizers only if our view is loaded (to prevent accidental loading of the view)
    if ([self isViewLoaded])
        [self configurePopRecognizer];
}

-(void) configurePopRecognizer {
    
    if (self.allowSwipeToPop)
    {
        if (! [self.view.gestureRecognizers containsObject:self.popRecognizer])
            [self.view addGestureRecognizer:self.popRecognizer];
    }
    else
    {
        [self.view removeGestureRecognizer:self.popRecognizer];
        self.popRecognizer = nil;
    }
}

-(UISwipeGestureRecognizer*) popRecognizer {
    if (! _popRecognizer && self.allowSwipeToPop)
    {
        self.popRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
        _popRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        _popRecognizer.numberOfTouchesRequired = 1;
    }
    return _popRecognizer;
}

-(void) swiped:(UISwipeGestureRecognizer*)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded)
        [self popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Overridden UINavigationController methods
#pragma mark -

-(UIViewController*) popViewControllerAnimated:(BOOL)animated {
    
    UIViewController *retVal = [super popViewControllerAnimated:animated];
    
    if ([retVal respondsToSelector:@selector(navigationController:isPoppingSelf:)])
        [(id)retVal navigationController:self isPoppingSelf:animated];
    
    return retVal;
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutToolbarView];
}

#pragma mark -
#pragma mark UINavigationControllerDelegate methods
#pragma mark -

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if([navigationController.viewControllers count] > 1 && 
       ! viewController.navigationItem.hidesBackButton && 
       ! viewController.navigationItem.leftBarButtonItem)
	{
        UIViewController *lastController = [navigationController.viewControllers objectAtIndex:[navigationController.viewControllers indexOfObject:viewController]-1];
        
        viewController.navigationItem.leftBarButtonItem = [OPBackBarButtonItem buttonWithTitle:
                                                           lastController.title ?: NSLocalizedString(@"Back", @"UIBarButtonItem default back label")
                                                                                        target:self 
                                                                                        action:@selector(popViewControllerWithAnimation)];
    }
}

-(void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

@end
