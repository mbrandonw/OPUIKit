//
//  OPButton.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/14/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPButton.h"
#import "NSNumber+Opetopic.h"

@interface OPButton (/**/)
@property (nonatomic, strong) NSMutableDictionary *drawingBlocks;
@end

@implementation OPButton

@synthesize drawingBlocks;

-(void) addDrawingBlock:(OPButtonDrawingBlock)block forState:(UIControlState)state {
    
    if (! self.drawingBlocks)
        self.drawingBlocks = [NSMutableDictionary new];
    if (! [self.drawingBlocks objectForKey:$int(state)])
        [self.drawingBlocks setObject:[NSMutableArray new] forKey:$int(state)];
    
    [[self.drawingBlocks objectForKey:$int(state)] addObject:[block copy]];
}

-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    for (NSNumber *drawState in self.drawingBlocks)
    {
        if (([drawState intValue] & self.state) || (self.state == UIControlStateNormal && [drawState intValue] == UIControlStateNormal))
        {
            for (OPButtonDrawingBlock block in [self.drawingBlocks objectForKey:drawState])
                block(self, rect, c);
        }
    }
}

@end
