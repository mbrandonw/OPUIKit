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

  [self.from traverseSelfAndChildrenControllers:^(UIViewController *child) {
    if ([child respondsToSelector:@selector(presentationAnimationStart:)]) {
      [child presentationAnimationStart:NO];
    }
  }];

  [self.from.view traverseSelfAndSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(presentationAnimationStart:)]) {
      [subview presentationAnimationStart:NO];
    }
  }];

  [self.to traverseSelfAndChildrenControllers:^(UIViewController *child) {
    if ([child respondsToSelector:@selector(presentationAnimationStart:)]) {
      [child presentationAnimationStart:YES];
    }
  }];

  [self.to.view traverseSelfAndSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(presentationAnimationStart:)]) {
      [subview presentationAnimationStart:YES];
    }
  }];
}

-(void) animationEnded:(BOOL)transitionCompleted {

  [self.from traverseSelfAndChildrenControllers:^(UIViewController *child) {
    if ([child respondsToSelector:@selector(presentationAnimationEnded:)]) {
      [child presentationAnimationEnded:NO];
    }
  }];

  [self.from.view traverseSelfAndSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(presentationAnimationEnded:)]) {
      [subview presentationAnimationEnded:NO];
    }
  }];

  [self.to traverseSelfAndChildrenControllers:^(UIViewController *child) {
    if ([child respondsToSelector:@selector(presentationAnimationEnded:)]) {
      [child presentationAnimationEnded:YES];
    }
  }];

  [self.to.view traverseSelfAndSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(presentationAnimationEnded:)]) {
      [subview presentationAnimationEnded:YES];
    }
  }];
}

@end
