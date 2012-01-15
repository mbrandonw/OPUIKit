//
//  OPView.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/2/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPView;

typedef void(^OPViewDrawingBlock)(OPView* v, CGRect r, CGContextRef c);

@interface OPView : UIView

-(void) addDrawingBlock:(OPViewDrawingBlock)block;
-(void) removeAllDrawingBlocks;

@end
