//
//  OPViewControllerContextTransitioningOverlay.h
//  Kickstarter
//
//  Created by Brandon Williams on 4/4/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "OPViewControllerContextTransitioningBase.h"

@interface OPViewControllerContextTransitioningOverlay : OPViewControllerContextTransitioningBase <UIViewControllerTransitioningDelegate>

@end

@interface UIViewController (OPViewControllerContextTransitioningOverlay)

-(void) presentOverlayViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

@end