//
//  OPSidebarNavigationController.m
//  OPUIKit
//
//  Created by Brandon Williams on 11/19/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import "OPSidebarNavigationController.h"
#import "UIView+Opetopic.h"
#import "OPBarButtonItem.h"
#import <QuartzCore/QuartzCore.h>

#define HBSidebarAnimateOvershoot   10.0f
#define HBSidebarShadowWidth        10.0f
#define HBSliderbarAnimationDuration    0.3f

@interface OPSidebarNavigationController (/**/)
@property (nonatomic, strong) UIWindow *sidebarWindow;
@property (nonatomic, strong) UITapGestureRecognizer *cancelTapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *draggingRecognizer;
-(void) setupSidebarWindow;
@end

@implementation OPSidebarNavigationController {
    
    // used for the panning gesture recognizer to drag the navigation controller
    CGPoint draggingStart;
    CGPoint previousDraggingPoint;
}

#pragma mark Object lifecycle methods
-(void) awakeFromNib {
    [super awakeFromNib];
    
    // default ivars
    _visible = YES;
    _sidebarVisible = NO;
    _draggableArea = OPSidebarNavigationDraggableAreaNavBar;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - 


#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // default side bar widths to something reasonable
    if (self.minimumSidebarWidth == 0.0f)
        self.minimumSidebarWidth = MIN(320,roundf(self.view.width * 0.7f));
    
    // add the nice little shadow on the left side of this controller ... helps create some separation between the navigation controller and sidebar controller
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = CGRectMake(-HBSidebarShadowWidth, 0.0f, HBSidebarShadowWidth, self.view.height);
    gradientLayer.colors = @[(id)[UIColor colorWithWhite:0.0f alpha:0.4f].CGColor, 
                            (id)[UIColor colorWithWhite:0.0f alpha:0.1f].CGColor, 
                            (id)[UIColor colorWithWhite:0.0f alpha:0.0f].CGColor];
    gradientLayer.startPoint = CGPointMake(1.0f, 0.0f);
    gradientLayer.endPoint = CGPointZero;
    [self.view.layer addSublayer:gradientLayer];
    
    if (self.draggableArea == OPSidebarNavigationDraggableAreaNavBar)
        [self.navigationBar addGestureRecognizer:self.draggingRecognizer];
    else
        [self.view addGestureRecognizer:self.draggingRecognizer];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupSidebarWindow];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -


#pragma mark UINavigationControllerDelegate methods
-(void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super navigationController:navigationController willShowViewController:viewController animated:YES];
    
    if ([self.viewControllers count] == 1 && ! viewController.navigationItem.hidesBackButton)
    {
//        viewController.navigationItem.leftBarButtonItem = [OPBarButtonItem defaultBackButtonWithTitle:@"Menu" target:self action:@selector(menuButtonPressed)];
    }
}

-(void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super navigationController:navigationController didShowViewController:viewController animated:animated];
}
#pragma mark -


#pragma mark Custom getter/setter
-(void) setSidebarVisible:(BOOL)v animated:(BOOL)animated {
    _sidebarVisible = v;
    
    [self setupSidebarWindow];
    [self.view removeGestureRecognizer:self.cancelTapRecognizer];
    
    v ? [self.sidebarViewController viewWillAppear:animated] : [self.sidebarViewController viewWillDisappear:animated];
    
    if (self.sidebarVisible)
    {
        [self.view addGestureRecognizer:self.cancelTapRecognizer];
        
        if (animated)
        {
            [UIView animateWithDuration:HBSliderbarAnimationDuration delay:0.0f options:UIViewAnimationCurveLinear animations:^{
                
                switch (self.interfaceOrientation) {
                    case UIInterfaceOrientationLandscapeLeft:
                        self.view.window.bottom = self.view.window.height - self.minimumSidebarWidth - HBSidebarAnimateOvershoot;
                        break;
                    case UIInterfaceOrientationLandscapeRight:
                        self.view.window.top = self.minimumSidebarWidth + HBSidebarAnimateOvershoot;
                        break;
                    case UIInterfaceOrientationPortrait:
                        self.view.window.left = self.minimumSidebarWidth + HBSidebarAnimateOvershoot;
                        break;
                    case UIInterfaceOrientationPortraitUpsideDown:
                        self.view.window.right = self.view.window.width - self.minimumSidebarWidth - HBSidebarAnimateOvershoot;
                        break;
                    default:
                        break;
                }
                
            } completion:^(BOOL finished) {
                
                [self.sidebarViewController viewDidAppear:animated];
                
                [UIView animateWithDuration:HBSliderbarAnimationDuration/2.0f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
                    
                    switch (self.interfaceOrientation) {
                        case UIInterfaceOrientationLandscapeLeft:
                            self.view.window.bottom = self.view.window.height - self.minimumSidebarWidth;
                            break;
                        case UIInterfaceOrientationLandscapeRight:
                            self.view.window.top = self.minimumSidebarWidth;
                            break;
                        case UIInterfaceOrientationPortrait:
                            self.view.window.left = self.minimumSidebarWidth;
                            break;
                        case UIInterfaceOrientationPortraitUpsideDown:
                            self.view.window.right = self.view.window.width - self.minimumSidebarWidth;
                            break;
                        default:
                            break;
                    }
                    
                } completion:nil];
            }];
        }
        else {
            self.view.window.left = self.minimumSidebarWidth;
            [self.sidebarViewController viewDidAppear:animated];
        }
        
        self.sidebarViewController.view.width = self.minimumSidebarWidth;
    }
    else
    {
        if (animated)
        {
            [UIView animateWithDuration:HBSliderbarAnimationDuration delay:0.0f options:UIViewAnimationCurveLinear animations:^{
                
                self.view.window.frame = [[UIScreen mainScreen] bounds];
                
            } completion:^(BOOL finished) {
                [self.sidebarViewController viewDidDisappear:animated];
            }];
        }
        else {
            self.view.window.left = 0.0f;
            [self.sidebarViewController viewDidDisappear:animated];
        }
    }
}

