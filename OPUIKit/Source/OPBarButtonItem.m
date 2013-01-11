//
//  OPBarButtonItem.m
//  OPUIKit
//
//  Created by Brandon Williams on 5/29/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import "OPBarButtonItem.h"
#import "OPStyle.h"
#import "OPControl.h"
#import "UIColor+Opetopic.h"
#import "UIView+Opetopic.h"
#import "OPGradient.h"
#import "OPView.h"
#import "NSDictionary+Opetopic.h"
#import "NSNumber+Opetopic.h"
#import "UIDevice+Opetopic.h"
#import <QuartzCore/QuartzCore.h>

#define kOPBarButtonItemMinWidth    44.0f
#define kOPBarButtonItemMaxWidth    100.0f
#define kOPBarButtonItemMargin      10.0f

@interface OPBarButtonItem (/**/)
@property (nonatomic, strong, readwrite) OPButton *button;
@end

@implementation OPBarButtonItem

@synthesize button = _button;

#pragma mark -
#pragma mark Object lifecycle
#pragma mark -

-(id) init {
    if (! (self = [super init]))
        return nil;
    
    // init button custom view
    self.button = [OPButton buttonWithType:UIButtonTypeCustom];
    self.button.size = CGSizeMake(0.0f, [self heightForOrientation:[[UIApplication sharedApplication] statusBarOrientation]]);
    self.button.layer.contentsScale = [UIScreen mainScreen].scale;
    self.customView = self.button;
    
    // gotta be able to respond to orientation changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    // apply styles
    [[[self class] styling] applyTo:self];
    
    [self.button setTitleColor:self.button.titleLabel.textColor forState:UIControlStateNormal];
    [self.button setTitleShadowColor:self.button.titleLabel.shadowColor forState:UIControlStateNormal];
    [self.button setTitleColor:self.button.titleLabel.highlightedTextColor forState:UIControlStateHighlighted];
    
    return self;
}

+(id) buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    OPBarButtonItem *item = [[[self class] alloc] init];
    
    [item.button setTitle:title forState:UIControlStateNormal];
    
    CGFloat originalHeight = item.button.height;
    [item.button sizeToFit];
    item.button.height = originalHeight;
    item.button.width += kOPBarButtonItemMargin*2.0f + item.button.titleEdgeInsets.left + item.button.titleEdgeInsets.right;
    item.button.width = MIN(kOPBarButtonItemMaxWidth, MAX(kOPBarButtonItemMinWidth, item.button.width));
    
    [item addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}

+(id) buttonWithIcon:(UIImage*)icon target:(id)target action:(SEL)action {
    
    OPBarButtonItem *item = [[[self class] alloc] init];
    
    [item.button setImage:icon forState:UIControlStateNormal];
    
    CGFloat originalHeight = item.button.height;
    [item.button sizeToFit];
    item.button.height = originalHeight;
    item.button.width += kOPBarButtonItemMargin*2.0f + item.button.titleEdgeInsets.left + item.button.titleEdgeInsets.right;
    item.button.width = MAX(kOPBarButtonItemMinWidth, item.button.width);
    
    [item addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}

+(id) buttonWithGlyphish:(NSString*)glyph target:(id)target action:(SEL)action {
    
    OPBarButtonItem *item = [[self class] buttonWithTitle:glyph target:target action:action];
    item.button.titleLabel.font = [UIFont fontWithName:@"glyphish" size:28.0f];
    item.button.titleEdgeInsets = UIEdgeInsetsMake(6.0f, 1.0f, 0.0f, 0.0f);
    
    CGFloat originalHeight = item.button.height;
    [item.button sizeToFit];
    item.button.height = originalHeight;
    item.button.width = kOPBarButtonItemMinWidth;
    
    [item addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}

+(id) buttonWithSymbolSet:(NSString*)symbol target:(id)target action:(SEL)action {
    return [[self class] buttonWithSymbolSet:symbol size:18.0f target:target action:action];
}

+(id) buttonWithSymbolSet:(NSString*)symbol size:(CGFloat)size target:(id)target action:(SEL)action {

    OPBarButtonItem *item = [[self class] buttonWithTitle:symbol target:target action:action];
    item.button.titleLabel.font = [UIFont fontWithName:@"SS Standard" size:size];
    item.button.titleEdgeInsets = UIEdgeInsetsMake(6.0f, 1.0f, 0.0f, 0.0f);
    
    CGFloat originalHeight = item.button.height;
    [item.button sizeToFit];
    item.button.height = originalHeight;
    item.button.width = kOPBarButtonItemMinWidth;
    
    [item addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark -
#pragma mark Custom getters/setters
#pragma mark -

-(void) setFlush:(BOOL)flush {
    _flush = flush;
    self.button.height = [self heightForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    if (flush) {
        self.button.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
    }
}

#pragma mark -
#pragma mark Actions
#pragma mark -

-(void) addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}

#pragma mark -
#pragma mark Button geometry methods
#pragma mark -

-(CGFloat) heightForOrientation:(UIInterfaceOrientation)orientation {
    
    if (self.flush) {
        return UIInterfaceOrientationIsLandscape(orientation) && ![UIDevice isPad] ? 32.0f : 44.0f;
    }
    
    return UIInterfaceOrientationIsLandscape(orientation) && ![UIDevice isPad] ? 24.0f : 29.0f;
}

#pragma mark -
#pragma Notification methods
#pragma mark -

-(void) orientationChanged:(NSNotification*)notification {
    if ([self.button.titleLabel.font.fontName caseInsensitiveCompare:@"glyphish"] == NSOrderedSame)
    {
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            self.button.titleLabel.font = [UIFont fontWithName:@"glyphish" size:32.0f];
            self.button.titleEdgeInsets = UIEdgeInsetsMake(6.0f, 1.0f, 0.0f, 0.0f);
        }
        else
        {
            self.button.titleLabel.font = [UIFont fontWithName:@"glyphish" size:28.0f];
            self.button.titleEdgeInsets = UIEdgeInsetsMake(4.0f, 1.0f, 0.0f, 0.0f);
        }
    }
    
    self.button.height = [self heightForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    [self.button setNeedsDisplay];
}

@end
