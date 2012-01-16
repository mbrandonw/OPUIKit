//
//  OPNavigationBar.m
//  OPUIKit
//
//  Created by Brandon Williams on 12/19/10.
//  Copyright 2010 Opetopic. All rights reserved.
//

#import "OPNavigationBar.h"
#import "UIImage+Opetopic.h"
#import "UIColor+Opetopic.h"
#import "OPGradient.h"

@implementation OPNavigationBar

// Supported OPStyle storage
@synthesize backgroundColor = _backgroundColor;
@synthesize backgroundImage = _backgroundImage;
@synthesize gradientAmount = _gradientAmount;
@synthesize glossAmount = _glossAmount;
@synthesize glossOffset = _glossOffset;
@synthesize translucent = _translucent;
@synthesize drawingBlock = _drawingBlock;

#pragma mark Initialization methods
-(id) initWithCoder:(NSCoder *)aDecoder {
	if (! (self = [super initWithCoder:aDecoder]))
		return nil;
	
    // apply stylings
    [[[self class] styling] applyTo:self];
    
    if (self.backgroundColor)
        self.tintColor = self.backgroundColor;
    
	return self;
}
#pragma mark -


#pragma mark Drawing methods
-(void) drawRect:(CGRect)rect {
    BOOL shouldCallSuper = YES;
    CGContextRef c = UIGraphicsGetCurrentContext();
	
    // draw background images & colors
    if (self.backgroundImage)
    {
        shouldCallSuper = NO;
        
        // figure out if we need to draw a stretchable image or a pattern image
        if ([self.backgroundImage isStretchableImage])
            [self.backgroundImage drawInRect:rect];
        else
            [self.backgroundImage drawAsPatternInRect:rect];
    }
    if (self.backgroundColor)
    {
        shouldCallSuper = NO;
        
        [[OPGradient gradientWithColors:[NSArray arrayWithObjects:
                                         [self.backgroundColor lighten:self.gradientAmount], 
                                         self.backgroundColor, 
                                         [self.backgroundColor darken:self.gradientAmount],
                                         nil]]
         fillRectLinearly:rect];
    }
    
    // apply gloss over everything
    if (self.glossAmount)
    {
        shouldCallSuper = NO;
        [$WAf(1.0f,self.glossAmount) set];
        CGContextFillRect(c, CGRectMake(0.0f, 0.0f, rect.size.width, roundf(rect.size.height/2.0f + self.glossOffset)));
    }
    
    // apply additional block based drawing
    if (self.drawingBlock)
        self.drawingBlock(self, rect, c);
    
    if (shouldCallSuper)
        [super drawRect:rect];
}
#pragma mark -

@end
