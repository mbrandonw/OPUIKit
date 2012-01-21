//
//  OPControl.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/15/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPControl.h"
#import "OPUIKitBlockDefinitions.h"
#import "OPStyle.h"

@implementation OPControl

@synthesize drawingBlocksByControlState = _drawingBlocksByControlState;

#pragma mark -
#pragma mark Object lifecycle
#pragma mark -

-(id) initWithFrame:(CGRect)frame {
    if (! (self = [super initWithFrame:frame]))
        return nil;
    
    self.drawingBlocksByControlState = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        [NSMutableArray new], [NSNumber numberWithInt:UIControlStateNormal], 
                                        [NSMutableArray new], [NSNumber numberWithInt:UIControlStateHighlighted], 
                                        [NSMutableArray new], [NSNumber numberWithInt:UIControlStateDisabled], 
                                        [NSMutableArray new], [NSNumber numberWithInt:UIControlStateSelected], nil];
    
    // observe states so we can redraw the button when it changes
    [self addObserver:self forKeyPath:@"enabled" options:0 context:NULL];
    [self addObserver:self forKeyPath:@"selected" options:0 context:NULL];
    [self addObserver:self forKeyPath:@"highlighted" options:0 context:NULL];
    
    return self;
}

#pragma mark -
#pragma mark Helper methods
#pragma mark -

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

#pragma mark -
#pragma mark Drawing methods
#pragma mark -

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

#pragma mark -
#pragma mark Custom getters/setters
#pragma mark -

-(void) setDrawingBlocksByControlState:(NSMutableDictionary *)drawingBlocksByControlState {
    _drawingBlocksByControlState = drawingBlocksByControlState;
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark KVO methods
#pragma mark -

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay];
}

@end
