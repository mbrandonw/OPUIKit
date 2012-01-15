//
//  OPControl.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/15/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPControl;
typedef void(^OPControlDrawingBlock)(OPControl* b, CGRect r, CGContextRef c);

@interface OPControl : UIControl

-(void) addDrawingBlock:(OPControlDrawingBlock)block forState:(UIControlState)state;
-(void) removeDrawingBlocksForState:(UIControlState)state;
-(void) removeAllDrawingBlocks;

@end
