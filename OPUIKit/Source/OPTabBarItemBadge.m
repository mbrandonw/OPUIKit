//
//  OPTabBarItemBadge.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/19/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import "OPTabBarItemBadge.h"
#import "OPExtensionKit.h"
#import "OPStyle.h"
#import "OPGradient.h"

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
    
    // init the value label subview with some sensible defaults
    self.valueLabel = [UILabel new];
    self.valueLabel.backgroundColor = [UIColor clearColor];
    self.valueLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.valueLabel.textColor = [UIColor whiteColor];
    self.valueLabel.textAlignment = UITextAlignmentCenter;
    self.valueLabelInsets = UIEdgeInsetsMake(2.0f, 5.0f, 2.0f, 5.0f);
    self.minSize = CGSizeMake(23.0f, 23.0f);
    self.relativeCenter = CGPointMake(0.75f, 0.2f);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shouldRasterize = YES;
    [self addSubview:self.valueLabel];
    
    // apply stylings
    [[[self class] styling] applyTo:self];
    
    [self.drawingBlocks addObject:[[self class] defaultBadgeDrawingBlock]];
    
    return self;
}

#pragma mark -
#pragma Overridden UIView methods
#pragma mark -

-(void) layoutSubviews {
    [super layoutSubviews];
    
    [self.valueLabel sizeToFit];
    self.size = CGSizeMake(MAX(self.minSize.width, self.valueLabel.width + self.valueLabelInsets.left + self.valueLabelInsets.right), 
                           MAX(self.minSize.height, self.valueLabel.height + self.valueLabelInsets.top + self.valueLabelInsets.bottom));
    
    self.valueLabel.frame = CGRectMake(0.0f, self.valueLabelInsets.top, self.width, self.valueLabel.height);
}

#pragma mark -
#pragma Custom getters/setters
#pragma mark -

-(UILabel*) valueLabel {
    [self.superview setNeedsDisplayAndLayout];
    return _valueLabel;
}

-(void) setValueLabelInsets:(UIEdgeInsets)valueLabelInsets {
    _valueLabelInsets = valueLabelInsets;
    [self setNeedsDisplayAndLayout];
    [self.superview setNeedsDisplayAndLayout];
}

-(void) setMinSize:(CGSize)minSize {
    _minSize = minSize;
    [self setNeedsDisplayAndLayout];
    [self.superview setNeedsDisplayAndLayout];
}

-(void) setRelativeCenter:(CGPoint)relativeCenter {
    _relativeCenter = relativeCenter;
    [self setNeedsDisplayAndLayout];
    [self.superview setNeedsDisplayAndLayout];
}

-(void) setValue:(NSString*)value {
    [self setValue:value animated:NO];
}

-(void) setValue:(NSString*)value animated:(BOOL)animated {
    [self setNeedsLayout];
    
    self.hidden = NO;
    
    // animation can only happen when the value changes from nil to non-nil, or vice-versa
    animated = animated && ((self.valueLabel.text == nil && value != nil) || (self.valueLabel.text != nil && value == nil));
    self.valueLabel.text = [value length] == 0 ? nil : value;
    
    if (animated)
    {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.values = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:self.valueLabel.text ? kBadgeSmallTransform : CATransform3DIdentity],
                            [NSValue valueWithCATransform3D:self.valueLabel.text ? kBadgeLargeTransform : kBadgeLargeTransform],
                            [NSValue valueWithCATransform3D:self.valueLabel.text ? CATransform3DIdentity : kBadgeSmallTransform], nil];
        animation.delegate = self;
        [self.layer addAnimation:animation forKey:@"pop"];
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
#pragma Some default drawing blocks
#pragma mark -

+(UIViewDrawingBlock) defaultBadgeDrawingBlock {
    
    return [^(UIView* v, CGRect r, CGContextRef c){
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:r cornerRadius:r.size.height];
        [[UIColor whiteColor] set];
        [path fill];
        
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(r, 2.0f, 2.0f) cornerRadius:r.size.height-2.0f];
        [path addClip];
        
        [[OPGradient gradientWithColors:[NSArray arrayWithObjects:$RGBi(255,0,0),$RGBi(215,0,0), nil]]
         fillRectLinearly:r];
        
        [[OPGradient gradientWithColors:[NSArray arrayWithObjects:$WAf(1.0f,0.85f),$WAf(1.0f,0.1f), nil]]
         fillRectLinearly:CGRectMake(0.0f, 0.0f, r.size.width, r.size.height/2.0f)];
        
    } copy];
}

@end
