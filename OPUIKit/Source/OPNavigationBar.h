//
//  OPNavigationBar.h
//  OPUIKit
//
//  Created by Brandon Williams on 12/19/10.
//  Copyright 2010 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPNavigationBar : UINavigationBar

@property (nonatomic, strong) UIColor *barColor;

// styling methods
+(void) setDefaultColor:(UIColor*)color;
+(void) setDefaultTranslucent:(BOOL)translucent;

@end
