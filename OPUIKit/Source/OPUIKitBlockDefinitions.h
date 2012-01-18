//
//  OPUIKitBlockDefinitions.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/16/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UIViewDrawingBlock)(UIView* v, CGRect r, CGContextRef c);
typedef void(^UIControlDrawingBlock)(UIControl* v, CGRect r, CGContextRef c);
