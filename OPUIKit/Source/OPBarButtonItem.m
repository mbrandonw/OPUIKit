
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
    
    // applying styles
    [[[self class] styling] applyTo:self];
    
    [self.button addDrawingBlock:[OPView drawingBlockWithOptions:$dict(OPViewDrawingBaseColorKey, $RGBi(46,169,232),
                                                                       OPViewDrawingGradientAmountKey, $float(0.2f),
                                                                       OPViewDrawingBorderColorKey, [UIColor colorWithWhite:0.0f alpha:0.75f],
                                                                       OPViewDrawingCornerRadiusKey, $float(4.0f),
                                                                       OPViewDrawingBevelKey, $bool(YES))]
                        forState:UIControlStateNormal];
    
    [self.button addDrawingBlock:[OPView drawingBlockWithOptions:$dict(OPViewDrawingBaseColorKey, [$RGBi(9, 130, 191) darken:0.5f],
                                                                       OPViewDrawingGradientAmountKey, $float(0.3f),
                                                                       OPViewDrawingBorderColorKey, [UIColor colorWithWhite:0.0f alpha:0.75f],
                                                                       OPViewDrawingCornerRadiusKey, $float(4.0f),
                                                                       OPViewDrawingBevelKey, $bool(YES))]
                        forState:UIControlStateSelected];
    
    [self.button addEventHandler:^(id sender) {
        
        DLog(@"");
        
    } forControlEvents:UIControlEventTouchUpInside];
    
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
    self.button.height = UIInterfaceOrientationIsPortrait(orientation) ? 24.0f : 30.0f;
    [self.button setNeedsDisplay];
    
}

@end
