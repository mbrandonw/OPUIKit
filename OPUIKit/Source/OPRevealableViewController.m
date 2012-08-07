//
//  OPRevealableViewController.m
//  Kickstarter
//
//  Created by Brandon Williams on 8/7/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import "OPRevealableViewController.h"
#import "UIView+Opetopic.h"

@interface OPRevealableViewController ()

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
    
    if (! detailHidden && ! self.detailViewController.view.superview)
    {
        [self.view insertSubview:self.detailViewController.view belowSubview:self.masterViewController.view];
        self.detailViewController.view.frame = self.view.bounds;
    }
    
    [UIView animateWithDuration:0.3f * animated animations:^{
        self.masterViewController.view.right = self.view.width - (_detailHidden ? 0.0f : self.detailWidth);
    } completion:^(BOOL finished) {
        
        if (! _detailHidden)
        {
            [self.masterViewController.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(masterTapped:)]];
        }
    }];
}

-(void) setMasterViewController:(UIViewController *)masterViewController {
    [_masterViewController removeFromParentViewController];
    [_masterViewController.view removeFromSuperview];
    
    _masterViewController = masterViewController;
    
    [self addChildViewController:_masterViewController];
    [self.view addSubview:_masterViewController.view];
    _masterViewController.view.frame = self.view.bounds;
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
    [self.masterViewController.view removeGestureRecognizer:recognizer];
    [self setDetailHidden:YES animated:YES];
}

@end

@implementation UIViewController (OPRevealableViewController)

-(OPRevealableViewController*) revealableViewController {
    UIViewController *parent = self.parentViewController;
    while (! [parent isKindOfClass:[OPRevealableViewController class]])
        parent = parent.parentViewController;
    return (OPRevealableViewController*)parent;
}

@end