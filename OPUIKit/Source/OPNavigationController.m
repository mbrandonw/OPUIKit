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
#import "OPGradientView.h"
#import "UIView+Opetopic.h"
#import "OPBarButtonItem.h"
#import "OPMacros.h"

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
	
    // traverse the subclasses to find the NIB that contains this controller
	OPNavigationController *controller = nil;
    Class controllerClass = [self class];
    while (controller == nil && controllerClass != nil)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:NSStringFromClass(controllerClass) ofType:@"nib"]])
            controller = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(controllerClass) owner:self options:nil] lastObject];
        
        controllerClass = [controllerClass superclass];
    }
    
    if (rootViewController)
        controller.viewControllers = [NSArray arrayWithObject:rootViewController];
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
    DLog(@"");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark -
#pragma mark View lifecycle
#pragma mark -

-(void) viewDidLoad {
    [super viewDidLoad];
    [self configurePopRecognizer];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
#pragma mark UINavigationControllerDelegate methods
#pragma mark -

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if([navigationController.viewControllers count] > 1 && 
       ! viewController.navigationItem.hidesBackButton && 
       ! viewController.navigationItem.leftBarButtonItem)
	{
        UIViewController *lastController = [navigationController.viewControllers objectAtIndex:[navigationController.viewControllers indexOfObject:viewController]-1];
        
        if ([OPBarButtonItem hasDefaultBackBackgroundImage])
        {
            viewController.navigationItem.leftBarButtonItem = [OPBarButtonItem defaultBackButtonWithTitle:(lastController.title ? lastController.title : @"Back") 
                                                                                                   target:self
                                                                                                   action:@selector(dismissModalViewControllerWithAnimation)];
        }
        else
        {
            viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:(lastController.title ? lastController.title : @"Back")
                                                                                               style:UIBarButtonItemStylePlain
                                                                                              target:self 
                                                                                              action:@selector(popViewControllerWithAnimation)];
        }
    }
}

-(void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

@end
