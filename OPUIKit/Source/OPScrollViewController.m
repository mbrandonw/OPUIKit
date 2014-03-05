//
//  OPScrollViewController.m
//  OPUIKit
//
//  Created by Brandon Williams on 5/6/13.
//  Copyright (c) 2013 Opetopic. All rights reserved.
//

#import "OPScrollViewController.h"
#import "OPScrollView.h"
#import "UIViewController+OPUIKit.h"

@interface OPScrollViewController (/**/)
@end

@implementation OPScrollViewController

-(id) init {
  if (! (self = [super init])) {
    return nil;
  }

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInsetsForKeyboard:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInsetsForKeyboard:) name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInsetsForKeyboard:) name:UIKeyboardWillChangeFrameNotification object:nil];

  return self;
}

-(void) dealloc {
  if ([self isViewLoaded]) {
    self.scrollView.delegate = nil;
  }
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void) loadView {
  [super loadView];

  Class viewClass = [[self class] viewClass];
  if (! viewClass || ! [viewClass isSubclassOfClass:[UIScrollView class]]) {
    self.view = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  }

  self.scrollView.delegate = self;
}

-(UIScrollView*) scrollView {
  return [self.view typedAs:[UIScrollView class]];
}

-(void) updateInsetsForKeyboard:(NSNotification*)notification {

  CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  [self.scrollView setContentInsetBottom:keyboardRect.size.height];
  [self.scrollView setScrollIndicatorInsetBottom:keyboardRect.size.height];
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods
#pragma mark -

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
    [(id)self.view scrollViewDidEndDecelerating:scrollView];
  }
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if ([self.view respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
    [(id)self.view scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
  }
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
    [(id)self.view scrollViewDidEndScrollingAnimation:scrollView];
  }
}

-(void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
  if ([self.view respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
    [(id)self.view scrollViewDidEndZooming:scrollView withView:view atScale:scale];
  }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewDidScroll:)]) {
    [(id)self.view scrollViewDidScroll:scrollView];
  }
}

-(void) scrollViewDidScrollToTop:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
    [(id)self.view scrollViewDidScrollToTop:scrollView];
  }
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewDidZoom:)]) {
    [(id)self.view scrollViewDidZoom:scrollView];
  }
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
    [(id)self.view scrollViewWillBeginDecelerating:scrollView];
  }
}

-(BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
    return [(id)self.view scrollViewShouldScrollToTop:scrollView];
  }
  return YES;
}

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
    return [(id)self.view viewForZoomingInScrollView:scrollView];
  }
  return nil;
}

@end
