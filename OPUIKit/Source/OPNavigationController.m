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

#if !defined(OP_NAVIGATION_CONTROLLER_SIMULATE_MEMORY_WARNINGS)
#define OP_NAVIGATION_CONTROLLER_SIMULATE_MEMORY_WARNINGS   NO
#endif

#pragma mark Styling vars
static BOOL OPNavigationControllerDefaultShowNavigationBarShadow;
static CGFloat OPNavigationControllerDefaultShadowHeight;
static NSArray *OPNavigationControllerDefaultShadowAlphaStops;
static BOOL OPNavigationControllerDefaultSwipeToPopController;
#pragma mark -

#pragma mark Private methods
@interface OPNavigationController (/**/)
@property (nonatomic, retain) OPGradientView *navigationBarShadowView;
@property (nonatomic, retain) UISwipeGestureRecognizer *popRecognizer;
-(void) setupNavigationBarShadow;
@end
#pragma mark -

@implementation OPNavigationController

@synthesize showNavigationBarShadow;
@synthesize shadowHeight;
@synthesize shadowAlphaStops;
@synthesize allowSwipeToPopController;
@synthesize navigationBarShadowView;
@synthesize popRecognizer;

#pragma mark Initialization methods
+(void) initialize {
    if (self == [OPNavigationController class])
    {
        OPNavigationControllerDefaultShadowHeight = 4.0f;
        OPNavigationControllerDefaultShadowAlphaStops = [NSArray arrayWithObjects:
                                                         [NSNumber numberWithFloat:0.4f],
                                                         [NSNumber numberWithFloat:0.1f],
                                                         [NSNumber numberWithFloat:0.0f], nil];
    }
}

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
        {
            controller = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(controllerClass) owner:self options:nil] lastObject];
        }
        controllerClass = [controllerClass superclass];
    }
    
    if (rootViewController)
        controller.viewControllers = [NSArray arrayWithObject:rootViewController];
	controller.delegate = controller;
    
	return controller;
}
#pragma mark -


#pragma mark Styling methods
+(void) setDefaultShowNavigationBarShadow:(BOOL)show {
    OPNavigationControllerDefaultShowNavigationBarShadow = show;
}

+(void) setDefaultSwipeToPopController:(BOOL)swipeToPop {
    OPNavigationControllerDefaultSwipeToPopController = swipeToPop;
}

+(void) setDefaultShadowHeight:(CGFloat)height {
    
    OPNavigationControllerDefaultShadowHeight = height;
}

+(void) setDefaultShadowAlphaStops:(NSArray*)stops {
    
    OPNavigationControllerDefaultShadowAlphaStops = [stops copy];
}
#pragma mark -


#pragma mark Object lifecycle
-(id) initWithCoder:(NSCoder *)aDecoder {
    if (! (self = [super initWithCoder:aDecoder]))
        return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameWillChange:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
    showNavigationBarShadow     = OPNavigationControllerDefaultShowNavigationBarShadow;
    shadowHeight                = OPNavigationControllerDefaultShadowHeight;
    shadowAlphaStops            = OPNavigationControllerDefaultShadowAlphaStops;
    allowSwipeToPopController   = OPNavigationControllerDefaultSwipeToPopController;
    
    return self;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    DLog(@"");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
#pragma mark -


#pragma mark View lifecycle
-(void) viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarShadow];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (OP_NAVIGATION_CONTROLLER_SIMULATE_MEMORY_WARNINGS)
        [self simulateMemoryWarning];
    
    DLog(@"%@", OPCoalesce(self.title, NSStringFromClass([self class])));
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UI_RESTRICTIVE_INTERFACE_ORIENTATIONS(interfaceOrientation);
}
#pragma mark -


#pragma mark Custom getters/setters
-(void) setShowNavigationBarShadow:(BOOL)s {
    showNavigationBarShadow = s;
    [self setupNavigationBarShadow];
}

-(void) setAllowSwipeToPopController:(BOOL)a {
    allowSwipeToPopController = a;
    
    if (allowSwipeToPopController)
    {
        [self.view addGestureRecognizer:self.popRecognizer];
    }
    else
    {
        [self.view removeGestureRecognizer:self.popRecognizer];
        self.popRecognizer = nil;
    }
}

-(UISwipeGestureRecognizer*) popRecognizer {
    if (! popRecognizer)
    {
        self.popRecognizer = [UISwipeGestureRecognizer recognizerWithHandler:^(UIGestureRecognizer *r, UIGestureRecognizerState s, CGPoint p) {
            [self popViewControllerAnimated:YES];
        }];
        popRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    }
    return popRecognizer;
}
#pragma mark -


#pragma mark Private methods
-(void) setupNavigationBarShadow {
    
    [self.navigationBarShadowView removeFromSuperview];
    self.navigationBarShadowView = nil;
    
    if (self.showNavigationBarShadow)
    {
        self.navigationBarShadowView = [[OPGradientView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBar.bottom, self.navigationBar.width, self.shadowHeight)];
        self.navigationBarShadowView.opaque = NO;
        self.navigationBarShadowView.backgroundColor = [UIColor clearColor];
        self.navigationBarShadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.navigationBarShadowView.gradientLayer.colors = [self.shadowAlphaStops map:^id(id obj) {
            return (id)[UIColor colorWithWhite:0.0f alpha:[obj floatValue]].CGColor;
        }];
        
        if ([self isViewLoaded])
            [self.view addSubview:self.navigationBarShadowView];
    }
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.navigationBarShadowView.top = self.navigationBar.bottom;
}

-(void) statusBarFrameWillChange:(NSNotification*)notification {
}
#pragma mark -


#pragma mark UINavigationControllerDelegate methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if([navigationController.viewControllers count] > 1 && 
       ! viewController.navigationItem.hidesBackButton && 
       ! viewController.navigationItem.leftBarButtonItem)
	{
        UIViewController *lastController = [navigationController.viewControllers objectAtIndex:[navigationController.viewControllers indexOfObject:viewController]-1];
        
        if ([OPBarButtonItem hasDefaultBackBackgroundImage])
        {
            __block id blockSelf = self;
            viewController.navigationItem.leftBarButtonItem = [OPBarButtonItem 
                                                               defaultBackButtonWithTitle:(lastController.title ? lastController.title : @"Back")
                                                               handler:^(id sender) {
                                                                   [blockSelf dismissModalViewControllerAnimated:YES];
                                                               }];
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
#pragma mark -

@end
