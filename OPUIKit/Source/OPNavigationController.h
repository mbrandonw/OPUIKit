//
//  OPNavigationController.h
//  OPUIKit
//
//  Created by Brandon Williams on 5/29/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPNavigationController : UINavigationController <UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL showNavigationBarShadow;
@property (nonatomic, assign) CGFloat shadowHeight;
@property (nonatomic, strong) NSArray *shadowAlphaStops;
@property (nonatomic, assign) BOOL allowSwipeToPopController;

// initialization methods (don't use any of the alloc+init methods)
+(id) controller;
+(id) controllerWithRootViewController:(UIViewController*)rootViewController;

// global customization methods
+(void) setDefaultShowNavigationBarShadow:(BOOL)show;
+(void) setDefaultShadowHeight:(CGFloat)height;
+(void) setDefaultShadowAlphaStops:(NSArray*)stops;
+(void) setDefaultSwipeToPopController:(BOOL)swipeToPop;

@end
