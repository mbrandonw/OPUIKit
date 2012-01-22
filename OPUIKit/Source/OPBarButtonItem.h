//
//  OPBarButtonItem.h
//  OPUIKit
//
//  Created by Brandon Williams on 5/29/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPStyleProtocol.h"
#import "OPButton.h"

@interface OPBarButtonItem : UIBarButtonItem <OPStyleProtocol>

@property (nonatomic, strong, readonly) OPButton *button;

/**
 Helper create methods.
 */
+(id) buttonWithTitle:(NSString*)title target:(id)target action:(SEL)action;
+(id) buttonWithIcon:(UIImage*)icon target:(id)target action:(SEL)action;
+(id) buttonWithGlyphish:(NSString*)glyph target:(id)target action:(SEL)action;

/**
 Adding actions to bar buttons (this just forwards to the underlying OPButton).
 */
-(void) addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

/**
 Button geometry methods.
 */
+(CGFloat) heightForOrientation:(UIInterfaceOrientation)orientation;

@end
