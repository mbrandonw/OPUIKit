//
//  __OPCollectionViewCell.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/14/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "__OPCollectionViewCell.h"
#import "UIView+__OPCellView.h"
#import "OPExtensionKit.h"

@interface __OPCollectionViewCell (/**/)
@property (nonatomic, strong, readwrite) UIView *cellView;
@end

@implementation __OPCollectionViewCell

-(id) initWithFrame:(CGRect)frame {
  if (! (self = [super initWithFrame:frame])) {
    return nil;
  }

  self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  return self;
}

-(void) setCellViewClass:(Class)cellViewClass {
  _cellViewClass = cellViewClass;

  [self.cellView removeFromSuperview];
  self.cellView = [[_cellViewClass alloc] initWithFrame:self.contentView.bounds];
  self.cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.contentView addSubview:self.cellView];
}

-(void) prepareForReuse {
  [self traverseSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(prepareForReuse)]) {
      [subview prepareForReuse];
    }
  }];
}

@end
