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
#import "NSNumber+Opetopic.h"

@implementation OPControl

@synthesize drawingBlocksByControlState = _drawingBlocksByControlState;

#pragma mark -
#pragma mark Object lifecycle
#pragma mark -

-(id) initWithFrame:(CGRect)frame {
    if (! (self = [super initWithFrame:frame]))
        return nil;
    
    self.drawingBlocksByControlState = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        [NSMutableArray new], $int(UIControlStateNormal), 
                                        [NSMutableArray new], $int(UIControlStateHighlighted), 
                                        [NSMutableArray new], $int(UIControlStateDisabled), 
                                        [NSMutableArray new], $int(UIControlStateSelected), nil];
    
    // observe states so we can redraw the button when it changes
    [self addObserver:self forKeyPath:@"enabled" options:0 context:NULL];
    [self addObserver:self forKeyPath:@"selected" options:0 context:NULL];
    [self addObserver:self forKeyPath:@"highlighted" options:0 context:NULL];
    
    // apply styles
    [[[self class] styling] applyTo:self];
    
    return self;
}

#pragma mark -
#pragma mark Helper methods
#pragma mark -

-(void) addDrawingBlock:(UIControlDrawingBlock)block forState:(UIControlState)state {
    
    if (state == UIControlStateNormal)
        [[self.drawingBlocksByControlState objectForKey:$int(UIControlStateNormal)] addObject:[block copy]];
    
    if (state & UIControlStateHighlighted)
        [[self.drawingBlocksByControlState objectForKey:$int(UIControlStateHighlighted)] addObject:[block copy]];
    
    if (state & UIControlStateDisabled)
        [[self.drawingBlocksByControlState objectForKey:$int(UIControlStateDisabled)] addObject:[block copy]];
    
    if (state & UIControlStateSelected)
        [[self.drawingBlocksByControlState objectForKey:$int(UIControlStateSelected)] addObject:[block copy]];
    
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
    
    // make sure there is an array of drawing blocks for each state
    if (! [self.drawingBlocksByControlState objectForKey:$int(UIControlStateNormal)])
        [self.drawingBlocksByControlState setObject:[NSMutableArray new] forKey:$int(UIControlStateNormal)];
    if (! [self.drawingBlocksByControlState objectForKey:$int(UIControlStateHighlighted)])
        [self.drawingBlocksByControlState setObject:[NSMutableArray new] forKey:$int(UIControlStateHighlighted)];
    if (! [self.drawingBlocksByControlState objectForKey:$int(UIControlStateSelected)])
        [self.drawingBlocksByControlState setObject:[NSMutableArray new] forKey:$int(UIControlStateSelected)];
    if (! [self.drawingBlocksByControlState objectForKey:$int(UIControlStateDisabled)])
        [self.drawingBlocksByControlState setObject:[NSMutableArray new] forKey:$int(UIControlStateDisabled)];
    
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark KVO methods
#pragma mark -

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay];
}

@end
