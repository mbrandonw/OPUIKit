//
//  __OPTableViewCell.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/3/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "__OPTableViewCell.h"

@interface __OPTableViewCell (/**/)
@property (nonatomic, strong, readwrite) UIView *cellView;
@end

@implementation __OPTableViewCell

-(id) initWithViewClass:(Class)viewClass reuseIdentifier:(NSString *)reuseIdentifier {
  if (! (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
    return nil;
  }

  self.cellView = [[viewClass alloc] initWithFrame:self.contentView.bounds];
  self.cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.contentView addSubview:self.cellView];

  self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  return self;
}

@end
