//
//  UIViewController+OPUIKit.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/16/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "UIViewController+OPUIKit.h"
#import "OPStyle.h"
#import "OPMacros.h"

@implementation UIViewController (OPUIKit)

-(id) initWithTitle:(NSString*)title subtitle:(NSString*)subtitle {
    if (! (self = [self init]))
        return nil;
    
    [self setTitle:title subtitle:subtitle];
    
    return self;
}

-(void) setTitle:(NSString*)title subtitle:(NSString*)subtitle {
    
    self.title = title;
    
    // get defaults from OPStyle
    UIColor *titleColor = OPCoalesce([self respondsToSelector:@selector(titleColor)] ? [(id<OPStyleProtocol>)self titleColor] : nil, [UIColor whiteColor]);
    UIFont *subtitleFont = OPCoalesce([self respondsToSelector:@selector(subtitleFont)] ? [(id<OPStyleProtocol>)self subtitleFont] : nil, [UIFont boldSystemFontOfSize:13.0f]);
    UIFont *titleFont = OPCoalesce([self respondsToSelector:@selector(titleFont)] ? [(id<OPStyleProtocol>)self titleFont] : nil, [UIFont boldSystemFontOfSize:18.0f]);
    UIColor *titleShadowColor = OPCoalesce([self respondsToSelector:@selector(titleShadowColor)] ? [(id<OPStyleProtocol>)self titleShadowColor] : nil, [UIColor colorWithWhite:0.0f alpha:0.8f]);
    CGFloat titleShadowOffset = [self respondsToSelector:@selector(titleShadowOffset)] ? [(id<OPStyleProtocol>)self titleShadowOffset] : -1.0f;
    
    if (title && subtitle)
        titleFont = [UIFont fontWithName:subtitleFont.fontName size:subtitleFont.pointSize+2.0f];
    
	UIView *wrapper = [[UIView alloc] initWithFrame:CGRectZero];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.text = title;
	titleLabel.textColor = titleColor;
	titleLabel.shadowColor = titleShadowColor;
    titleLabel.shadowOffset = CGSizeMake(0.0f, titleShadowOffset);
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.font = titleFont;
	titleLabel.numberOfLines = 1;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.opaque = NO;
	[titleLabel sizeToFit];
	
	UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	if (subtitle)
    {
		subtitleLabel.text = subtitle;
		subtitleLabel.textColor = titleColor;
		subtitleLabel.shadowColor = titleShadowColor;
        subtitleLabel.shadowOffset = CGSizeMake(0.0f, titleShadowOffset);
		subtitleLabel.textAlignment = UITextAlignmentCenter;
		subtitleLabel.font = subtitleFont;
		subtitleLabel.numberOfLines = 1;
		subtitleLabel.backgroundColor = [UIColor clearColor];
		subtitleLabel.opaque = NO;
		[subtitleLabel sizeToFit];
	}
	
	CGFloat maxWidth = MAX(titleLabel.frame.size.width, subtitleLabel.frame.size.width);
	wrapper.frame = CGRectMake(0.0, 0.0, maxWidth, 44.0);
	titleLabel.frame = CGRectMake(0.0, (subtitle ? 3.0 : 11.0), maxWidth, 20.0);
	[wrapper addSubview:titleLabel];
	
	if (subtitle)
    {
		subtitleLabel.frame = CGRectMake(0.0, 21.0, maxWidth, 16.0);
		[wrapper addSubview:subtitleLabel];
	}
	
	self.navigationItem.titleView = wrapper;
}

@end
