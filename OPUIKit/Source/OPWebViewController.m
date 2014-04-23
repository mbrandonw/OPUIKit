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
  }
}

-(void) loadView {
  [super loadView];

  Class viewClass = [[self class] viewClass];
  if (! viewClass || ! [viewClass isSubclassOfClass:UIWebView.class]) {
    self.view = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  }

  self.webView.delegate = self;
  self.webView.scrollView.delegate = self;
}

-(UIWebView*) webView {
  if ([self.view isKindOfClass:UIWebView.class]) {
    return (UIWebView*)self.view;
  }
  return nil;
}

#pragma mark -
#pragma mark UIWebViewDelegate methods
#pragma mark -

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
}

-(void) webViewDidStartLoad:(UIWebView *)webView {
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  return YES;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods
#pragma mark -

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

-(void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

-(BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
  return YES;
}

-(void) scrollViewDidScrollToTop:(UIScrollView *)scrollView {
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return nil;
}

-(void) scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
}

-(void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollView {
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
}

@end
