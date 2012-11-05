//
//  OPTableSectionView.h
//  Kickstarter
//
//  Created by Brandon Williams on 8/24/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPTableSectionView : UIView

@property (nonatomic, strong) id object;

+(CGFloat) heightForWidth:(CGFloat)width;

@end
