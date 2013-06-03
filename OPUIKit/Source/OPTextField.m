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
  [self.placeholderTextColor setFill];
  [self.placeholder drawInRect:rect
                      withFont:self.font
                 lineBreakMode:UILineBreakModeTailTruncation
                     alignment:self.textAlignment];
}

@end
