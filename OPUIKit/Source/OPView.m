//
//  OPView.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/2/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPView.h"

@interface OPView (/**/)
@property (nonatomic, strong) NSMutableArray *frontDrawingBlocks;
@property (nonatomic, strong) NSMutableArray *backDrawingBlocks;
@end

@implementation OPView

@synthesize frontDrawingBlocks;
@synthesize backDrawingBlocks;

-(void) addBackDrawingBlock:(OPViewDrawingBlock)block {
    
    [self.backDrawingBlocks addObject:[block copy]];
}

-(void) addFrontDrawingBlock:(OPViewDrawingBlock)block {
    
    [self.frontDrawingBlocks addObject:[block copy]];
}

-(void) drawRect:(CGRect)rect {
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    for (OPViewDrawingBlock block in self.backDrawingBlocks)
        block(self, rect, c);
    
    [super drawRect:rect];
    
    for (OPViewDrawingBlock block in self.frontDrawingBlocks)
        block(self, rect, c);
}

@end
