//
//  OPBarButtonItem.m
//  OPUIKit
//
//  Created by Brandon Williams on 5/29/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import "OPBarButtonItem.h"
#import "UIView+Opetopic.h"

#pragma mark Styling vars
static UIImage *OPBarButtonItemDefaultBackgroundImage;
static UIImage *OPBarButtonItemDefaultBackgroundDownStateImage;
static UIImage *OPBarButtonItemDefaultBackBackgroundImage;
static UIImage *OPBarButtonItemDefaultBackBackgroundDownStateImage;
static UIColor *OPBarButtonItemDefaultTextColor;
static UIColor *OPBarButtonItemDefaultShadowColor;
static CGSize OPBarButtonItemDefaultShadowOffset;
#pragma mark -

@interface OPBarButtonItem (/**/)
@property (nonatomic, retain, readwrite) UIButton *backingButton;
@end

@implementation OPBarButtonItem

@synthesize backingButton;

#pragma mark Styling methods
+(void) setDefaultBackgroundImage:(UIImage *)image {
	OPBarButtonItemDefaultBackgroundImage = image;
}

+(void) setDefaultBackgroundDownStateImage:(UIImage *)image {
    OPBarButtonItemDefaultBackgroundDownStateImage = image;
}

+(void) setDefaultBackBackgroundImage:(UIImage *)image {
	OPBarButtonItemDefaultBackBackgroundImage = image;
}

+(void) setDefaultBackBackgroundDownStateImage:(UIImage *)image {
    OPBarButtonItemDefaultBackBackgroundDownStateImage = image;
}

+(BOOL) hasDefaultBackBackgroundImage {
    return OPBarButtonItemDefaultBackBackgroundImage != nil;
}

+(void) setDefaultTextColor:(UIColor*)color {
	OPBarButtonItemDefaultTextColor = color;
}

+(void) setDefaultShadowColor:(UIColor*)color {
	OPBarButtonItemDefaultShadowColor = color;
}

+(void) setDefaultShadowOffset:(CGSize)offset {
    OPBarButtonItemDefaultShadowOffset = offset;
}
#pragma mark -


#pragma mark Initialization methods
+(id) defaultButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    
	return [self buttonWithBackgroundImage:OPBarButtonItemDefaultBackgroundImage
                            downStateImage:OPBarButtonItemDefaultBackgroundDownStateImage
                                     title:title 
                                   target:target 
                                    action:action];
}

+(id) defaultButtonWithIcon:(UIImage *)icon target:(id)target action:(SEL)action {
    
	return [self buttonWithBackgroundImage:OPBarButtonItemDefaultBackgroundImage 
                            downStateImage:OPBarButtonItemDefaultBackgroundDownStateImage
                                      icon:icon 
                                    target:target
                                    action:action];
}

+(id) defaultBackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
	
	OPBarButtonItem *retVal = [self buttonWithBackgroundImage:OPBarButtonItemDefaultBackBackgroundImage
                                               downStateImage:OPBarButtonItemDefaultBackgroundDownStateImage
                                                        title:title 
                                                       target:target
                                                       action:action];
    [retVal.backingButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 0.0f)];
    return retVal;
}

+(id) defaultButtonWithGlyphishIcon:(NSString*)character target:(id)target action:(SEL)action {
	
	OPBarButtonItem *retVal = [self buttonWithBackgroundImage:OPBarButtonItemDefaultBackgroundImage
                                               downStateImage:OPBarButtonItemDefaultBackgroundDownStateImage 
                                                        title:character 
                                                       target:target 
                                                       action:action];
	
	retVal.backingButton.titleLabel.font = [UIFont fontWithName:@"glyphish" size:34.0f];
	[retVal.backingButton sizeToFit];
	retVal.backingButton.height = 30.0f;
	[retVal.backingButton setTitleEdgeInsets:UIEdgeInsetsMake(8.0f, 0.0f, 0.0f, 0.0f)];
	
    return retVal;
}

+(id) buttonWithBackgroundImage:(UIImage *)image downStateImage:(UIImage *)downStateImage title:(NSString *)title target:(id)target action:(SEL)action {
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:OPBarButtonItemDefaultTextColor forState:UIControlStateNormal];
	[button setTitleShadowColor:OPBarButtonItemDefaultShadowColor forState:UIControlStateNormal];
	button.titleLabel.shadowOffset = OPBarButtonItemDefaultShadowOffset;
	button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	[button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:downStateImage forState:UIControlStateHighlighted];
	[button sizeToFit];
	button.width += 20.0f;
	button.width = MIN(MAX(button.width, 53.0f), 90.0f);
	button.height = 30.0f;
	
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	OPBarButtonItem *barButtonItem = [[self alloc] initWithCustomView:button];
	barButtonItem.backingButton = button;
	return barButtonItem;
}

+(id) buttonWithBackgroundImage:(UIImage*)image downStateImage:(UIImage *)downStateImage icon:(UIImage *)icon target:(id)target action:(SEL)action {
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:downStateImage forState:UIControlStateHighlighted];
	[button setImage:icon forState:UIControlStateNormal];
	button.width = icon.size.width + 20.0f;
	button.height = 30.0f;
	
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
    id barButtonItem = [[self alloc] initWithCustomView:button];
	[(id)barButtonItem setBackingButton:button];
	return barButtonItem;
}

@end
