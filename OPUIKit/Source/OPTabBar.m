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
-(void) tabBarButtonPressed:(OPTabBarItem*)sender;
-(void) layoutTabBarItems;
@end

@implementation OPTabBar

@synthesize delegate = _delegate;

@synthesize items = _items;
@synthesize selectedItem = _selectedItem;
@synthesize selectedItemIndex = _selectedItemIndex;
@synthesize itemLayout = _itemLayout;
@synthesize maxItemWidth = _maxItemWidth;
@synthesize shadowView = _shadowView;

// Supported OPStyle storage
@synthesize backgroundImage = _backgroundImage;
@synthesize glossAmount = _glossAmount;
@synthesize glossOffset = _glossOffset;
@synthesize gradientAmount = _gradientAmount;
@synthesize shadowHeight = _shadowHeight;
@synthesize shadowColors = _shadowColors;

#pragma mark -
#pragma mark Object lifecycle
#pragma mark -

- (id)initWithFrame:(CGRect)frame {
    if (! (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height?frame.size.height:49.0f)]))
        return nil;
    
    // default ivars
    _maxItemWidth = CGFLOAT_MAX;
    _itemLayout = OPTabBarItemLayoutDefault;
    
    // init shadow view
    _shadowView = [[OPGradientView alloc] initWithFrame:CGRectZero];
    [self addSubview:_shadowView];
    
    // apply stylings
    [[[self class] styling] applyTo:self];
    
    return self;
}

#pragma mark -
#pragma mark Item management methods
#pragma mark -

-(void) setItems:(NSArray *)items {
    [self setItems:items animated:NO];
}

-(void) setItems:(NSArray*)items animated:(BOOL)animated {
    [self setItems:items animated:animated completion:nil];
}

-(void) setItems:(NSArray*)items animated:(BOOL)animated completion:(void(^)(void))completion {
    
    NSTimeInterval time = 0.3f*animated*([self.items count]>0);
    
    void(^animationBlock)(void) = ^{
        
        for (OPTabBarItem *item in self.items)
        {
            if (! [items containsObject:item])
                item.left = -item.width;
        }
    };
    
    void(^completionBlock)(BOOL finished) = ^(BOOL finished){
        
        // remove previous items
        for (OPTabBarItem *item in self.items)
        {
            if (! [items containsObject:item])
            {
                [item removeFromSuperview];
            }
        }
        
        // add new items
        for (OPTabBarItem *item in items) {
            if (! [self.items containsObject:item])
            {
                item.height = self.height;
                item.autoresizingMask |= (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |
                                          UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
                [self addSubview:item];
                [item addTarget:self action:@selector(tabBarButtonPressed:) forControlEvents:UIControlEventTouchDown];
            }
        }
        
        NSArray *_originalItems = [_items copy];
        _items = [items copy];
        
        for (OPTabBarItem *item in self.items) {
            if ([_originalItems containsObject:item])
            {
                [UIView animateWithDuration:time animations:^{
                    [self layoutTabBarItem:item];
                }];
            }
            else
            {
                [self layoutTabBarItem:item];
                item.left = self.width;
                [UIView animateWithDuration:time animations:^{
                    [self layoutTabBarItem:item];
                }];
            }
        }
        
        if (self.selectedItemIndex < [self.items count])
            self.selectedItemIndex = self.selectedItemIndex;
        else if ([self.items count] > 0)
            self.selectedItemIndex = 0;
        
        [self setNeedsDisplayAndLayout];
        
        if (completion) completion();
    };
    
    if (time > 0.0f)
        [UIView animateWithDuration:time animations:animationBlock completion:completionBlock];
    else {
        animationBlock();
        completionBlock(YES);
    }
}

#pragma mark -
#pragma mark Custom getters/setters
#pragma mark -

-(void) setGlossAmount:(CGFloat)glossAmount {
    _glossAmount = glossAmount;
    [self setNeedsDisplay];
}

-(void) setGlossOffset:(CGFloat)glossOffset {
    _glossOffset = glossOffset;
    [self setNeedsDisplay];
}

-(void) setGradientAmount:(CGFloat)gradientAmount {
    _gradientAmount = gradientAmount;
    [self setNeedsDisplay];
}

-(void) setShadowHeight:(CGFloat)h {
    _shadowHeight = h;
    self.shadowView.hidden = h <= 0.0f;
    [self setNeedsLayout];
}

-(void) setShadowColors:(NSArray *)shadowColors {
    _shadowColors = shadowColors;
    self.shadowView.gradientLayer.colors = shadowColors;
}

-(void) setItemLayout:(OPTabBarItemLayout)l {
    _itemLayout = l;
    [self setNeedsDisplayAndLayout];
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
        if (idx != selectedItemIndex && item.selected)
            item.selected = NO;
    }];
    
    if (! self.selectedItem.selected)
        self.selectedItem.selected = YES;
}

#pragma mark -
#pragma mark UIView drawing methods
#pragma mark -

-(void) drawRect:(CGRect)rect {
    
    // draw background images & colors
    if (self.backgroundImage)
    {
        // figure out if we need to draw a stretchable image or a pattern image
        if ([self.backgroundImage isStretchableImage])
            [self.backgroundImage drawInRect:rect];
        else
            [self.backgroundImage drawAsPatternInRect:rect];
    }
    if (self.backgroundColor)
    {
        [[OPGradient gradientWithColors:$array([self.backgroundColor lighten:self.gradientAmount], self.backgroundColor, [self.backgroundColor darken:self.gradientAmount])]
         fillRectLinearly:rect];
        
    }
    
    // apply gloss over everything
    if (self.glossAmount)
    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        [$WAf(1.0f,self.glossAmount) set];
        CGContextFillRect(c, CGRectMake(0.0f, 0.0f, rect.size.width, roundf(rect.size.height/2.0f + self.glossOffset)));
    }
    
    [super drawRect:rect];
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    // keep shadow up at the top
    self.shadowView.frame = CGRectMake(0.0f, -self.shadowHeight, self.width, self.shadowHeight);
    
    // layout the tab bar items
    [self layoutTabBarItems];
}

-(void) layoutTabBarItems {
    
    for (OPTabBarItem *item in self.items)
        [self layoutTabBarItem:item];
}

-(void) layoutTabBarItem:(OPTabBarItem*)item {
    
    NSUInteger index = [self.items indexOfObject:item];
    
    if (self.itemLayout == OPTabBarItemLayoutEvenlySpaced)
    {
        CGFloat itemWidth = roundf(self.width / [self.items count]);
        item.frame = CGRectMake(roundf(itemWidth * (0.5f + index) - itemWidth/2.0f), item.top, itemWidth, item.height);
    }
    else if (self.itemLayout == OPTabBarItemLayoutCenterGrouped)
    {
        CGFloat neededSpace = 0.0f;
        for (OPTabBarItem *item in self.items)
            neededSpace += MIN(self.maxItemWidth, item.width);
        CGFloat itemWidth = roundf(neededSpace / [self.items count]);
        __block CGFloat offset = index * MIN(self.maxItemWidth, itemWidth);
        
        item.frame = CGRectMake(roundf(self.width/2.0f - neededSpace/2.0f + offset), item.top, MIN(self.maxItemWidth, itemWidth), item.height);
    }
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

@end
