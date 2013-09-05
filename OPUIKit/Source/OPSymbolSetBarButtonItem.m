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
  if (! (self = [self initWithTitle:glyph style:UIBarButtonItemStyleBordered target:target action:selector])) {
    return nil;
  }

  [self setTitleTextAttributes:@{UITextAttributeFont: [UIFont ssStandardFontWithSize:16.0f]} forState:UIControlStateNormal];

  if (side == OPBarButtonItemSideLeft) {
    [self setTitlePositionAdjustment:UIOffsetMake(8.0f, 2.0f) forBarMetrics:UIBarMetricsDefault];
  } else {
    [self setTitlePositionAdjustment:UIOffsetMake(-8.0f, 2.0f) forBarMetrics:UIBarMetricsDefault];
  }

  return self;
}

@end
