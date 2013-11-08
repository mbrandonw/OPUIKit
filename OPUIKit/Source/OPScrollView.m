//
//  OPScrollView.m
//  Kickstarter
//
//  Created by Brandon Williams on 10/27/13.
//  Copyright (c) 2013 Kickstarter. All rights reserved.
//

#import "OPScrollView.h"

@interface _OPScrollContentContainerView : UIView
@end

@interface OPScrollView (/**/)
@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong) NSString *lastContentSizeCategory;
-(void) configureForCurrentContentSizeCategory;
+(void) configureForCurrentContentSizeCategory;
@end

@implementation OPScrollView

+(void) initialize {
  [[self class] configureForCurrentContentSizeCategory];
}

-(id) initWithFrame:(CGRect)frame {
  if (! (self = [super initWithFrame:frame])) {
    return nil;
  }

  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
  }

  return self;
}

-(void) dealloc {
  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
  }

  self.delegate = nil;
}

-(void) willMoveToSuperview:(UIView *)newSuperview {
  [self configureForCurrentContentSizeCategory];
}

#pragma mark -
#pragma mark Content view methods
#pragma mark -

-(void) setUsesContentView:(BOOL)usesContentView {
  _usesContentView = usesContentView;
  if (_usesContentView) {
    self.contentView = self.contentView ?: [[_OPScrollContentContainerView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, self.contentInset)];
    [self insertSubview:self.contentView atIndex:0];
  } else {
    [self.contentView removeFromSuperview];
    self.contentView = nil;
  }
}

-(void) setContentInset:(UIEdgeInsets)contentInset {
  self.contentView.height += self.contentInset.top + self.contentInset.bottom;
  [super setContentInset:contentInset];
  self.contentView.height -= self.contentInset.top + self.contentInset.bottom;
}

#pragma mark -
#pragma mark Preferred content size methods
#pragma mark -

-(void) configureForContentSizeCategory:(NSString*)category {
}

+(void) configureForContentSizeCategory:(NSString*)category {
}

#pragma mark -
#pragma mark Notification methods
#pragma mark -

-(void) preferredContentSizeChanged:(NSNotification*)notification {
  [[self class] configureForCurrentContentSizeCategory];
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
    [self configureForContentSizeCategory:currentContentSizeCategory];
  }
}

+(void) configureForCurrentContentSizeCategory {
  static NSMutableDictionary *lastContentSizeCategoryByClass = nil;
  lastContentSizeCategoryByClass = lastContentSizeCategoryByClass ?: [NSMutableDictionary new];

  NSString *classString = NSStringFromClass(self.class);
  NSString *currentContentSizeCategory = nil;
  NSString *lastContentSizeCategory = lastContentSizeCategoryByClass[classString];

  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    currentContentSizeCategory = [[UIApplication sharedApplication] preferredContentSizeCategory];
  }

  if (! currentContentSizeCategory || ! [lastContentSizeCategory isEqualToString:currentContentSizeCategory]) {
    lastContentSizeCategoryByClass[classString] = currentContentSizeCategory ?: @"";
    [[self class] configureForContentSizeCategory:currentContentSizeCategory];
  }
}

@end

@implementation _OPScrollContentContainerView

-(void) layoutSubviews {
  [super layoutSubviews];
  UIScrollView *scrollView = [self.superview typedAs:[UIScrollView class]];
  CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  scrollView.contentSizeHeight = MAX(height, scrollView.height - scrollView.contentInsetTop - scrollView.contentInsetBottom + 1.0f);
}

@end
