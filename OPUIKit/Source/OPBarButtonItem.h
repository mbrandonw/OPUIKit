//
//  OPBarButtonItem.h
//  OPUIKit
//
//  Created by Brandon Williams on 5/29/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPStyleProtocol.h"

@class OPButton;

@interface OPBarButtonItem : UIBarButtonItem <OPStyleProtocol>

@property (nonatomic, strong, readonly) OPButton *button;

/**
 Helper create method.
 */
//+(id) buttonWithTitle:(NSString*)title;
//+(id) buttonWithIcon:(UIImage*)icon;
//+(id) buttonWithGlyphish:(NSString*)glyph;

@end
