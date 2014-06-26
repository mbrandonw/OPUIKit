//
//  OPWebViewController.h
//  Kickstarter
//
//  Created by Brandon Williams on 3/12/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "OPViewController.h"

@interface OPWebViewController : OPViewController <UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, readonly) UIScrollView *scrollView;

@end
