//
//  OPView.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/2/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPView.h"

@interface OPView (/**/)
@property (nonatomic, strong) NSMutableArray *drawingBlocks;
@end

@implementation OPView

@synthesize drawingBlocks;

-(void) addDrawingBlock:(OPViewDrawingBlock)block {
    
    if (! self.drawingBlocks)
        self.drawingBlocks = [NSMutableArray new];
    [self.drawingBlocks addObject:[block copy]];
    
    [self setNeedsDisplay];
}

-(void) removeAllDrawingBlocks {
    [self.drawingBlocks removeAllObjects];
    [self setNeedsDisplay];
}

-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    for (OPViewDrawingBlock block in self.drawingBlocks)
        block(self, rect, c);
}

@end
