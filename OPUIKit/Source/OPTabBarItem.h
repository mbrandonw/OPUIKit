//
//  OPTabBarItem.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/13/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPStyle.h"
#import "OPControl.h"

@class OPTabBarItemBadge;

@interface OPTabBarItem : OPControl <OPStyleProtocol>

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, assign) UIEdgeInsets iconViewInsets;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, assign) UIEdgeInsets titleLabelInsets;

@property (nonatomic, strong, readonly) OPTabBarItemBadge *badge;
@property (nonatomic, assign) BOOL rememberBadgeValue;

-(id) initWithTitle:(NSString*)title;

@end
