//
//  OPView.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/2/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPView.h"
#import "OPStyle.h"
#import "OPGradient.h"
#import "UIColor+Opetopic.h"
#import "NSDictionary+Opetopic.h"
#import "UIBezierPath+Opetopic.h"

static NSInteger drawingBlocksContext;

@interface OPView (/**/)
@property (nonatomic, strong) UIToolbar *blurToolbar;
@property (nonatomic, strong) CALayer *blurLayer;
@property (nonatomic, strong) UIView *blurView;
-(void) __init;
@end

@implementation OPView

@synthesize drawingBlocks = _drawingBlocks;

-(id) initWithDrawingBlock:(OPViewDrawingBlock)drawingBlock {
    if (! (self = [self initWithFrame:CGRectZero]))
        return nil;
    [self.drawingBlocks addObject:drawingBlock];
    return self;
}

-(id) initWithFrame:(CGRect)rect drawingBlock:(OPViewDrawingBlock)drawingBlock {
    if (! (self = [self initWithFrame:rect]))
        return nil;
    [self.drawingBlocks addObject:drawingBlock];
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
    [self addObserver:self forKeyPath:@"drawingBlocks" options:0 context:&drawingBlocksContext];
    [[[self class] styling] applyTo:self];
}

-(void) dealloc {
    [self removeObserver:self forKeyPath:@"drawingBlocks" context:&drawingBlocksContext];
}

-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    for (OPViewDrawingBlock block in self.drawingBlocks)
        block(self, rect, c);
}

-(void) setBlurTintColor:(UIColor *)blurTintColor {
  if ([UIDevice isiOS7OrLater]) {
    _blurTintColor = blurTintColor;
    [self.blurLayer removeFromSuperlayer];

    self.blurToolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
    self.blurToolbar.barTintColor = blurTintColor;
    self.blurLayer = self.blurToolbar.layer;

    self.blurView = [UIView viewWithFrame:self.bounds];
    self.blurView.userInteractionEnabled = NO;
    [self.blurView.layer addSublayer:self.blurLayer];
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleAll;
    self.blurView.clipsToBounds = YES;

    [self addSubview:self.blurView];

    self.backgroundColor = [UIColor clearColor];
  }
}

-(void) didAddSubview:(UIView *)subview {
  [super didAddSubview:subview];
  if (subview != self.blurView) {
    [self sendSubviewToBack:self.blurView];
  }
}

-(void) layoutSubviews {
  [super layoutSubviews];
  self.blurView.frame = self.bounds;
  self.blurLayer.frame = self.bounds;
}

-(void) setDrawingBlocks:(NSMutableArray *)drawingBlocks {
    _drawingBlocks = drawingBlocks;
    [self setNeedsDisplay];
}

-(void) insertObject:(OPViewDrawingBlock)block inDrawingBlocksAtIndex:(NSUInteger)index {
    [_drawingBlocks insertObject:block atIndex:index];
    [self setNeedsDisplay];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &drawingBlocksContext) {
        [self setNeedsDisplay];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

NSString * const OPViewDrawingBaseColorKey = @"OPViewDrawingBaseColorKey";
NSString * const OPViewDrawingBaseGradientKey = @"OPViewDrawingBaseGradientKey";
NSString * const OPViewDrawingGradientAmountKey = @"OPViewDrawingGradientAmountKey";
NSString * const OPViewDrawingInvertedKey = @"OPViewDrawingInvertedKey";
NSString * const OPViewDrawingBorderColorKey = @"OPViewDrawingBorderColorKey";
NSString * const OPViewDrawingCornerRadiusKey = @"OPViewDrawingCornerRadiusKey";
NSString * const OPViewDrawingBevelKey = @"OPViewDrawingBevelKey";
NSString * const OPViewDrawingBevelInnerColorKey = @"OPViewDrawingBevelInnerColorKey";
NSString * const OPViewDrawingBevelOuterColorKey = @"OPViewDrawingBevelOuterColorKey";
NSString * const OPViewDrawingBevelBorderColorKey = @"OPViewDrawingBevelBorderColorKey";

+(OPViewDrawingBlock) roundedRectDrawingBlocksWithOptions:(NSDictionary*)options {
    
    // grab values from the options dictionary
    UIColor *baseColor          = [options objectForKey:OPViewDrawingBaseColorKey];
    OPGradient *baseGradient    = [options objectForKey:OPViewDrawingBaseGradientKey];
    CGFloat gradientAmount      = [[options numberForKey:OPViewDrawingGradientAmountKey] floatValue];
    BOOL inverted               = [[options numberForKey:OPViewDrawingInvertedKey] boolValue];
    UIColor *borderColor        = [options objectForKey:OPViewDrawingBorderColorKey];
    CGFloat radius              = [[options numberForKey:OPViewDrawingCornerRadiusKey] floatValue];
    BOOL bevel                  = [[options numberForKey:OPViewDrawingBevelKey] boolValue];
    UIColor *bevelInnerColor    = [options objectForKey:OPViewDrawingBevelInnerColorKey];
    UIColor *bevelOuterColor    = [options objectForKey:OPViewDrawingBevelOuterColorKey];
    UIColor *bevelBorderColor   = [options objectForKey:OPViewDrawingBevelBorderColorKey];
    
    // create a baseGradient from the baseColor if no gradient is provided
    if (! baseGradient && ! inverted)
        baseGradient = [OPGradient gradientWithColors:@[[baseColor lighten:gradientAmount], [baseColor darken:gradientAmount]]];
    else if (! baseGradient)
        baseGradient = [OPGradient gradientWithColors:@[[baseColor darken:gradientAmount], [baseColor lighten:gradientAmount]]];
    
    // create the drawing block
    return [^(UIView *v, CGRect r, CGContextRef c){
        
        CGRect fullRect = CGRectMake(0.0f, 0.0f, r.size.width, r.size.height-1.0f);
        CGRect insetRect = CGRectInset(fullRect, 1.0f, 1.0f);
        
        if (bevel && bevelOuterColor) {
            [bevelOuterColor set];
            [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, r.size.height-radius*2.0f, r.size.width, radius*2.0f) cornerRadius:radius] fill];
        }
        
        UIBezierPath *fullPath = [UIBezierPath bezierPathWithRoundedRect:fullRect cornerRadius:radius];
        UIBezierPath *insetPath = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:radius-1.0f];
        
        [borderColor set];
        [fullPath fill];
        
        [insetPath addClip];
        [baseGradient fillRectLinearly:insetRect];
        
        if (bevel)
        {
            // and a light border
            if (bevelBorderColor) {
                [bevelBorderColor setStroke];
                [[UIBezierPath bezierPathWithRoundedRect:CGRectInset(insetRect, 0.5f, 0.5f) cornerRadius:radius-1.0f] stroke];
            }
            
            if (bevelInnerColor)
            {
                CGContextSaveGState(c);
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:radius-1.0f];
                CGContextSetFillColorWithColor(c, bevelInnerColor.CGColor);
                CGContextClipToRect(c, CGRectMake(0.0f, 0.0f, r.size.width, radius));
                CGContextAddPath(c, path.CGPath);
                CGContextTranslateCTM(c, 0.0f, 1.0f);
                CGContextAddPath(c, path.CGPath);
                CGContextEOFillPath(c);
                CGContextRestoreGState(c);
            }
        }
        
    } copy];
}

