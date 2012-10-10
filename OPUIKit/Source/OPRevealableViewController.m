//
//  OPRevealableViewController.m
//  Kickstarter
//
//  Created by Brandon Williams on 8/7/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import "OPRevealableViewController.h"
#import "UIView+Opetopic.h"
#import "GCD+Opetopic.h"
#import "UIDevice+Opetopic.h"

@interface OPRevealableViewController ()
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIView *gripView;

// Private method for closing/opening the detail a little faster. Velocity should be
// how fast the user's finger was moving when they were dragging the master panel.
-(void) setDetailHidden:(BOOL)detailHidden animated:(BOOL)animated velocity:(CGFloat)velocity;
@end

@implementation OPRevealableViewController

@synthesize detailHidden = _detailHidden;

-(id) init {
    if (! (self = [super init]))
        return nil;
    
    _detailHidden = YES;
    [[[self class] styling] applyTo:self];
    
    self.gripView = [UIView new];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(masterTapped:)];
    [self.gripView addGestureRecognizer:self.tapGestureRecognizer];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(masterPanned:)];
    [self.gripView addGestureRecognizer:self.panGestureRecognizer];
    
    return self;
}

-(void) dealloc {
    _masterViewController = nil;
    _detailViewController = nil;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    if (self.detailWidth == 0.0f)
        self.detailWidth = self.view.width - 80.0f;
}

-(void) setDetailHidden:(BOOL)detailHidden {
    [self setDetailHidden:detailHidden animated:NO];
}

-(void) setDetailHidden:(BOOL)detailHidden animated:(BOOL)animated {
    [self setDetailHidden:detailHidden animated:animated velocity:0.0f];
}

-(void) setDetailHidden:(BOOL)detailHidden animated:(BOOL)animated velocity:(CGFloat)velocity {
    _detailHidden = detailHidden;
    dispatch_next_runloop(^{
        
        BOOL shouldCallAppearMethodsOnDetail = YES;
        
        if (! detailHidden && ! self.detailViewController.view.superview)
        {
            shouldCallAppearMethodsOnDetail = ! [UIDevice isAtLeastiOS5];
            
            [self.view insertSubview:self.detailViewController.view belowSubview:self.masterViewController.view];
            self.detailViewController.view.frame = self.view.bounds;
            self.detailViewController.view.width = self.detailWidth;
            self.detailViewController.view.right = self.view.width;
        }
        if (detailHidden)
        {
            [self.masterViewController.view removeGestureRecognizer:self.tapGestureRecognizer];
            self.tapGestureRecognizer = nil;
            [self.masterViewController.view removeGestureRecognizer:self.panGestureRecognizer];
            self.panGestureRecognizer = nil;
            
            [self.masterViewController viewWillAppear:animated];
            [self.detailViewController viewWillDisappear:animated];
        }
        else
        {
            [self.masterViewController viewWillDisappear:animated];
            if (shouldCallAppearMethodsOnDetail)
                [self.detailViewController viewWillAppear:animated];
        }
        
        self.dividerView.alpha = detailHidden ? 1.0f : 0.0f;
        self.dividerView.origin = CGPointMake(roundf(self.masterViewController.view.right - self.dividerView.width/2.0f), 0.0f);
        self.dividerView.height = self.masterViewController.view.height;
        [self.view addSubview:self.dividerView];
        [_dividerView setNeedsDisplay];
        
        [self.view addSubview:self.gripView];
        self.gripView.frame = self.masterViewController.view.frame;
        
        [UIView animateWithDuration:MAX(0.0f, 0.3f - ABS(velocity)/10000.0f) * animated animations:^{
            CGFloat right = self.view.width - (_detailHidden ? 0.0f : self.detailWidth + self.dividerWidth);
            self.masterViewController.view.right = right;
            self.dividerView.alpha = detailHidden ? 0.0f : 1.0f;
            self.dividerView.origin = CGPointMake(roundf(right - self.dividerView.width/2.0f), 0.0f);
            self.gripView.frame = self.masterViewController.view.frame;
        } completion:^(BOOL finished) {
            
            if (detailHidden)
            {
                [self.masterViewController viewDidAppear:animated];
                [self.detailViewController viewDidDisappear:animated];
                [self.gripView removeFromSuperview];
            }
            else
            {
                [self.masterViewController viewDidDisappear:animated];
                if (shouldCallAppearMethodsOnDetail)
                    [self.detailViewController viewDidAppear:animated];
            }
        }];
        
    });
}

-(void) setMasterViewController:(UIViewController *)masterViewController {
    CGRect frame = _masterViewController.view.frame;
    [_masterViewController removeFromParentViewController];
    [_masterViewController.view removeFromSuperview];
    
    _masterViewController = masterViewController;
    
    [self addChildViewController:_masterViewController];
    [self.view addSubview:_masterViewController.view];
    _masterViewController.view.frame = CGRectIsEmpty(frame) ? self.view.bounds : frame;
}

-(void) setDetailViewController:(UIViewController *)detailViewController {
    [_detailViewController removeFromParentViewController];
    [_detailViewController.view removeFromSuperview];
    
    _detailViewController = detailViewController;
    
    [self addChildViewController:_detailViewController];
}

-(void) setDividerView:(UIView *)dividerView {
    [_dividerView removeFromSuperview];
    _dividerView = dividerView;
    if ([self isViewLoaded])
        [self.view addSubview:_dividerView];
}

#pragma mark -
#pragma mark Interface actions
#pragma mark -

-(void) masterTapped:(UITapGestureRecognizer*)recognizer {
    [self.masterViewController.view removeGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer = nil;
    [self setDetailHidden:YES animated:YES];
}

-(void) masterPanned:(UIPanGestureRecognizer*)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGFloat velocity = [recognizer velocityInView:self.view].x;
        if (velocity >= 0.0f)
            [self setDetailHidden:YES animated:YES velocity:velocity];
        else
            [self setDetailHidden:NO animated:YES velocity:velocity];
    }
    
    CGPoint offset = [recognizer translationInView:self.view];
    self.masterViewController.view.left += offset.x;
    self.masterViewController.view.right = MAX(self.view.width - self.detailWidth, self.masterViewController.view.right);
    self.dividerView.left = floorf(self.masterViewController.view.right - self.dividerView.width/2.0f);
    [recognizer setTranslation:CGPointZero inView:self.view];
}

@end

@implementation UIViewController (OPRevealableViewController)

-(OPRevealableViewController*) revealableViewController {
    UIViewController *parent = self;
    while (parent && ! [parent isKindOfClass:[OPRevealableViewController class]])
        parent = parent.parentViewController;
    return (OPRevealableViewController*)parent;
}

@end