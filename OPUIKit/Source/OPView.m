//
//  OPView.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/2/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPView.h"
#import "OPStyle.h"

@interface OPView (/**/)
-(void) __init;
@end

@implementation OPView

@synthesize drawingBlocks = _drawingBlocks;

-(id) init {
    if (! (self = [super init]))
        return nil;
    [self __init];
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (! (self = [super initWithCoder:aDecoder]))
        return nil;
    [self __init];
    return self;
}

-(id) initWithFrame:(CGRect)frame {
    if (! (self = [super initWithFrame:frame]))
        return nil;
    [self __init];
    return self;
}

-(void) __init {
    self.drawingBlocks = [NSMutableArray new];
    [self addObserver:self forKeyPath:@"drawingBlocks" options:0 context:NULL];
    [[[self class] styling] applyTo:self];
}

-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    for (UIViewDrawingBlock block in self.drawingBlocks)
        block(self, rect, c);
}

-(void) setDrawingBlocks:(NSMutableArray *)drawingBlocks {
    _drawingBlocks = drawingBlocks;
    [self setNeedsDisplay];
}

-(void) insertObject:(UIViewDrawingBlock)block inDrawingBlocksAtIndex:(NSUInteger)index {
    [_drawingBlocks insertObject:block atIndex:index];
    [self setNeedsDisplay];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay];
}

@end
