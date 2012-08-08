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

-(id) initWithDrawingBlock:(UIViewDrawingBlock)drawingBlock;

/**
 Some fancy custom drawing blocks.
 */
+(UIViewDrawingBlock) roundedRectDrawingBlocksWithOptions:(NSDictionary*)options;
+(UIViewDrawingBlock) roundedBackRectDrawingBlocksWithOptions:(NSDictionary*)options;

@end
