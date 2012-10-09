
//
//  OPViewController.m
//  CloudAssassin
//
//  Created by Brandon Williams on 6/13/11.
//  Copyright 2011 Hashable. All rights reserved.
//

#import "OPViewController.h"
#import "UIView+Opetopic.h"
#import "UIViewController+Opetopic.h"
#import "UIViewController+OPUIKit.h"
#import "OPMacros.h"
#import "Quartz+Opetopic.h"

const struct OPViewControllerNotifications OPViewControllerNotifications = {
	.viewDidLoad = @"viewDidLoad",
	.viewWillAppear = @"viewWillAppear",
	.viewDidAppear = @"viewDidAppear",
	.viewWillDisappear = @"viewWillDisappear",
	.viewDidDisappear = @"viewDidDisappear",
};

@implementation OPViewController

// OPStyle storage
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
	
	return self;
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    DLogClassAndMethod();
}

#pragma mark -
#pragma mark View lifecycle
#pragma mark -

-(void) viewDidLoad {
    [super viewDidLoad];
    DLogClassAndMethod();
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewDidLoad object:self];
    
    // default the background color if the view doesn't already have one
	if (self.backgroundImage)
    {
        if (! CGSizeIsPowerOfTwo(self.backgroundImage.size)) {
            DLog(@"==============================================================");
            DLog(@"Pattern image drawing is most efficient with power of 2 images");
            DLog(@"==============================================================");
        }
		self.view.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
    }
    else if (self.backgroundColor)
        self.view.backgroundColor = self.backgroundColor;
    else
        self.view.backgroundColor = [UIColor whiteColor];
    
    // set the default navigation item title view
    if (self.defaultTitleImage && !self.navigationItem.titleView)
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:self.defaultTitleImage];
    if (self.defaultTitle && !self.title)
        [self setTitle:self.defaultTitle subtitle:self.defaultSubtitle];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewWillAppear object:self];
    [self.toolbarView bringToFront];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewDidAppear object:self];
    [self.toolbarView bringToFront];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewWillDisappear object:self];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewDidDisappear object:self];
}

-(void) viewDidLayoutSubviews {
    
    [self.toolbarView bringToFront];
    self.toolbarView.bottom = self.view.height;
}

-(void) setToolbarView:(UIView *)toolbarView {
    [_toolbarView removeFromSuperview];
    _toolbarView = toolbarView;
    [self.view addSubview:_toolbarView];
    
    _toolbarView.width = self.view.width;
    _toolbarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
}

@end
