//
//  OPViewControllerContextTransitioningOverlay.m
//  Kickstarter
//
//  Created by Brandon Williams on 4/4/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "OPViewControllerContextTransitioningOverlay.h"

@implementation OPViewControllerContextTransitioningOverlay

-(void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  [super animateTransition:transitionContext];

  [transitionContext.containerView addSubview:self.from.view];
  [transitionContext.containerView addSubview:self.to.view];

  // this hacky piece is necessary in order for transitions to work
  // in portrait and landscape.
  self.to.view.frame = transitionContext.containerView.bounds;
  self.from.view.frame = transitionContext.containerView.bounds;

  if (self.presenting) {
    self.to.view.alpha = 0.0f;
  } else {
    self.from.view.alpha = 1.0f;
  }

  [UIView animateWithDuration:[self transitionDuration:transitionContext] * ([transitionContext isAnimated] ? 1.0 : 0.0) animations:^{
    if (self.presenting) {
      self.to.view.alpha = 1.0f;
    } else {
      self.from.view.alpha = 0.0f;
    }
  } completion:^(BOOL finished) {
    [transitionContext completeTransition:YES];
  }];
}

@end
