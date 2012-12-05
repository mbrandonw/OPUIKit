//
//  OPNavigationBar.h
//  OPUIKit
//
//  Created by Brandon Williams on 12/19/10.
//  Copyright 2010 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPStyle.h"

@interface OPNavigationBar : UINavigationBar <OPStyleProtocol>

@property (nonatomic, assign) BOOL shadowHidden;
-(void) setShadowHidden:(BOOL)hidden animated:(BOOL)animated;

@property (nonatomic, strong, readonly) UIView *visibleStatusView;

-(void) showStatusView:(UIView*)statusView;
-(void) showStatusView:(UIView*)statusView hideAfter:(NSTimeInterval)hideAfter;
-(void) showStatusView:(UIView*)statusView hideAfter:(NSTimeInterval)hideAfter completion:(void(^)(void))completion;
-(void) hideStatusView;
-(void) hideStatusView:(void(^)(void))completion;

@end
