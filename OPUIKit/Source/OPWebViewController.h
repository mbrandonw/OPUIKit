//
//  OPWebViewController.h
//  Kickstarter
//
//  Created by Brandon Williams on 3/12/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "OPScrollViewController.h"

@interface OPWebViewController : OPScrollViewController <UIWebViewDelegate>

@property (nonatomic, strong, readonly) UIWebView *webView;

@end
