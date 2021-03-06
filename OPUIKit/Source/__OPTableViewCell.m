//
//  __OPTableViewCell.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/3/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "__OPTableViewCell.h"
#import "UIView+__OPCellView.h"
#import "UIView+Opetopic.h"

@interface __OPTableViewCell (/**/)
@property (nonatomic, strong, readwrite) UIView *cellView;

// helper methods for dealing with content size
@property (nonatomic, strong) NSString *lastContentSizeCategory;
-(void) configureForCurrentContentSizeCategory;
@end

@implementation __OPTableViewCell

-(id) initWithViewClass:(Class)viewClass viewController:(UIViewController*)viewController reuseIdentifier:(NSString *)reuseIdentifier {
  if (! (self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
    return nil;
  }

  self.op_viewController = viewController;
  self.selectionStyle = UITableViewCellSelectionStyleNone;

  self.cellView = [[viewClass alloc] initWithFrame:self.contentView.bounds];
  self.cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.contentView addSubview:self.cellView];

  self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
  }

  [self configureForCurrentContentSizeCategory];

  return self;
}

-(void) dealloc {
  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
  }
}

#pragma mark -
#pragma mark State methods
#pragma mark -

-(void) setSelected:(BOOL)selected animated:(BOOL)animated {
  if (selected != [self isSelected]) {
    [self.cellView setCellIsSelected:selected];
    if ([self.cellView respondsToSelector:@selector(cellWillDisplay)]) {
      [self.cellView cellWillDisplay];
    }
    [self.cellView setNeedsDisplay];
    [self.cellView setNeedsLayout];
  }

  [super setSelected:selected animated:animated];
}

-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  if (highlighted != [self isHighlighted]) {
    [self.cellView setCellIsHighlighted:highlighted];
    if ([self.cellView respondsToSelector:@selector(cellWillDisplay)]) {
      [self.cellView cellWillDisplay];
    }
    [self.cellView setNeedsDisplay];
    [self.cellView setNeedsLayout];
  }

  [super setHighlighted:highlighted animated:animated];
}

#pragma mark -
#pragma mark Content size methods
#pragma mark -

-(void) prepareForReuse {
  [self traverseSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(prepareForReuse)]) {
      [subview prepareForReuse];
    }
  }];
}

#pragma mark -
#pragma mark Content size methods
#pragma mark -

-(void) preferredContentSizeChanged:(NSNotification*)notification {
  [self configureForCurrentContentSizeCategory];
}

#pragma mark -
#pragma mark Private methods
#pragma mark -

-(void) configureForCurrentContentSizeCategory {
  NSString *currentContentSizeCategory = nil;
  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    currentContentSizeCategory = [[UIApplication sharedApplication] preferredContentSizeCategory];
  }

  if (! currentContentSizeCategory || ! [self.lastContentSizeCategory isEqualToString:currentContentSizeCategory]) {
    self.lastContentSizeCategory = currentContentSizeCategory ?: @"";

    if ([self.cellView respondsToSelector:@selector(configureForContentSizeCategory:)]) {
      [self.cellView configureForContentSizeCategory:currentContentSizeCategory];
    }
  }
}

@end
