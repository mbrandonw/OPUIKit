//
//  OPControl.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/15/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPStyleProtocol.h"
#import "OPUIKitBlockDefinitions.h"

@interface OPControl : UIControl <OPStyleProtocol>

-(void) addDrawingBlock:(UIControlDrawingBlock)block forState:(UIControlState)state;

@end