+(OPViewDrawingBlock) roundedBackRectDrawingBlocksWithOptions:(NSDictionary*)options {
    
    // grab values from the options dictionary
    UIColor *baseColor          = [options objectForKey:OPViewDrawingBaseColorKey];
    OPGradient *baseGradient    = [options objectForKey:OPViewDrawingBaseGradientKey];
    CGFloat gradientAmount      = [[options numberForKey:OPViewDrawingGradientAmountKey] floatValue];
    BOOL inverted               = [[options numberForKey:OPViewDrawingInvertedKey] boolValue];
    UIColor *borderColor        = [options objectForKey:OPViewDrawingBorderColorKey];
    CGFloat radius              = [[options numberForKey:OPViewDrawingCornerRadiusKey] floatValue];
    BOOL bevel                  = [[options numberForKey:OPViewDrawingBevelKey] boolValue];
    UIColor *bevelInnerColor    = [options objectForKey:OPViewDrawingBevelInnerColorKey];
    UIColor *bevelOuterColor    = [options objectForKey:OPViewDrawingBevelOuterColorKey];
    UIColor *bevelBorderColor   = [options objectForKey:OPViewDrawingBevelBorderColorKey];
    
    // create a baseGradient from the baseColor if no gradient is provided
    if (! baseGradient && ! inverted)
        baseGradient = [OPGradient gradientWithColors:@[[baseColor lighten:gradientAmount], [baseColor darken:gradientAmount]]];
    else if (! baseGradient)
        baseGradient = [OPGradient gradientWithColors:@[[baseColor darken:gradientAmount], [baseColor lighten:gradientAmount]]];
    
    // create the drawing block
    return [^(UIView *v, CGRect r, CGContextRef c){
        
        CGFloat pointerSize = r.size.height == 30.0f ? 8.0f : 6.0f;
        
        CGRect fullRect = CGRectMake(0.0f, 0.0f, r.size.width, r.size.height-1.0f);
        CGRect insetRect = CGRectInset(fullRect, 1.0f, 1.0f);
        
        UIBezierPath *fullPath = [UIBezierPath bezierPathWithPointedRoundedRect:fullRect radius:radius pointerSize:pointerSize];
        UIBezierPath *insetPath = [UIBezierPath bezierPathWithPointedRoundedRect:insetRect radius:radius-1.0f pointerSize:pointerSize];
        
        if (bevel && bevelOuterColor) {
            [bevelOuterColor set];
            CGContextSaveGState(c);
            CGContextTranslateCTM(c, 0.0f, 1.0f);
            [fullPath fill];
            CGContextRestoreGState(c);
        }
        
        [borderColor set];
        [fullPath fill];
        
        [insetPath addClip];
        [baseGradient fillRectLinearly:insetRect];
        
        if (bevel)
        {
            // and a light border
            if (bevelBorderColor) {
                [bevelBorderColor setStroke];
                [[UIBezierPath bezierPathWithPointedRoundedRect:CGRectInset(insetRect, 0.5f, 0.5f) radius:radius-1.0f pointerSize:pointerSize] stroke];
            }
            
            if (bevelInnerColor)
            {
                CGContextSaveGState(c);
                UIBezierPath *path = [UIBezierPath bezierPathWithPointedRoundedRect:insetRect radius:radius-1.0f pointerSize:pointerSize];
                CGContextSetFillColorWithColor(c, bevelInnerColor.CGColor);
                CGContextClipToRect(c, CGRectMake(0.0f, 0.0f, r.size.width, radius));
                CGContextAddPath(c, path.CGPath);
                CGContextTranslateCTM(c, 0.0f, 1.0f);
                CGContextAddPath(c, path.CGPath);
                CGContextEOFillPath(c);
                CGContextRestoreGState(c);
            }
        }
        
    } copy];
}

@end
