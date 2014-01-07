//
//  OPBlurView.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/5/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "OPBlurView.h"

@interface OPBlurView (/**/)
@property (nonatomic, strong) UIToolbar *blurToolbar;
@property (nonatomic, strong) CALayer *blurLayer;
@property (nonatomic, strong) UIView *blurView;
@end

@implementation OPBlurView

-(void) didAddSubview:(UIView *)subview {
  [super didAddSubview:subview];
  if (subview != _blurView) {
    [self sendSubviewToBack:_blurView];
  }
}

-(void) setBlurTintColor:(UIColor *)blurTintColor {

  if ([UIDevice isiOS7OrLater]) {
    _blurTintColor = blurTintColor;
    self.blurToolbar.barTintColor = blurTintColor;
    self.backgroundColor = [UIColor clearColor];
  }
}

-(void) setBlurStyle:(UIBarStyle)style {
  if ([UIDevice isiOS7OrLater]) {
    [self.blurToolbar setBarStyle:UIBarStyleBlack];
    self.backgroundColor = [UIColor clearColor];
  }
}

-(void) removeBlurTintColor {
  [_blurView removeFromSuperview];
  _blurView = nil;
  _blurToolbar = nil;
  _blurLayer = nil;
}

-(void) layoutSubviews {
  [super layoutSubviews];
  _blurView.frame = self.bounds;
  _blurLayer.frame = self.bounds;
}

-(UIToolbar*) blurToolbar {
  if (! _blurToolbar) {
    _blurToolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
    _blurLayer = _blurToolbar.layer;
    _blurView = [UIView viewWithFrame:self.bounds];
    _blurView.userInteractionEnabled = NO;
    [_blurView.layer addSublayer:_blurLayer];
    _blurView.autoresizingMask = UIViewAutoresizingFlexibleAll;
    _blurView.clipsToBounds = YES;
    [self addSubview:_blurView];
  }
  return _blurToolbar;
}

@end
