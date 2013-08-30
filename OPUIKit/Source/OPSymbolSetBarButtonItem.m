//
//  OPSymbolSetBarButtonItem.m
//  Kickstarter
//
//  Created by Brandon Williams on 8/30/13.
//  Copyright (c) 2013 Kickstarter. All rights reserved.
//

#import "OPSymbolSetBarButtonItem.h"

@implementation OPSymbolSetBarButtonItem

-(instancetype) initWithGlyph:(NSString*)glyph side:(OPBarButtonItemSide)side target:(id)target action:(SEL)selector {
  NSString *title = [NSString stringWithFormat:side == OPBarButtonItemSideLeft ? @"  %@" : @"%@  ", glyph];
  if (! (self = [self initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector])) {
    return nil;
  }

  [self setTitleTextAttributes:@{UITextAttributeFont: [UIFont ssStandardFontWithSize:16.0f]} forState:UIControlStateNormal];

  return self;
}

@end
