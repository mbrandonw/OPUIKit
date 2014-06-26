//
//  OPWebViewController.m
//  Kickstarter
//
//  Created by Brandon Williams on 3/12/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "OPWebViewController.h"

@interface OPWebViewController () <UIScrollViewDelegate>
@end

@implementation OPWebViewController

-(void) dealloc {
  if ([self isViewLoaded]) {
    self.webView.delegate = nil;
    self.webView.scrollView.delegate = nil;
  }
}

-(void) loadView {
  [super loadView];

  if (! [self.view.class isSubclassOfClass:UIWebView.class]) {
    self.view = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  }

  self.webView.delegate = self;
  self.scrollView.delegate = self;
}

-(UIWebView*) webView {
  if ([self.view isKindOfClass:UIWebView.class]) {
    return (UIWebView*)self.view;
  }
  return nil;
}

-(UIScrollView*) scrollView {
  return self.webView.scrollView;
}

#pragma mark -
#pragma mark UIWebViewDelegate methods
#pragma mark -

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
  if (webView == self.webView && [webView respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
    [(id)webView webView:webView didFailLoadWithError:error];
  }
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
  if (webView == self.webView && [webView respondsToSelector:@selector(webViewDidFinishLoad:)]) {
    [(id)webView webViewDidFinishLoad:webView];
  }
}

-(void) webViewDidStartLoad:(UIWebView *)webView {
  if (webView == self.webView && [webView respondsToSelector:@selector(webViewDidStartLoad:)]) {
    [(id)webView webViewDidStartLoad:webView];
  }
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

  if (webView == self.webView && [webView respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
    return [(id)webView webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
  }

  return YES;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods
#pragma mark -

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {

  if (scrollView == self.scrollView && [self.view respondsToSelector:@selector(scrollViewDidScroll:)]) {
    [(id)self.view scrollViewDidScroll:scrollView];
  }
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {

  if (scrollView == self.scrollView && [self.view respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
    [(id)self.view scrollViewWillBeginDragging:scrollView];
  }
}

-(void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

  if (scrollView == self.scrollView && [self.view respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
    [(id)self.view scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
  }
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

  if (scrollView == self.scrollView && [self.view respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
    [(id)self.view scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
  }
}

-(BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {

  if (scrollView == self.scrollView && [self.view respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
    return [(id)self.view scrollViewShouldScrollToTop:scrollView];
  }

  return YES;
}

-(void) scrollViewDidScrollToTop:(UIScrollView *)scrollView {

  if (scrollView == self.scrollView && [self.view respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
    [(id)self.view scrollViewDidScrollToTop:scrollView];
  }
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {

  if (scrollView == self.scrollView && [self.view respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
    [(id)self.view scrollViewWillBeginDecelerating:scrollView];
  }
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

  if (scrollView == self.scrollView && [self.view respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
    [(id)self.view scrollViewDidEndDecelerating:scrollView];
  }
}

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {

  if (scrollView == self.scrollView && [self.view respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
    return [(id)self.view viewForZoomingInScrollView:scrollView];
  }

  return nil;
}

-(void) scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {

  if (scrollView == self.scrollView && [self.view respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
    [(id)self.view scrollViewWillBeginZooming:scrollView withView:view];
  }
}

-(void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {

  if (scrollView == self.scrollView && [self.view respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
    [(id)self.view scrollViewDidEndZooming:scrollView withView:view atScale:scale];
  }
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollView {

  if (scrollView == self.scrollView && [self.view respondsToSelector:@selector(scrollViewDidZoom:)]) {
    [(id)self.view scrollViewDidZoom:scrollView];
  }
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

  if (scrollView == self.scrollView && [self.view respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
    [(id)self.view scrollViewDidEndScrollingAnimation:scrollView];
  }
}

@end
