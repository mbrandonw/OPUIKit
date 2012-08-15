//
//  OPButton.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/14/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPUIKitBlockDefinitions.h"
#import "OPStyleProtocol.h"

@class OPButton;

@interface OPButton : UIButton <OPStyleProtocol>

@property (nonatomic, copy) NSMutableDictionary *drawingBlocksByControlState;
-(void) addDrawingBlock:(OPControlDrawingBlock)block forState:(UIControlState)state;

@end
