//
//  OPWebViewController.m
//  Kickstarter
//
//  Created by Brandon Williams on 3/12/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "OPWebViewController.h"
#import "OPWebView.h"

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
  Class viewClass = [[self class] viewClass];
  if (! [viewClass isSubclassOfClass:UIWebView.class]) {
    viewClass = UIWebView.class;
  }

  if ([viewClass instancesRespondToSelector:@selector(initWithFrame:viewController:)]) {
    self.view = [[viewClass alloc] initWithFrame:UIScreen.mainScreen.bounds viewController:self];
  } else {
    self.view = [[viewClass alloc] initWithFrame:UIScreen.mainScreen.bounds];
  }
  self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

  self.scrollView.delegate = self;
  self.webView.delegate = self;
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

@end
