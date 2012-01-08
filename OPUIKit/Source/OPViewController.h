//
//  OPViewController.h
//  OPUIKit
//
//  Created by Brandon Williams on 6/13/11.
//  Copyright 2011 Hashable. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OPViewController : UIViewController

// styling methods
+(void) setDefaultBackgroundColor:(UIColor*)color;
+(void) setDefaultTitleTextColor:(UIColor*)color;
+(void) setDefaultTitleShadowColor:(UIColor*)color;
+(void) setDefaultTitleImage:(UIImage*)image;

// initialization methods
-(id) initWithTitle:(NSString*)title subtitle:(NSString*)subtitle;

// titling methods
-(void) setTitle:(NSString*)title subtitle:(NSString*)subtitle;

@end
