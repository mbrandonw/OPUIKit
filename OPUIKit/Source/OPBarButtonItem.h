//
//  OPBarButtonItem.h
//  OPUIKit
//
//  Created by Brandon Williams on 5/29/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPBarButtonItem : UIBarButtonItem

@property (nonatomic, strong, readonly) UIButton *backingButton;

// styling methods
+(void) setDefaultBackgroundImage:(UIImage*)image;
+(void) setDefaultBackgroundDownStateImage:(UIImage*)image;
+(void) setDefaultBackBackgroundImage:(UIImage*)image;
+(void) setDefaultBackBackgroundDownStateImage:(UIImage*)image;
+(BOOL) hasDefaultBackBackgroundImage;
+(void) setDefaultTextColor:(UIColor*)color;
+(void) setDefaultShadowColor:(UIColor*)color;
+(void) setDefaultShadowOffset:(CGSize)offset;

// initialization methods
+(id) defaultButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+(id) defaultButtonWithIcon:(UIImage *)icon target:(id)target action:(SEL)action;
+(id) defaultBackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+(id) defaultButtonWithGlyphishIcon:(NSString*)character target:(id)target action:(SEL)action;

+(id) buttonWithBackgroundImage:(UIImage*)image downStateImage:(UIImage*)downStateImage title:(NSString*)title target:(id)target action:(SEL)action;
+(id) buttonWithBackgroundImage:(UIImage*)image downStateImage:(UIImage*)downStateImage icon:(UIImage*)icon target:(id)target action:(SEL)action;


@end
