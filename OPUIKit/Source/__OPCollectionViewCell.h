//
//  __OPCollectionViewCell.h
//  Kickstarter
//
//  Created by Brandon Williams on 1/14/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface __OPCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readwrite) UIView *cellView;
@property (nonatomic, strong) Class cellViewClass;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@end
