
//
//  OPViewController.m
//  CloudAssassin
//
//  Created by Brandon Williams on 6/13/11.
//  Copyright 2011 Hashable. All rights reserved.
//

#import "OPViewController.h"
#import "UIViewController+Opetopic.h"
#import "UIViewController+OPUIKit.h"
#import "OPMacros.h"

@implementation OPViewController

@synthesize backgroundColor = _backgroundColor;
@synthesize backgroundImage = _backgroundImage;
@synthesize defaultTitle = _defaultTitle;
@synthesize defaultSubtitle = _defaultSubtitle;
@synthesize defaultTitleImage = _defaultTitleImage;
@synthesize titleFont = _titleFont;
@synthesize subtitleFont = _subtitleFont;
@synthesize titleColor = _titleColor;
@synthesize titleShadowColor = _titleShadowColor;
@synthesize titleShadowOffset = _titleShadowOffset;

#pragma mark -
#pragma mark Object lifecycle
#pragma mark -

-(id) init {
	if (! (self = [super init]))
		return nil;
	
    // apply stylings
    [[self styling] applyTo:self];
	
    if (self.defaultTitleImage)
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:self.defaultTitleImage];
    if (self.defaultTitle)
        [self setTitle:self.defaultTitle subtitle:self.defaultSubtitle];
    
	return self;
}

#pragma mark -
#pragma mark View lifecycle
#pragma mark -

-(void) loadView {
    [super loadView];
    
    // default the background color if the view doesn't already have one
	if (self.backgroundImage)
		self.view.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
    else if (self.backgroundColor)
        self.view.backgroundColor = self.backgroundColor;
    else
        self.view.backgroundColor = [UIColor whiteColor];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (OP_VIEW_CONTROLLER_SIMULATE_MEMORY_WARNINGS)
        [self simulateMemoryWarning];
    DLog(@"%@", OPCoalesce(self.title, NSStringFromClass([self class])));
}

@end
