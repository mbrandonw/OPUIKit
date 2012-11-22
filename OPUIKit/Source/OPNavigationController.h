//
//  OPNavigationController.h
//  OPUIKit
//
//  Created by Brandon Williams on 5/29/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPStyle.h"

@protocol OPNavigationChildControllerProtocol <NSObject>
-(void) navigationController:(UINavigationController*)controller isPoppingSelf:(BOOL)animated;
@end

@interface OPNavigationController : UINavigationController <UINavigationControllerDelegate, OPStyleProtocol>

// initialization methods (don't use any of the alloc+init methods)
+(id) controller;
+(id) controllerWithRootViewController:(UIViewController*)rootViewController;

@end
