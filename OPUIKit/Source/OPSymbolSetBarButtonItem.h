//
//  OPSymbolSetBarButtonItem.h
//  Kickstarter
//
//  Created by Brandon Williams on 8/30/13.
//  Copyright (c) 2013 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPBarButtonItem.h"

@interface OPSymbolSetBarButtonItem : UIBarButtonItem

-(instancetype) initWithGlyph:(NSString*)glyph side:(OPBarButtonItemSide)side target:(id)target action:(SEL)selector;

@end
