//
//  OPViewControllerContextTransitioningBase.h
//  OPUIKit
//
//  Created by Brandon Williams on 3/5/14.
//  Copyright (c) 2014 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (OPViewControllerContextTransitioningBase)
-(void) presentationAnimationContext:(id<UIViewControllerAnimatedTransitioning>)context started:(BOOL)isDestination duration:(NSTimeInterval)duration;
-(void) presentationAnimationContext:(id<UIViewControllerAnimatedTransitioning>)context ended:(BOOL)isDestination duration:(NSTimeInterval)duration;
@end

@interface UIViewController (OPViewControllerContextTransitioningBase)
-(void) presentationAnimationContext:(id<UIViewControllerAnimatedTransitioning>)context started:(BOOL)isDestination duration:(NSTimeInterval)duration;
-(void) presentationAnimationContext:(id<UIViewControllerAnimatedTransitioning>)context ended:(BOOL)isDestination duration:(NSTimeInterval)duration;
@end

@interface OPViewControllerContextTransitioningBase : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, weak, readonly) UIViewController *from;
@property (nonatomic, weak, readonly) UIViewController *to;
@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
@property (nonatomic, assign) NSTimeInterval transitionDuration;
@property (nonatomic, weak, readonly) id<UIViewControllerContextTransitioning> transitionContext;
@end
