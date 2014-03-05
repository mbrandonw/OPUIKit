//
//  OPViewControllerContextTransitioningBase.m
//  Kickstarter
//
//  Created by Brandon Williams on 3/5/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "OPViewControllerContextTransitioningBase.h"
#import "OPViewController.h"

#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation UIView (OPViewControllerContextTransitioningBase)
@end
@implementation UIViewController (OPViewControllerContextTransitioningBase)
@end

@interface OPViewControllerContextTransitioningBase (/**/)
@property (nonatomic, weak) UIViewController *from;
@property (nonatomic, weak) UIViewController *to;
@end

@implementation OPViewControllerContextTransitioningBase

-(NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.0;
}

-(void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  self.from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  self.to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

  if ([self.from respondsToSelector:@selector(presentationAnimationStart:)]) {
    [self.from presentationAnimationStart:NO];
  }
  if ([self.from.view respondsToSelector:@selector(presentationAnimationStart:)]) {
    [self.from.view presentationAnimationStart:NO];
  }
  if ([self.to respondsToSelector:@selector(presentationAnimationStart:)]) {
    [self.to presentationAnimationStart:YES];
  }
  if ([self.to.view respondsToSelector:@selector(presentationAnimationStart:)]) {
    [self.to.view presentationAnimationStart:YES];
  }
}

-(void) animationEnded:(BOOL)transitionCompleted {
  if ([self.from respondsToSelector:@selector(presentationAnimationEnded:)]) {
    [self.from presentationAnimationEnded:NO];
  }
  if ([self.from.view respondsToSelector:@selector(presentationAnimationEnded:)]) {
    [self.from.view presentationAnimationEnded:NO];
  }
  if ([self.to respondsToSelector:@selector(presentationAnimationEnded:)]) {
    [self.to presentationAnimationEnded:YES];
  }
  if ([self.to.view respondsToSelector:@selector(presentationAnimationEnded:)]) {
    [self.to.view presentationAnimationEnded:YES];
  }
}

@end
