//
//  OPTabBar.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/13/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPView.h"

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

@interface OPTabBar : OPView

@property (nonatomic, assign) id<OPTabBarDelegate> delegate;

/**
 Styling methods
 */
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) CGFloat glossAmount;      // % alpha to apply to the top half of the tab bar for the gloss effect
@property (nonatomic, assign) CGFloat glossOffset;      // how many pixels from the center to offset the gloss
@property (nonatomic, assign) CGFloat gradientAmount;   // a number between 0 and 1 that determines how much to lighten/darken the background color for the gradient
@property (nonatomic, assign) CGFloat shadowHeight;
-(void) setShadowAlphaStops:(NSArray*)stops;

/**
 Managing tab bar items.
 */
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, assign) OPTabBarItem *selectedItem;
@property (nonatomic, assign) NSUInteger selectedItemIndex;
@property (nonatomic, assign) OPTabBarItemLayout itemLayout;
@property (nonatomic, assign) CGFloat maxItemWidth; // application only when itemLayout == OPTabBarItemLayoutCenterGrouped

@end
