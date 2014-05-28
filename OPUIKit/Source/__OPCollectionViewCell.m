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
@end

@implementation __OPCollectionViewCell

-(id) initWithFrame:(CGRect)frame {
  if (! (self = [super initWithFrame:frame])) {
    return nil;
  }

  self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  return self;
}

-(void) layoutSubviews {
  [super layoutSubviews];
  self.cellView.frame = UIEdgeInsetsInsetRect(self.contentView.bounds, self.contentEdgeInsets);
}

-(void) setCellViewClass:(Class)cellViewClass {
  if (_cellViewClass != cellViewClass) {
    _cellViewClass = cellViewClass;

    [self.cellView removeFromSuperview];
    self.cellView = [[_cellViewClass alloc] initWithFrame:self.contentView.bounds];
    self.cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.cellView];
  }
}

-(void) setCellView:(UIView *)cellView {
  [_cellView removeFromSuperview];
  _cellView = cellView;
  [self.contentView addSubview:_cellView];
}

-(void) prepareForReuse {
  [self traverseSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(prepareForReuse)]) {
      [subview prepareForReuse];
    }
  }];
}

@end
