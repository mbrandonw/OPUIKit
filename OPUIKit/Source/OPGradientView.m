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

-(id) init {
    if (! (self = [super init]))
        return nil;
    self.layer.shouldRasterize = YES;
    return self;
}

-(id) initWithFrame:(CGRect)frame {
    if (! (self = [super initWithFrame:frame]))
        return nil;
    self.layer.shouldRasterize = YES;
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (! (self = [super initWithCoder:aDecoder]))
        return nil;
    self.layer.shouldRasterize = YES;
    return self;
}

@end
