//
//  OPTableSectionView.m
//  Kickstarter
//
//  Created by Brandon Williams on 8/24/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import "OPTableSectionView.h"

@implementation OPTableSectionView

+(CGFloat) heightForWidth:(CGFloat)width {
  return 22.0f;
}

-(void) drawRect:(CGRect)rect {
  [super drawRect:rect];
  [self drawRect:rect context:UIGraphicsGetCurrentContext()];
}

-(void) drawRect:(CGRect)rect context:(CGContextRef)c {
}

-(void) setObject:(id)object {
  _object = object;
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

@end