-(void) setSidebarVisible:(BOOL)v {
    [self setSidebarVisible:v animated:NO];
}

-(void) setVisible:(BOOL)v animated:(BOOL)animated {
    _visible = v;
    if (! self.visible && ! self.sidebarVisible)
        self.sidebarVisible = YES;
    
    if (self.visible)
    {
        if (animated)
        {
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
                self.view.window.left = self.sidebarVisible ? self.minimumSidebarWidth - HBSidebarAnimateOvershoot : - HBSidebarAnimateOvershoot;
                self.sidebarViewController.view.width = self.minimumSidebarWidth;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
                    self.view.window.left = self.minimumSidebarWidth;
                } completion:nil];
            }];
        }
        else {
            self.view.window.left = self.sidebarVisible ? self.minimumSidebarWidth : 0.0f;
            self.sidebarViewController.view.width = self.minimumSidebarWidth;
        }
    }
    else
    {
        if (animated)
        {
            [UIView animateWithDuration:0.3f animations:^{
                self.view.window.left = self.view.window.width + HBSidebarShadowWidth;
                self.sidebarViewController.view.width = self.view.window.width;
            }];
        }
        else {
            self.view.window.left = self.view.window.width + HBSidebarShadowWidth;
            self.sidebarViewController.view.width = self.view.window.width;
        }
    }
}

-(void) setVisible:(BOOL)v {
    [self setVisible:v animated:NO];
}

-(UITapGestureRecognizer*) cancelTapRecognizer {
    if (! _cancelTapRecognizer)
    {
        self.cancelTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancellingTap:)];
        _cancelTapRecognizer.numberOfTapsRequired = 1;
        _cancelTapRecognizer.cancelsTouchesInView = YES;
    }
    return _cancelTapRecognizer;
}

-(void) cancellingTap:(UITapGestureRecognizer*)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self setSidebarVisible:NO animated:YES];
        [self.view removeGestureRecognizer:self.cancelTapRecognizer];
    }
}

-(UIPanGestureRecognizer*) draggingRecognizer {
    if (! _draggingRecognizer)
    {
        self.draggingRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panning:)];
    }
    return _draggingRecognizer;
}

-(void) panning:(UIPanGestureRecognizer*)sender {
    
    // figure out which state the gesture is in
    UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer*)sender;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            draggingStart = [panRecognizer locationInView:self.navigationBar];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            previousDraggingPoint = [panRecognizer locationInView:self.navigationBar];
            if (ABS([panRecognizer translationInView:self.navigationBar].x) > 10.0f)
                self.view.window.left = MAX(0, [panRecognizer locationInView:self.sidebarWindow].x - draggingStart.x);
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            // wait for the next runloop frame to show/hide the sidebar since animations get stalled immediately after a gesture
            CGPoint velocity = [panRecognizer velocityInView:self.navigationBar];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^(void){
                if (velocity.x > 0)
                    [self setSidebarVisible:YES animated:YES];
                else
                    [self setSidebarVisible:NO animated:YES];
            });
            break;
        }
        default:
            break;
    }
}

-(void) setDraggableArea:(OPSidebarNavigationDraggableArea)d {
    _draggableArea = d;
    
    [self.navigationBar removeGestureRecognizer:self.draggingRecognizer];
    [self.view removeGestureRecognizer:self.draggingRecognizer];
    
    if (self.draggableArea == OPSidebarNavigationDraggableAreaNavBar)
        [self.navigationBar addGestureRecognizer:self.draggingRecognizer];
    else
        [self.view addGestureRecognizer:self.draggingRecognizer];
}
#pragma mark -


#pragma mark Private methods
-(void) setupSidebarWindow {
    
    if (! self.sidebarWindow)
    {
        self.sidebarWindow = [UIWindow new];
        self.sidebarWindow.userInteractionEnabled = YES;
        self.sidebarWindow.opaque = YES;
        self.sidebarWindow.hidden = NO;
        self.sidebarWindow.windowLevel = self.view.window.windowLevel - 1.0f;
        self.sidebarWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    self.sidebarWindow.frame = [[UIScreen mainScreen] bounds];
    self.sidebarWindow.rootViewController = self.sidebarViewController;
}

-(void) menuButtonPressed {
    
    [self setSidebarVisible:! self.sidebarVisible animated:YES];
}

@end
