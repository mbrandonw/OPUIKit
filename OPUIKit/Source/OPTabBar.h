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
    OPTabBarStyleFlat = 0,
    OPTabBarStyleGradient,
    OPTabBarStyleGloss,
    OPTabBarStyleCustom,
    OPTabBarStyleDefault = OPTabBarStyleGradient,
} OPTabBarStyle;

typedef enum {
    OPTabBarItemDistributionEvenlySpaced = 0,
    OPTabBarItemDistributionCenterGrouped,
    OPTabBarItemDistributionDefault = OPTabBarItemDistributionCenterGrouped,
} OPTabBarItemDistribution;

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
@property (nonatomic, assign) OPTabBarStyle style;
@property (nonatomic, assign) CGFloat shadowHeight;
-(void) setShadowAlphaStops:(NSArray*)stops;

/**
 Managing tab bar items.
 */
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, assign) NSUInteger selectedItem;
@property (nonatomic, assign) OPTabBarItemDistribution itemDistribution;
-(void) setItemDistribution:(OPTabBarItemDistribution)itemDistribution animated:(BOOL)animated;

@end
