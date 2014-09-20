//
//  OPUIKitBlockDefinitions.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/16/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef void(^OPViewDrawingBlock)(UIView* view, CGRect rect, CGContextRef c);
typedef void(^OPControlDrawingBlock)(UIControl* view, CGRect rect, CGContextRef c);
