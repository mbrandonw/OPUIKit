//
//  OPTableSectionView.h
//  Kickstarter
//
//  Created by Brandon Williams on 8/24/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import "OPView.h"

@interface OPTableSectionView : OPView

@property (nonatomic, strong) id object;
@property (nonatomic, assign) NSInteger section;

+(CGFloat) heightForWidth:(CGFloat)width;
-(void) drawRect:(CGRect)rect context:(CGContextRef)c;

@end
