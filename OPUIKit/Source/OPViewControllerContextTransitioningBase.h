//
//  OPViewControllerContextTransitioningBase.h
//  OPUIKit
//
//  Created by Brandon Williams on 3/5/14.
//  Copyright (c) 2014 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (OPViewControllerContextTransitioningBase)
-(void) presentationAnimationStart:(BOOL)isDestination;
-(void) presentationAnimationEnded:(BOOL)isDestination;
@end

@interface UIViewController (OPViewControllerContextTransitioningBase)
-(void) presentationAnimationStart:(BOOL)isDestination;
-(void) presentationAnimationEnded:(BOOL)isDestination;
@end

@interface OPViewControllerContextTransitioningBase : NSObject <UIViewControllerAnimatedTransitioning>
@end
