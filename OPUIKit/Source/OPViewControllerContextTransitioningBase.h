//
//  OPViewControllerContextTransitioningBase.h
//  OPUIKit
//
//  Created by Brandon Williams on 3/5/14.
//  Copyright (c) 2014 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (OPViewControllerContextTransitioningBase)
-(void) presentationAnimationStart:(BOOL)isDestinationController;
-(void) presentationAnimationEnded:(BOOL)isDestinationController;
@end

@interface UIViewController (OPViewControllerContextTransitioningBase)
-(void) presentationAnimationStart:(BOOL)isDestinationController;
-(void) presentationAnimationEnded:(BOOL)isDestinationController;
@end

@interface OPViewControllerContextTransitioningBase : NSObject <UIViewControllerAnimatedTransitioning>
@end
