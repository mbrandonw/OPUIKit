//
//  OPTabBarItemBadge.h
//  Kickstarter
//
//  Created by Brandon Williams on 1/19/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPView.h"
#import "OPStyleProtocol.h"
#import "OPUIKitBlockDefinitions.h"

@interface OPTabBarItemBadge : OPView <OPStyleProtocol>

@property (nonatomic, strong, readonly) UILabel *valueLabel; // don't set .text directly on this, use the -setValue: method
@property (nonatomic, assign) UIEdgeInsets valueLabelInsets;
@property (nonatomic, assign) CGSize minSize;
@property (nonatomic, assign) CGPoint relativeCenter;
@property (nonatomic, assign) BOOL coalesceZeroToNil;

-(void) setValue:(NSString*)value;
-(void) setValue:(NSString*)value animated:(BOOL)animated;

// some default drawing blocks
+(UIViewDrawingBlock) defaultBadgeDrawingBlock;

@end
