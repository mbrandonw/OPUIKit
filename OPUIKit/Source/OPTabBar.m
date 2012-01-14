//
//  OPTabBar.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/13/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPTabBar.h"
#import "OPTabBarItem.h"

#import "OPView.h"
#import "OPGradientView.h"

#import "UIImage+Opetopic.h"
#import "NSArray+Opetopic.h"
#import "UIColor+Opetopic.h"
#import "UIView+Opetopic.h"

#import "OPMacros.h"
#import <QuartzCore/QuartzCore.h>

@interface OPTabBar (/**/)
@property (nonatomic, strong) OPGradientView *backgroundView;
@property (nonatomic, strong) OPView *overlayView;
@property (nonatomic, strong) OPGradientView *shadowView;
@end

@implementation OPTabBar

@synthesize delegate;
@synthesize backgroundImage; // Image that is drawn in the background of the tab bar.
@synthesize style;
@synthesize shadowHeight;

@synthesize items;
@synthesize selectedItem;
@synthesize itemDistribution;

@synthesize backgroundView;
@synthesize overlayView;
@synthesize shadowView;

#pragma mark -
#pragma mark === Object lifecycle ===
#pragma mark -

- (id)initWithFrame:(CGRect)frame {
    if (! (self = [super initWithFrame:frame]))
        return nil;
    
    // default ivars
    if (self.height == 0.0f)
        self.height = 49.0f;
    self.style = OPTabBarStyleDefault;
    self.itemDistribution = OPTabBarItemDistributionDefault;
    
    // init background view
    self.backgroundView = [[OPGradientView alloc] initWithFrame:self.bounds];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.backgroundView];
    
    // init overlay view
    self.overlayView = [[OPView alloc] initWithFrame:self.bounds];
    self.overlayView.backgroundColor = [UIColor clearColor];
    self.overlayView.opaque = NO;
    self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.overlayView];
    
    // init shadow view
    self.shadowView = [[OPGradientView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.shadowView];
    [self setShadowAlphaStops:$array(NSFloat(0.0f), NSFloat(0.3f))];
    
    return self;
}

-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.backgroundImage)
    {
        self.backgroundView.hidden = YES;
        
        if ([self.backgroundImage isStretchableImage])
            [self.backgroundImage drawInRect:rect];
        else
            [self.backgroundImage drawAsPatternInRect:rect];
    }
    else if (self.backgroundColor)
    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        if (self.style == OPTabBarStyleFlat)
        {
            [self.backgroundColor set];
            CGContextFillRect(c, rect);
            self.backgroundView.hidden = YES;
        }
        else if (self.style == OPTabBarStyleGloss)
        {
            [self.backgroundColor set];
            CGContextFillRect(c, rect);
            
            [$WAf(1.0f,0.1f) set];
            CGContextFillRect(c, CGRectMake(0.0f, 0.0f, rect.size.width, roundf(rect.size.height/2.0f)));
            
            self.backgroundView.hidden = YES;
        }
        else if (self.style == OPTabBarStyleGradient)
        {
            self.backgroundView.hidden = NO;
            self.backgroundView.gradientLayer.colors = $array((id)[self.backgroundColor lighten:0.15f].CGColor,
                                                              (id)[self.backgroundColor darken:0.15f].CGColor);
        }
    }
}

#pragma mark -
#pragma mark === Item management methods ===
#pragma mark -

-(void) setItems:(NSArray *)i {
    
    for (UIControl *item in self.items) {
        [item removeTarget:self action:@selector(tabBarItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [item removeFromSuperview];
    }
    
    items = i;
    
    for (UIControl *item in self.items)
    {
        if (! [item isKindOfClass:[OPTabBarItem class]]) {
            DLog(@"---------------------------------------------------");
            DLog(@"OPTabBar Error:");
            DLog(@"Cannot add item that is not of type `OPTabBarItem`.");
            DLog(@"---------------------------------------------------");
        }
        
        item.height = self.height;
        item.autoresizingMask |= UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:item];
        [self setItemDistribution:self.itemDistribution];
        
        [item addTarget:self action:@selector(tabBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -
#pragma mark === Custom getters/setters ===
#pragma mark -

-(void) setShadowHeight:(CGFloat)h {
    shadowHeight = h;
    self.shadowView.hidden = h <= 0.0f;
    [self setNeedsLayout];
}

-(void) setShadowAlphaStops:(NSArray*)stops {
    
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[stops count]];
    for (NSNumber *stop in stops)
        [colors addObject:(id)$WAf(0.0f, [stop floatValue]).CGColor];
    self.shadowView.gradientLayer.colors = colors;
}

-(void) setItemDistribution:(OPTabBarItemDistribution)d {
    [self setItemDistribution:d animated:NO];
}

-(void) setItemDistribution:(OPTabBarItemDistribution)d animated:(BOOL)animated {
    
    itemDistribution = d;
    if (d == OPTabBarItemDistributionEvenlySpaced)
    {
        [UIView animateWithDuration:(0.3f * animated) animations:^{
            
            CGFloat space = self.width / [self.items count];
            [self.items enumerateObjectsUsingBlock:^(OPTabBarItem *item, NSUInteger idx, BOOL *stop) {
                
                item.frame = CGRectMake(roundf(space * (0.5f + idx) - item.width/2.0f), 
                                        item.top, item.width, item.height);
                
                // use flexible margins to keep the items evenly distributioned in the tab bar
                item.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
                
            }];
        }];
    }
    else if (d == OPTabBarItemDistributionCenterGrouped)
    {
        [UIView animateWithDuration:(0.3f * animated) animations:^{
            
            CGFloat space = 0.0f;
            for (OPTabBarItem *item in self.items)
                space += item.width;
            __block CGFloat offset = 0.0f;
            
            [self.items enumerateObjectsUsingBlock:^(OPTabBarItem *item, NSUInteger idx, BOOL *stop) {
                
                item.frame = CGRectMake(roundf(self.width/2.0f - space/2.0f + offset),
                                        item.top, item.width, item.height);
                offset += item.width;
                
                // remove flexible margins so that the items remain grouped in the middle of the tab bar
                item.autoresizingMask &= ~(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
                
            }];
        }];
    }
}

#pragma mark -
#pragma mark === UIView drawing methods ===
#pragma mark -

-(void) layoutSubviews {
    [super layoutSubviews];
    self.shadowView.frame = CGRectMake(0.0f, -self.shadowHeight, self.width, self.shadowHeight);
}

#pragma mark -
#pragma mark === OPView Overriden methods ===
#pragma mark -

-(void) addFrontDrawingBlock:(OPViewDrawingBlock)block {
    [self.overlayView addFrontDrawingBlock:block];
}

-(void) addBackDrawingBlock:(OPViewDrawingBlock)block {
    [self.overlayView addBackDrawingBlock:block];
}

#pragma mark -
#pragma mark === Interface actions ===
#pragma mark -

-(void) tabBarButtonPressed:(UIButton*)sender {
    
    for (UIControl *item in self.items)
        item.selected = NO;
    sender.selected = YES;
}

@end
