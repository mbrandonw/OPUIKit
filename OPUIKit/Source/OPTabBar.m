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
#import "OPGradient.h"

#import "UIImage+Opetopic.h"
#import "NSArray+Opetopic.h"
#import "UIColor+Opetopic.h"
#import "UIView+Opetopic.h"
#import "NSNumber+Opetopic.h"

#import "OPMacros.h"
#import <QuartzCore/QuartzCore.h>

@interface OPTabBar (/**/)
@property (nonatomic, strong) OPGradientView *shadowView;
-(void) layoutItems;
-(void) tabBarButtonPressed:(OPTabBarItem*)sender;
@end

@implementation OPTabBar

@synthesize delegate = _delegate;

@synthesize backgroundImage = _backgroundImage; // Image that is drawn in the background of the tab bar.
@synthesize style = _style;
@synthesize glossAmount = _glossAmount;
@synthesize shadowHeight = _shadowHeight;

@synthesize items = _items;
@synthesize selectedItem = _selectedItem;
@synthesize selectedItemIndex = _selectedItemIndex;
@synthesize itemDistribution = _itemDistribution;

@synthesize shadowView = _shadowView;

#pragma mark -
#pragma mark Object lifecycle
#pragma mark -

- (id)initWithFrame:(CGRect)frame {
    if (! (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height?frame.size.height:49.0f)]))
        return nil;
    
    // default ivars
    _style = OPTabBarStyleDefault;
    _glossAmount = 0.1f;
    _itemDistribution = OPTabBarItemDistributionDefault;
    
    // init shadow view
    _shadowView = [[OPGradientView alloc] initWithFrame:CGRectZero];
    [self addSubview:_shadowView];
    [self setShadowAlphaStops:$array($float(0.0f), $float(0.3f))];
    
    return self;
}

-(void) drawRect:(CGRect)rect {
    
    if (self.backgroundImage)
    {
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
        }
        else if (self.style == OPTabBarStyleGloss)
        {
            [self.backgroundColor set];
            CGContextFillRect(c, rect);
            
            [$WAf(1.0f,self.glossAmount) set];
            CGContextFillRect(c, CGRectMake(0.0f, 0.0f, rect.size.width, roundf(rect.size.height/2.0f)));
        }
        else if (self.style == OPTabBarStyleGradient)
        {
            [[OPGradient gradientWithColors:$array([self.backgroundColor lighten:0.15f], [self.backgroundColor darken:0.15f])]
             fillRectLinearly:rect];
        }
    }
    
    [super drawRect:rect];
}

#pragma mark -
#pragma mark Item management methods
#pragma mark -

-(void) setItems:(NSArray *)i {
    
    for (UIControl *item in self.items) {
        [item removeTarget:self action:@selector(tabBarItemPressed:) forControlEvents:UIControlEventTouchDown];
        [item removeFromSuperview];
    }
    
    _items = i;
    
    for (UIControl *item in self.items)
    {
        if (! [item isKindOfClass:[OPTabBarItem class]]) {
            DLog(@"---------------------------------------------------");
            DLog(@"OPTabBar Error:");
            DLog(@"Cannot add item that is not of type `OPTabBarItem`.");
            DLog(@"---------------------------------------------------");
        }
        
        item.height = self.height;
        item.autoresizingMask |= (UIViewAutoresizingFlexibleHeight | 
                                  UIViewAutoresizingFlexibleWidth |
                                  UIViewAutoresizingFlexibleLeftMargin | 
                                  UIViewAutoresizingFlexibleRightMargin);
        [self addSubview:item];
        
        [item addTarget:self action:@selector(tabBarButtonPressed:) forControlEvents:UIControlEventTouchDown];
    }
    
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark Custom getters/setters
#pragma mark -

-(void) setShadowHeight:(CGFloat)h {
    _shadowHeight = h;
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
    
    _itemDistribution = d;
    [self setNeedsDisplayAndLayout];
//    [UIView animateWithDuration:(0.3f * animated) animations:^{
//        [self layoutItems];
//    }];
}

-(void) setStyle:(OPTabBarStyle)s {
    _style = s;
    [self setNeedsDisplay];
}

-(void) setSelectedItem:(OPTabBarItem*)selectedItem {
    [self setSelectedItemIndex:[self.items indexOfObject:selectedItem]];
}

-(OPTabBarItem*) selectedItem {
    return [self.items objectAtIndex:self.selectedItemIndex];
}

-(void) setSelectedItemIndex:(NSUInteger)selectedItemIndex {
    _selectedItemIndex = selectedItemIndex;
    
    [self.items enumerateObjectsUsingBlock:^(OPTabBarItem *item, NSUInteger idx, BOOL *stop) {
        if (idx != selectedItemIndex)
            item.selected = NO;
    }];
    
    self.selectedItem.selected = YES;
}

#pragma mark -
#pragma mark UIView drawing methods
#pragma mark -

-(void) layoutSubviews {
    [super layoutSubviews];
    [self layoutItems];
    self.shadowView.frame = CGRectMake(0.0f, -self.shadowHeight, self.width, self.shadowHeight);
}

#pragma mark -
#pragma mark Overridden UIView methods
#pragma mark -

-(void) setNeedsLayout {
    [super setNeedsLayout];
    for (OPTabBarItem *item in self.items)
        [item setNeedsLayout];
}

-(void) setNeedsDisplay {
    [super setNeedsDisplay];
    for (OPTabBarItem *item in self.items)
        [item setNeedsDisplay];
}

#pragma mark -
#pragma mark Interface actions
#pragma mark -

-(void) tabBarButtonPressed:(OPTabBarItem*)sender {
    
    [self setSelectedItem:sender];
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItem:atIndex:)])
        [self.delegate tabBar:self didSelectItem:sender atIndex:self.selectedItemIndex];
}

#pragma mark -
#pragma mark Private methods
#pragma mark -

-(void) layoutItems {
    
    if (self.itemDistribution == OPTabBarItemDistributionEvenlySpaced)
    {
        CGFloat space = self.width / [self.items count];
        [self.items enumerateObjectsUsingBlock:^(OPTabBarItem *item, NSUInteger idx, BOOL *stop) {
            
            item.frame = CGRectMake(roundf(space * (0.5f + idx) - item.width/2.0f), 
                                    item.top, item.width, item.height);
        }];
    }
    else if (self.itemDistribution == OPTabBarItemDistributionCenterGrouped)
    {
        CGFloat space = 0.0f;
        for (OPTabBarItem *item in self.items)
            space += item.width;
        __block CGFloat offset = 0.0f;
        
        [self.items enumerateObjectsUsingBlock:^(OPTabBarItem *item, NSUInteger idx, BOOL *stop) {
            
            item.frame = CGRectMake(roundf(self.width/2.0f - space/2.0f + offset),
                                    item.top, item.width, item.height);
            offset += item.width;
            
        }];
    }
}


@end
