//
//  OPBarButtonItem.h
//  OPUIKit
//
//  Created by Brandon Williams on 5/29/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlocksKit.h"

@interface OPBarButtonItem : UIBarButtonItem

@property (nonatomic, retain, readonly) UIButton *backingButton;

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
+(id) defaultButtonWithTitle:(NSString *)title handler:(BKSenderBlock)handler;
+(id) defaultButtonWithIcon:(UIImage *)icon handler:(BKSenderBlock)handler;
+(id) defaultBackButtonWithTitle:(NSString *)title handler:(BKSenderBlock)handler;
+(id) defaultButtonWithGlyphishIcon:(NSString*)character handler:(BKSenderBlock)handler;

+(id) buttonWithBackgroundImage:(UIImage*)image downStateImage:(UIImage*)downStateImage title:(NSString*)title handler:(BKSenderBlock)handler;
+(id) buttonWithBackgroundImage:(UIImage*)image downStateImage:(UIImage*)downStateImage icon:(UIImage*)icon handler:(BKSenderBlock)handler;


@end
