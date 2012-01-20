//
//  OPButton.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/14/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPButton.h"
#import "NSNumber+Opetopic.h"
#import "OPStyle.h"

@implementation OPButton

@synthesize drawingBlocksByControlState = _drawingBlocksByControlState;

-(id) initWithFrame:(CGRect)frame {
    if (! (self = [super initWithFrame:frame]))
        return nil;
    
    self.drawingBlocksByControlState = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        [NSMutableArray new], [NSNumber numberWithInt:UIControlStateNormal], 
                                        [NSMutableArray new], [NSNumber numberWithInt:UIControlStateHighlighted], 
                                        [NSMutableArray new], [NSNumber numberWithInt:UIControlStateDisabled], 
                                        [NSMutableArray new], [NSNumber numberWithInt:UIControlStateSelected], nil];
    
    return self;
}

-(void) addDrawingBlock:(UIControlDrawingBlock)block forState:(UIControlState)state {
    
    if (state == UIControlStateNormal)
        [[self.drawingBlocksByControlState objectForKey:[NSNumber numberWithInt:UIControlStateNormal]] addObject:[block copy]];
    
    if (state & UIControlStateHighlighted)
        [[self.drawingBlocksByControlState objectForKey:[NSNumber numberWithInt:UIControlStateHighlighted]] addObject:[block copy]];
    
    if (state & UIControlStateDisabled)
        [[self.drawingBlocksByControlState objectForKey:[NSNumber numberWithInt:UIControlStateDisabled]] addObject:[block copy]];
    
    if (state & UIControlStateSelected)
        [[self.drawingBlocksByControlState objectForKey:[NSNumber numberWithInt:UIControlStateSelected]] addObject:[block copy]];
    
    [self setNeedsDisplay];
}

-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    for (UIControlDrawingBlock block in [self.drawingBlocksByControlState objectForKey:[NSNumber numberWithInt:UIControlStateNormal]])
        block(self, rect, c);
    
    for (NSNumber *drawState in self.drawingBlocksByControlState)
    {
        if ([drawState intValue] & self.state)
        {
            for (UIControlDrawingBlock block in [self.drawingBlocksByControlState objectForKey:drawState])
                block(self, rect, c);
        }
    }
}

-(void) setDrawingBlocksByControlState:(NSMutableDictionary *)drawingBlocksByControlState {
    _drawingBlocksByControlState = drawingBlocksByControlState;
    [self setNeedsDisplay];
}

@end
