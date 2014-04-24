//
//  OPTextField.m
//  OPUIKit
//
//  Created by Brandon Williams on 6/2/13.
//  Copyright (c) 2013 Opetopic. All rights reserved.
//

#import "OPTextField.h"

@implementation OPTextField

-(void) drawPlaceholderInRect:(CGRect)rect {

  NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
  style.alignment = self.textAlignment;

  [self.placeholder drawInRect:rect
                withAttributes:@{NSFontAttributeName: self.font,
                                 NSParagraphStyleAttributeName: style,
                                 NSForegroundColorAttributeName: self.placeholderTextColor}];

}

@end
