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
@property (nonatomic, assign) CGPoint contentOffsetOnRotation;
@property (nonatomic, assign) CGSize contentSizeOnRotation;
@property (nonatomic, assign) CGSize sizeOnRotation;
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
  if (! [viewClass isSubclassOfClass:[UIScrollView class]]) {
    if ([viewClass instancesRespondToSelector:@selector(initWithFrame:viewController:)]) {
      self.view = [[viewClass alloc] initWithFrame:self.view.frame viewController:self];
    } else {
      self.view = [[viewClass alloc] initWithFrame:self.view.frame];
    }
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

-(void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
  if ([self.view respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
    [(id)self.view scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
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

#pragma mark -
#pragma mark Rotation methods
#pragma mark -

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

  self.contentOffsetOnRotation = self.scrollView.contentOffset;
  self.contentSizeOnRotation = self.scrollView.contentSize;
  self.sizeOnRotation = self.scrollView.bounds.size;
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

  self.scrollView.contentOffset = (CGPoint){
    (self.scrollView.contentSize.width - self.scrollView.bounds.size.width) * self.contentOffsetOnRotation.x / (self.contentSizeOnRotation.width - self.sizeOnRotation.width),
    (self.scrollView.contentSize.height - self.scrollView.bounds.size.height) * self.contentOffsetOnRotation.y / (self.contentSizeOnRotation.height - self.sizeOnRotation.height),
  };
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

  self.contentOffsetOnRotation = CGPointZero;
  self.contentSizeOnRotation = CGSizeZero;
  self.sizeOnRotation = CGSizeZero;
}

@end
