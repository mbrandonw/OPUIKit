//
//  UIViewController+OPUIKit.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/16/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (OPUIKit)

-(id) initWithTitle:(NSString*)title subtitle:(NSString*)subtitle;
-(void) setTitle:(NSString*)title subtitle:(NSString*)subtitle;

-(void) setToolbarView:(UIView*)toolbarView;
-(UIView*) toolbarView;

-(BOOL) toolbarViewHidden;
-(void) setToolbarViewHidden:(BOOL)hidden;
-(void) setToolbarViewHidden:(BOOL)hidden animated:(BOOL)animated;

-(void) layoutToolbarView;

-(BOOL) walkViewControllerHierarchy:(void(^)(UIViewController *controller, BOOL *stop))block;

@end
