//
//  OPTabBarItemBadge.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/19/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPTabBarItemBadge.h"
#import "OPStyle.h"
#import "OPGradient.h"
#import "UIView+Opetopic.h"
#import "UIColor+Opetopic.h"
#import <QuartzCore/QuartzCore.h>

#define kBadgeMaxScale  1.3f
#define kBadgeMinScale  0.1f

#define kBadgeSmallTransform    CATransform3DMakeScale(kBadgeMinScale, kBadgeMinScale, kBadgeMinScale)
#define kBadgeLargeTransform    CATransform3DMakeScale(kBadgeMaxScale, kBadgeMaxScale, kBadgeMaxScale)

@interface OPTabBarItemBadge (/**/)
@property (nonatomic, strong, readwrite) UILabel *valueLabel;
@end

@implementation OPTabBarItemBadge

@synthesize valueLabel = _valueLabel;
@synthesize valueLabelInsets = _valueLabelInsets;
@synthesize minSize = _minSize;
@synthesize relativeCenter = _relativeCenter;
@synthesize coalesceZeroToNil = _coalesceZeroToNil;

- (id)init {
    if (! (self = [super init]))
        return nil;
    
    // customize view
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    self.userInteractionEnabled = NO;
    
    // init the value label subview with some sensible defaults
    self.valueLabel = [UILabel new];
    self.valueLabel.backgroundColor = [UIColor clearColor];
    self.valueLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.valueLabel.textColor = [UIColor whiteColor];
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabelInsets = UIEdgeInsetsMake(2.0f, 6.0f, 2.0f, 6.0f);
    self.minSize = CGSizeMake(23.0f, 23.0f);
    self.relativeCenter = CGPointMake(0.75f, 0.2f);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowRadius = 4.0f;
    self.layer.shouldRasterize = YES;
    [self addSubview:self.valueLabel];
    
    // apply stylings
    [[[self class] styling] applyTo:self];
    
    // use the default badge draw block (looks like apple's red badge)
    if ([self.drawingBlocks count] == 0)
        [self.drawingBlocks addObject:[[self class] defaultBadgeDrawingBlock]];
    
    return self;
}

#pragma mark -
#pragma mark Overridden UIView methods
#pragma mark -

-(void) layoutSubviews {
    [super layoutSubviews];
    
    [self.valueLabel sizeToFit];
    self.size = CGSizeMake(MAX(self.minSize.width, self.valueLabel.width + self.valueLabelInsets.left + self.valueLabelInsets.right), 
                           MAX(self.minSize.height, self.valueLabel.height + self.valueLabelInsets.top + self.valueLabelInsets.bottom));
    
    self.valueLabel.frame = CGRectMake(0.0f, self.valueLabelInsets.top, self.width, self.valueLabel.height);
    
    [self.superview setNeedsLayout];
}

#pragma mark -
#pragma mark Custom getters/setters
#pragma mark -

-(void) setValueLabelInsets:(UIEdgeInsets)valueLabelInsets {
    _valueLabelInsets = valueLabelInsets;
    [self setNeedsDisplayAndLayout];
}

-(void) setMinSize:(CGSize)minSize {
    _minSize = minSize;
    [self setNeedsDisplayAndLayout];
}

-(void) setRelativeCenter:(CGPoint)relativeCenter {
    _relativeCenter = relativeCenter;
    [self setNeedsDisplayAndLayout];
}

-(void) setValue:(NSString*)value {
    [self setValue:value animated:NO];
}

-(void) setValue:(NSString*)value animated:(BOOL)animated {
    [self setNeedsDisplayAndLayout];
    self.hidden = NO;
    
    // animation can only happen when the value changes from nil to non-nil, or vice-versa
    animated = animated && ((self.valueLabel.text == nil && value != nil) || (self.valueLabel.text != nil && value == nil));
    self.valueLabel.text = [value length] == 0 ? nil : value;
    
    if (animated)
    {
        // we need to use CA animations in order to avoid weird UIView layout problems.
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.values = @[[NSValue valueWithCATransform3D:self.valueLabel.text ? kBadgeSmallTransform : CATransform3DIdentity],
                            [NSValue valueWithCATransform3D:self.valueLabel.text ? kBadgeLargeTransform : kBadgeLargeTransform],
                            [NSValue valueWithCATransform3D:self.valueLabel.text ? CATransform3DIdentity : kBadgeSmallTransform]];
        animation.delegate = self;
        [self.layer addAnimation:animation forKey:@"animation"];
    }
    else
    {
        self.layer.transform = CATransform3DIdentity;
        self.hidden = self.valueLabel.text == nil;
    }
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag)
        self.hidden = self.valueLabel.text == nil;
}

#pragma mark -
#pragma mark Some default drawing blocks
#pragma mark -

+(OPViewDrawingBlock) defaultBadgeDrawingBlock {
    return [[self class] defaultBadgeDrawingBlockWithColor:$RGBi(235,0,0)];
}

+(OPViewDrawingBlock) defaultBadgeDrawingBlockWithColor:(UIColor*)color {
    
    return [^(UIView* v, CGRect r, CGContextRef c){
        
        // fill the white background border
        [[UIColor whiteColor] set];
        [[UIBezierPath bezierPathWithRoundedRect:r cornerRadius:r.size.height] fill];
        
        // fill the background color and gloss
        [[UIBezierPath bezierPathWithRoundedRect:CGRectInset(r, 1.5f, 1.5f) cornerRadius:r.size.height-2.0f] addClip];
        [[OPGradient gradientWithColors:@[[color lighten:0.08f], [color darken:0.08f]]]
         fillRectLinearly:r];
        [[OPGradient gradientWithColors:@[$WAf(1.0f,0.85f),$WAf(1.0f,0.2f)]]
         fillRectLinearly:CGRectMake(0.0f, 0.0f, r.size.width, ceilf(r.size.height/2.0f))];
        
    } copy];
}

@end
