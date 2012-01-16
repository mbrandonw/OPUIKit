//
//  OPView.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/2/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPView.h"
#import "OPStyle.h"

@implementation OPView

@synthesize drawingBlocks = _drawingBlocks;

-(id) init {
    if (! (self = [super init]))
        return nil;
    [[[self class] styling] applyTo:self];
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (! (self = [super initWithCoder:aDecoder]))
        return nil;
    [[[self class] styling] applyTo:self];
    return self;
}

-(id) initWithFrame:(CGRect)frame {
    if (! (self = [super initWithFrame:frame]))
        return nil;
    [[[self class] styling] applyTo:self];
    return self;
}

-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    for (UIViewDrawingBlock block in self.drawingBlocks)
        block(self, rect, c);
}

@end
