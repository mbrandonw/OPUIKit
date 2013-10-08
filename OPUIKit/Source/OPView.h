//
//  OPView.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/2/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPStyleProtocol.h"
#import "OPUIKitBlockDefinitions.h"

extern NSString * const OPViewDrawingBaseColorKey;
extern NSString * const OPViewDrawingBaseGradientKey;
extern NSString * const OPViewDrawingGradientAmountKey;
extern NSString * const OPViewDrawingInvertedKey;
extern NSString * const OPViewDrawingBorderColorKey;
extern NSString * const OPViewDrawingCornerRadiusKey;
extern NSString * const OPViewDrawingBevelKey;
extern NSString * const OPViewDrawingBevelInnerColorKey;
extern NSString * const OPViewDrawingBevelOuterColorKey;
extern NSString * const OPViewDrawingBevelBorderColorKey;

@interface OPView : UIView <OPStyleProtocol>

@property (nonatomic, strong) UIColor *blurTintColor;
-(void) setBlurStyle:(UIBarStyle)style;
-(void) removeBlurTintColor;

-(id) initWithDrawingBlock:(OPViewDrawingBlock)drawingBlock;
-(id) initWithFrame:(CGRect)rect drawingBlock:(OPViewDrawingBlock)drawingBlock;

-(void) configureForContentSizeCategory:(NSString*)category;
+(void) configureForContentSizeCategory:(NSString*)category;

/**
 Some fancy custom drawing blocks.
 */
+(OPViewDrawingBlock) roundedRectDrawingBlocksWithOptions:(NSDictionary*)options;
+(OPViewDrawingBlock) roundedBackRectDrawingBlocksWithOptions:(NSDictionary*)options;

@end
