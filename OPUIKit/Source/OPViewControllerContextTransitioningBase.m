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
@property (nonatomic, weak, readwrite) UIViewController *from;
@property (nonatomic, weak, readwrite) UIViewController *to;
@property (nonatomic, weak, readwrite) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation OPViewControllerContextTransitioningBase

-(NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return self.transitionDuration;
}

-(void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  self.transitionContext = transitionContext;
  self.from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  self.to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

  [self.from traverseSelfAndChildrenControllers:^(UIViewController *child) {
    if ([child respondsToSelector:@selector(presentationAnimationStart:duration:)]) {
      [child presentationAnimationStart:NO duration:[self transitionDuration:transitionContext]];
    }
  }];

  [self.from.view traverseSelfAndSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(presentationAnimationStart:duration:)]) {
      [subview presentationAnimationStart:NO duration:[self transitionDuration:transitionContext]];
    }
  }];

  [self.to traverseSelfAndChildrenControllers:^(UIViewController *child) {
    if ([child respondsToSelector:@selector(presentationAnimationStart:duration:)]) {
      [child presentationAnimationStart:YES duration:[self transitionDuration:transitionContext]];
    }
  }];

  [self.to.view traverseSelfAndSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(presentationAnimationStart:duration:)]) {
      [subview presentationAnimationStart:YES duration:[self transitionDuration:transitionContext]];
    }
  }];
}

-(void) animationEnded:(BOOL)transitionCompleted {

  [self.from traverseSelfAndChildrenControllers:^(UIViewController *child) {
    if ([child respondsToSelector:@selector(presentationAnimationEnded:duration:)]) {
      [child presentationAnimationEnded:NO duration:[self transitionDuration:nil]];
    }
  }];

  [self.from.view traverseSelfAndSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(presentationAnimationEnded:duration:)]) {
      [subview presentationAnimationEnded:NO duration:[self transitionDuration:nil]];
    }
  }];

  [self.to traverseSelfAndChildrenControllers:^(UIViewController *child) {
    if ([child respondsToSelector:@selector(presentationAnimationEnded:duration:)]) {
      [child presentationAnimationEnded:YES duration:[self transitionDuration:nil]];
    }
  }];

  [self.to.view traverseSelfAndSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(presentationAnimationEnded:duration:)]) {
      [subview presentationAnimationEnded:YES duration:[self transitionDuration:nil]];
    }
  }];
}

@end
