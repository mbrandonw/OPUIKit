//
//  OPViewController.m
//  CloudAssassin
//
//  Created by Brandon Williams on 6/13/11.
//  Copyright 2011 Hashable. All rights reserved.
//

#import "OPViewController.h"
#import "UIViewController+Opetopic.h"
#import "OPMacros.h"

#if !defined(OP_VIEW_CONTROLLER_SIMULATE_MEMORY_WARNINGS)
#define OP_VIEW_CONTROLLER_SIMULATE_MEMORY_WARNINGS NO
#endif

#pragma mark Styling vars
static UIColor *defaultBackgroundColor;
static UIColor *defaultTitleTextColor;
static UIColor *defaultTitleShadowColor;
static UIImage *defaultTitleImage;
#pragma mark -

@implementation OPViewController

#pragma mark Styling methods
+(void) setDefaultBackgroundColor:(UIColor*)color {
	defaultBackgroundColor = color;
}

+(void) setDefaultTitleTextColor:(UIColor*)color {
	defaultTitleTextColor = color;
}

+(void) setDefaultTitleShadowColor:(UIColor*)color {
	defaultTitleShadowColor = color;
}

+(void) setDefaultTitleImage:(UIImage*)image {
	defaultTitleImage = image;
}
#pragma mark -


#pragma mark Initialization methods
-(id) initWithTitle:(NSString*)title subtitle:(NSString*)subtitle {
	if (! (self = [self init]))
		return nil;
	
	[self setTitle:title subtitle:subtitle];
	
	return self;
}

-(id) init {
	if (! (self = [super init]))
		return nil;
	
	self.navigationItem.titleView = [[UIImageView alloc] initWithImage:defaultTitleImage];
	
	return self;
}
#pragma mark -


#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (defaultBackgroundColor)
		self.view.backgroundColor = defaultBackgroundColor;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (OP_VIEW_CONTROLLER_SIMULATE_MEMORY_WARNINGS)
        [self simulateMemoryWarning];
    
    DLog(@"%@", COALLESCE(self.title, NSStringFromClass([self class])));
}
#pragma mark -


#pragma mark Titling methods
-(void) setTitle:(NSString *)title {
    [self setTitle:title subtitle:nil];
}

-(void) setTitle:(NSString*)title subtitle:(NSString*)subtitle {
    
    [super setTitle:title];
	
	UIView *wrapper = [[UIView alloc] initWithFrame:CGRectZero];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.text = title;
	titleLabel.textColor = defaultTitleTextColor;
	titleLabel.shadowColor = defaultTitleShadowColor;
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.font = [UIFont boldSystemFontOfSize:subtitle ? 15.0f : 18.0f];
	titleLabel.numberOfLines = 1;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.opaque = NO;
	[titleLabel sizeToFit];
	
	UILabel *subtitleLabel = nil;
	if (subtitle != nil) {
		subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		subtitleLabel.text = subtitle;
		subtitleLabel.textColor = defaultTitleTextColor;
		subtitleLabel.shadowColor = defaultTitleShadowColor;
		subtitleLabel.textAlignment = UITextAlignmentCenter;
		subtitleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		subtitleLabel.numberOfLines = 1;
		subtitleLabel.backgroundColor = [UIColor clearColor];
		subtitleLabel.opaque = NO;
		[subtitleLabel sizeToFit];
	}
	
	CGFloat maxWidth = MAX(titleLabel.frame.size.width, subtitleLabel.frame.size.width);
	wrapper.frame = CGRectMake(0.0, 0.0, maxWidth, 44.0);
	titleLabel.frame = CGRectMake(0.0, (subtitle ? 3.0 : 11.0), maxWidth, 20.0);
	[wrapper addSubview:titleLabel];
	
	if (subtitleLabel) {
		subtitleLabel.frame = CGRectMake(0.0, 21.0, maxWidth, 16.0);
		[wrapper addSubview:subtitleLabel];
	}
	
	self.navigationItem.titleView = wrapper;
}

@end
