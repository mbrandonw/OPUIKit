//
//  OPTabBar.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/13/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPView.h"
#import "OPStyle.h"

typedef enum {
    OPTabBarItemLayoutEvenlySpaced = 0,
    OPTabBarItemLayoutCenterGrouped,
    OPTabBarItemLayoutDefault = OPTabBarItemLayoutCenterGrouped,
} OPTabBarItemLayout;

@class OPTabBar;
@class OPTabBarItem;

@protocol OPTabBarDelegate <NSObject>
-(void) tabBar:(OPTabBar*)tabBar didSelectItem:(OPTabBarItem*)item atIndex:(NSUInteger)index;
@end

@interface OPTabBar : OPView <OPStyleProtocol>

@property (nonatomic, assign) id<OPTabBarDelegate> delegate;

/**
 Managing tab bar items.
 */
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, assign) OPTabBarItem *selectedItem;
@property (nonatomic, assign) NSUInteger selectedItemIndex;
@property (nonatomic, assign) OPTabBarItemLayout itemLayout;
@property (nonatomic, assign) CGFloat maxItemWidth; // application only when itemLayout == OPTabBarItemLayoutCenterGrouped

@end
