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

@interface OPRevealableViewController ()
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation OPRevealableViewController

@synthesize detailHidden = _detailHidden;

-(id) init {
    if (! (self = [super init]))
        return nil;
    
    _detailHidden = YES;
    [[[self class] styling] applyTo:self];
    
    return self;
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
    _detailHidden = detailHidden;
    dispatch_next_runloop(^{
        
        if (! detailHidden && ! self.detailViewController.view.superview)
        {
            [self.view insertSubview:self.detailViewController.view belowSubview:self.masterViewController.view];
            self.detailViewController.view.frame = self.view.bounds;
            self.detailViewController.view.width = self.detailWidth;
            self.detailViewController.view.right = self.view.width;
        }
        if (detailHidden)
        {
            [self.masterViewController.view removeGestureRecognizer:self.tapGestureRecognizer];
            self.tapGestureRecognizer = nil;
        }
        
        [UIView animateWithDuration:0.3f * animated animations:^{
            self.masterViewController.view.right = self.view.width - (_detailHidden ? 0.0f : self.detailWidth);
        } completion:^(BOOL finished) {
            
            if (! _detailHidden)
            {
                self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(masterTapped:)];
                [self.masterViewController.view addGestureRecognizer:self.tapGestureRecognizer];
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

#pragma mark -
#pragma mark Interface actions
#pragma mark -

-(void) masterTapped:(UITapGestureRecognizer*)recognizer {
    [self.masterViewController.view removeGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer = nil;
    [self setDetailHidden:YES animated:YES];
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