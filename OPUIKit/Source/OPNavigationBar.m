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
#import "OPGradientView.h"
#import "UIView+Opetopic.h"

@interface OPNavigationBar (/**/)
@property (nonatomic, strong) OPGradientView *shadowView;
@end

@implementation OPNavigationBar

@synthesize shadowHidden = _shadowHidden;
@synthesize shadowView = _shadowView;

// Supported OPStyle storage
@synthesize backgroundImage = _backgroundImage;
@synthesize shadowHeight = _shadowHeight;
@synthesize shadowColors = _shadowColors;
@synthesize gradientAmount = _gradientAmount;
@synthesize glossAmount = _glossAmount;
@synthesize glossOffset = _glossOffset;
@synthesize translucent = _translucent;
@synthesize navigationBarDrawingBlock = _navigationBarDrawingBlock;

#pragma mark -
#pragma mark Object lifecycle
#pragma mark -

-(id) initWithCoder:(NSCoder *)aDecoder {
	if (! (self = [super initWithCoder:aDecoder]))
		return nil;
    
    self.clipsToBounds = NO;
	
    self.shadowView = [[OPGradientView alloc] initWithFrame:CGRectMake(0.0f, self.height, self.width, self.shadowHeight)];
    self.shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.shadowView.gradientLayer.startPoint = CGPointMake(0.5f, 1.0f);
    self.shadowView.gradientLayer.endPoint = CGPointMake(0.5f, 0.0);
    [self addSubview:self.shadowView];
    
    // apply stylings
    [[[self class] styling] applyTo:self];
    
    // pass the background color to the tint color so that default bar button items inherit some of the styling
    if (self.backgroundColor)
        self.tintColor = self.backgroundColor;
    
	return self;
}

#pragma mark -
#pragma mark Drawing methods
#pragma mark -

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
        
        if (self.gradientAmount > 0.0f) {
            [[OPGradient gradientWithColors:@[[self.backgroundColor lighten:self.gradientAmount], 
                                             self.backgroundColor, 
                                             [self.backgroundColor darken:self.gradientAmount]]] fillRectLinearly:rect];
        }
    }
    
    // apply gloss over everything
    if (self.glossAmount)
    {
        shouldCallSuper = NO;
        [$WAf(1.0f,self.glossAmount) set];
        CGContextFillRect(c, CGRectMake(0.0f, 0.0f, rect.size.width, roundf(rect.size.height/2.0f + self.glossOffset)));
    }
    
    // apply additional block based drawing
    if (self.navigationBarDrawingBlock)
    {
        shouldCallSuper = NO;
        self.navigationBarDrawingBlock(self, rect, c);
    }
    
    if (shouldCallSuper)
        [super drawRect:rect];
}

-(void) layoutSubviews {
    [super layoutSubviews];
    self.shadowView.frame = CGRectMake(0.0f, self.height, self.width, self.shadowView.height);
}

#pragma mark -
#pragma mark Custom getters/setters
#pragma mark -

-(void) setShadowHeight:(CGFloat)shadowHeight {
    _shadowHeight = shadowHeight;
    self.shadowView.height = shadowHeight;
    [self setShadowHidden:(shadowHeight == 0.0f)];
    [self setNeedsLayout];
}

-(void) setShadowColors:(NSArray *)shadowColors {
    _shadowColors = shadowColors;
    self.shadowView.gradientLayer.colors = shadowColors;
    [self setNeedsLayout];
}

-(void) setShadowHidden:(BOOL)hidden {
    [self setShadowHidden:hidden animated:NO];
}

-(void) setShadowHidden:(BOOL)hidden animated:(BOOL)animated {
    _shadowHeight = hidden;
    
    [UIView animateWithDuration:(0.3f * animated) animations:^{
        self.shadowView.alpha = hidden ? 0.0f : 1.0f;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = hidden;
    }];
}

@end
