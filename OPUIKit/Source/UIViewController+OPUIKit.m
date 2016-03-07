//
//  UIViewController+OPUIKit.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/16/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "UIViewController+OPUIKit.h"
#import "OPExtensionKit.h"
#import "OPTableViewController.h"
#import "OPViewController.h"
#import "OPStyle.h"
#import "OPMacros.h"
#import <objc/runtime.h>

@interface UIViewController (OPUIKit_Private)
-(CGPoint) viewOffset;
@end

@implementation UIViewController (OPUIKit)

-(id) initWithTitle:(NSString*)title subtitle:(NSString*)subtitle {
  if (! (self = [self init])) {
    return nil;
  }

  [self setTitle:title subtitle:subtitle];
  [self setToolbarViewHidden:YES];

  return self;
}

-(void) setTitle:(NSString*)title subtitle:(NSString*)subtitle {

  self.title = title;

  UIColor *titleColor = [UIColor whiteColor];
  UIFont *titleFont = [UIFont boldSystemFontOfSize:18.0f];
  UIFont *subtitleFont = [UIFont boldSystemFontOfSize:13.0f];
  UIColor *titleShadowColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
  CGSize titleShadowOffset = CGSizeZero;

  if ([self isKindOfClass:[OPTableViewController class]] || [self isKindOfClass:[OPViewController class]])
  {
    titleColor = [(id)self titleColor] ?: titleColor;
    titleFont = [(id)self titleFont] ?: titleFont;
    subtitleFont = [(id)self subtitleFont] ?: subtitleFont;
    titleShadowColor = [(id)self titleShadowColor] ?: titleShadowColor;
    titleShadowOffset = [(id)self titleShadowOffset];
  }

  if (title && subtitle)
    titleFont = [UIFont fontWithName:subtitleFont.fontName size:subtitleFont.pointSize+2.0f];

  UIView *wrapper = [[UIView alloc] initWithFrame:CGRectZero];

  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  titleLabel.text = title;
  titleLabel.textColor = titleColor;
  titleLabel.shadowColor = titleShadowColor;
  titleLabel.shadowOffset = titleShadowOffset;
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.font = titleFont;
  titleLabel.numberOfLines = 1;
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.opaque = NO;
  titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [titleLabel sizeToFit];

  UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  if (subtitle)
  {
    subtitleLabel.text = subtitle;
    subtitleLabel.textColor = titleColor;
    subtitleLabel.shadowColor = titleShadowColor;
    subtitleLabel.shadowOffset = titleShadowOffset;
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.font = subtitleFont;
    subtitleLabel.numberOfLines = 1;
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.opaque = NO;
    subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [subtitleLabel sizeToFit];
  }

  CGFloat maxWidth = MAX(titleLabel.frame.size.width, subtitleLabel.frame.size.width);
  wrapper.frame = CGRectMake(0.0, 0.0, maxWidth, 44.0);
  titleLabel.frame = CGRectMake(0.0, (subtitle ? 3.0 : 12.0), maxWidth, 20.0);
  [wrapper addSubview:titleLabel];

  if (subtitle)
  {
    subtitleLabel.frame = CGRectMake(0.0, 21.0, maxWidth, 16.0);
    [wrapper addSubview:subtitleLabel];
  }

  self.navigationItem.titleView = wrapper;
}

-(void) setToolbarView:(UIView*)toolbarView {
  UIView *currToolbarView = objc_getAssociatedObject(self, @selector(toolbarView));
  [currToolbarView removeFromSuperview];
  objc_setAssociatedObject(self, @selector(toolbarView), nil, OBJC_ASSOCIATION_RETAIN);

  objc_setAssociatedObject(self, @selector(toolbarView), toolbarView, OBJC_ASSOCIATION_RETAIN);
  [self.view addSubview:self.toolbarView];

  [self layoutToolbarView];

  [self.parentViewController setToolbarViewHidden:YES animated:YES];
}

-(UIView*) toolbarView {
  UIView *retVal = objc_getAssociatedObject(self, @selector(toolbarView));
  if (! retVal) {
    return [self.parentViewController toolbarView];
  }
  return retVal;
}

-(BOOL) toolbarViewHidden {
  return [objc_getAssociatedObject(self, @selector(toolbarViewHidden)) boolValue];
}

-(void) setToolbarViewHidden:(BOOL)hidden {
  [self setToolbarViewHidden:hidden animated:NO];
}

-(void) setToolbarViewHidden:(BOOL)hidden animated:(BOOL)animated {
  objc_setAssociatedObject(self, @selector(toolbarViewHidden), @(hidden), OBJC_ASSOCIATION_RETAIN);

  if (self.toolbarView) {
    dispatch_after_delay(0.01f, ^{
      [self layoutToolbarView];

      [UIView animateWithDuration:0.3 * animated animations:^{
        self.toolbarView.alpha = hidden ? 0.0f : 1.0f;
        [self layoutToolbarView];
      } completion:^(BOOL finished) {
        [self layoutToolbarView];
      }];

    });
  }
  else
  {
    [self.parentViewController setToolbarViewHidden:hidden animated:YES];
  }
}

-(void) layoutToolbarView {
  [self.toolbarView bringToFront];
  self.toolbarView.frame = (CGRect){
    self.viewOffset.x,
    self.toolbarView.superview.bounds.size.height - self.toolbarView.height + self.viewOffset.y,
    self.toolbarView.superview.bounds.size.width,
    self.toolbarView.height
  };
}

-(CGPoint) viewOffset {
  return [self.toolbarView.superview isKindOfClass:[UIScrollView class]] ? [(UIScrollView*)self.toolbarView.superview contentOffset] : CGPointZero;
}

-(BOOL) walkViewControllerHierarchy:(void(^)(UIViewController *controller, BOOL *stop))block {

  // start with us
  BOOL stop = NO;
  block(self, &stop);
  if (stop) {
    return YES;
  }

  // then move through the navigation controller stack from top back to root
  if ([self respondsToSelector:@selector(navigationController)]) {
    UINavigationController *navigationController = [self valueForKey:@"navigationController"];
    for (UIViewController *controller in [navigationController.viewControllers reverseObjectEnumerator]) {
      block(controller, &stop);
      if (stop) {
        return YES;
      }
    }
  }

  // then move through the parent view controller hierarchy
  if ([self.parentViewController walkViewControllerHierarchy:block]) {
    return YES;
  }
  if ([self.presentingViewController walkViewControllerHierarchy:block]) {
    return YES;
  }

  return NO;
}

@end
