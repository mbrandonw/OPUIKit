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

typedef NS_ENUM(NSInteger, OPBarButtonItemSide) {
  OPBarButtonItemSideLeft,
  OPBarButtonItemSideRight,
};

@interface OPBarButtonItem : UIBarButtonItem <OPStyleProtocol>

@property (nonatomic, strong, readonly) OPButton *button;

@property (nonatomic, assign, getter = isFlush) BOOL flush;

/**
 Helper create methods.
 */
+(id) buttonWithTitle:(NSString*)title target:(id)target action:(SEL)action;
+(id) buttonWithIcon:(UIImage*)icon target:(id)target action:(SEL)action;
+(id) buttonWithGlyphish:(NSString*)glyph target:(id)target action:(SEL)action;
+(id) buttonWithSymbolSet:(NSString*)symbol target:(id)target action:(SEL)action;
+(id) buttonWithSymbolSet:(NSString*)symbol size:(CGFloat)size target:(id)target action:(SEL)action;

/**
 Adding actions to bar buttons (this just forwards to the underlying OPButton).
 */
-(void) addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
