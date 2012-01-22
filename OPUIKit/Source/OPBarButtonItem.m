
//
//  OPBarButtonItem.m
//  OPUIKit
//
//  Created by Brandon Williams on 5/29/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import "OPBarButtonItem.h"
#import "OPStyle.h"
#import "OPButton.h"
#import "OPControl.h"
#import "UIColor+Opetopic.h"
#import "UIView+Opetopic.h"
#import "OPGradient.h"
#import "OPView.h"
#import "NSDictionary+Opetopic.h"
#import "NSNumber+Opetopic.h"
#import "UIDevice+Opetopic.h"

@interface OPBarButtonItem (/**/)
@property (nonatomic, strong, readwrite) UIButton *button;
@end

@implementation OPBarButtonItem

@synthesize button;

// Storage for supported OPStyle
@synthesize backgroundColor = _backgroundColor;

-(id) init {
    if (! (self = [super init]))
        return nil;
    
    // init button custom view
    self.button = [OPButton buttonWithType:UIButtonTypeCustom];
    self.button.size = CGSizeMake(50.0f, 30.0f);
    self.button.layer.contentsScale = [UIScreen mainScreen].scale;
    self.customView = self.button;
    
    // gotta be able to respond to orientation changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    // apply styles
    [[[self class] styling] applyTo:self];
    
    return self;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark -
#pragma Notification methods
#pragma mark -

-(void) orientationChanged:(NSNotification*)notification {
    
    UIInterfaceOrientation orientation = [[notification.userInfo objectForKey:UIApplicationStatusBarOrientationUserInfoKey] intValue];
    self.button.height = [UIDevice isPad] || UIInterfaceOrientationIsLandscape(orientation) ? 30.0f : 24.0f;
    [self.button setNeedsDisplay];
    
}

@end
