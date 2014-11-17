//
//  OPViewControllerContextTransitioningOverlay.m
//  Kickstarter
//
//  Created by Brandon Williams on 4/4/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "OPViewControllerContextTransitioningOverlay.h"
@import ObjectiveC;

@implementation OPViewControllerContextTransitioningOverlay

-(NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

-(void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  [super animateTransition:transitionContext];

  if (self.presenting) {
    // hacky hack for ios 7 compatibility
    if (UIDevice.currentDevice.systemVersion.floatValue < 8.0f) {
      [transitionContext.containerView addSubview:self.from.view];
    }
    [transitionContext.containerView addSubview:self.to.view];
  } else {
      if (UIDevice.currentDevice.systemVersion.floatValue < 8.0f) {
        [transitionContext.containerView addSubview:self.to.view];
        [transitionContext.containerView addSubview:self.from.view];
      }
  }

  // this hacky piece is necessary in order for transitions to work
  // in portrait and landscape.
  self.to.view.frame = transitionContext.containerView.bounds;
  self.from.view.frame = transitionContext.containerView.bounds;

  if (self.presenting) {
    self.to.view.alpha = 0.0f;
  }

  [UIView animateWithDuration:[self transitionDuration:transitionContext] * [transitionContext isAnimated] animations:^{
    if (self.presenting) {
      self.to.view.alpha = 1.0f;
    } else {
      self.from.view.alpha = 0.0f;
    }
  } completion:^(BOOL finished) {
    [transitionContext completeTransition:YES];
  }];
}

#pragma mark - UIViewControllerTransitioningDelegate methods

-(id<UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  return self;
}

-(id<UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController:(UIViewController *)dismissed {
  return self;
}

@end

@implementation UIViewController (OPViewControllerContextTransitioningOverlay)

-(void) presentOverlayViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {

  OPViewControllerContextTransitioningOverlay *animator = OPViewControllerContextTransitioningOverlay.new;
  viewControllerToPresent.transitioningDelegate = animator;
  viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
  viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = YES;

  objc_setAssociatedObject(viewControllerToPresent,
                           @selector(presentOverlayViewController:animated:completion:),
                           animator,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);

  [self presentViewController:viewControllerToPresent animated:flag completion:completion];

}

@end