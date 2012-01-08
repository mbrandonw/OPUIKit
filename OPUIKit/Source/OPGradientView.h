//
//  OPGradientView.h
//  OPUIKit
//
//  Created by Brandon Williams on 11/21/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPView.h"

@class CAGradientLayer;

@interface OPGradientView : OPView

@property (nonatomic, readonly) CAGradientLayer *gradientLayer;

@end
