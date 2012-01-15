//
//  OPButton.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/14/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPButton;
typedef void(^OPButtonDrawingBlock)(OPButton* b, CGRect r, CGContextRef c);

@interface OPButton : UIButton

-(void) addDrawingBlock:(OPButtonDrawingBlock)block forState:(UIControlState)state;
-(void) removeDrawingBlocksForState:(UIControlState)state;
-(void) removeAllDrawingBlocks;

@end
