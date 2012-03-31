//
//  OPCoveredMenuNavigationController.m
//  Kickstarter
//
//  Created by Brandon Williams on 3/30/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import "OPCoveredMenuNavigationController.h"
#import "OPExtensionKit.h"

@interface OPCoveredMenuNavigationController ()

@end

@implementation OPCoveredMenuNavigationController

@synthesize coveredViewController = _coveredViewController;
@synthesize coveredViewControllerHidden = _coveredViewControllerHidden;

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (! (self = [super initWithCoder:aDecoder]))
        return nil;
    
    _coveredViewControllerHidden = YES;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) setCoveredViewControllerHidden:(BOOL)hidden {
    [self setCoveredViewControllerHidden:hidden animated:NO];
}

-(void) setCoveredViewControllerHidden:(BOOL)hidden animated:(BOOL)animated {
    _coveredViewControllerHidden = hidden;
    
    if (hidden)
    {
//        for (UIView *view in self.view.subviews)
//            if (! [view isKindOfClass:[UINavigationBar class]])
//                view.userInteractionEnabled = YES;
    }
    else
    {
//        for (UIView *view in self.view.subviews)
//            if (! [view isKindOfClass:[UINavigationBar class]])
//                view.userInteractionEnabled = NO;
//        
//        [self addChildViewController:self.coveredViewController];
//        self.coveredViewController.view.frame = self.view.bounds;
//        [self.view insertSubview:self.coveredViewController.view atIndex:0];
    }
    
    [UIView animateWithDuration:0.3f*animated animations:^{
        
        if (hidden)
        {
//            UIView *lastView = [[self.childViewControllers secondToLastObject] view];
//            lastView.top = 0.0f;
        }
        else
        {
            UIView *lastView = [[self.childViewControllers secondToLastObject] view];
            lastView.top = lastView.superview.height;
        }
        
    } completion:^(BOOL finished) {
        
        if (hidden)
        {
//            [[self.childViewControllers lastObject] removeFromParentViewController];
//            [self.coveredViewController.view removeFromSuperview];
            
//            [[self.childViewControllers lastObject] view].hidden = NO;
            
            [self popViewControllerAnimated:NO];
        }
        else
        {
            [self pushViewController:self.coveredViewController animated:NO];
        }
    }];
}

@end
