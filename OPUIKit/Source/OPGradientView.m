//
//  OPGradientView.m
//  OPUIKit
//
//  Created by Brandon Williams on 11/21/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import "OPGradientView.h"
#import <QuartzCore/QuartzCore.h>

@implementation OPGradientView

+(Class) layerClass {
    return [CAGradientLayer class];
}

-(CAGradientLayer*) gradientLayer {
    return (CAGradientLayer*)self.layer;
}

@end
