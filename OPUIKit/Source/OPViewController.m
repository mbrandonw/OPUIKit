
//
//  OPViewController.m
//  CloudAssassin
//
//  Created by Brandon Williams on 6/13/11.
//  Copyright 2011 Hashable. All rights reserved.
//

#import "OPViewController.h"
#import "OPExtensionKit.h"
#import "UIView+Opetopic.h"
#import "UIViewController+Opetopic.h"
#import "UIViewController+OPUIKit.h"
#import "OPNavigationController.h"
#import "OPView.h"
#import "OPMacros.h"
#import "Quartz+Opetopic.h"

const struct OPViewControllerNotifications OPViewControllerNotifications = {
	.viewDidLoad = @"OPViewControllerNotifications.viewDidLoad",
	.viewWillAppear = @"OPViewControllerNotifications.viewWillAppear",
	.viewDidAppear = @"OPViewControllerNotifications.viewDidAppear",
	.viewWillDisappear = @"OPViewControllerNotifications.viewWillDisappear",
	.viewDidDisappear = @"OPViewControllerNotifications.viewDidDisappear",
};

@interface OPViewController (/**/)

// helper methods for dealing with content size
@property (nonatomic, strong) NSString *lastContentSizeCategory;
-(void) configureForCurrentContentSizeCategory;
+(void) configureForCurrentContentSizeCategory;
@end

@implementation OPViewController

// OPStyle storage
@synthesize backgroundColor = _backgroundColor;
@synthesize backgroundImage = _backgroundImage;
@synthesize defaultTitle = _defaultTitle;
@synthesize defaultSubtitle = _defaultSubtitle;
@synthesize defaultTitleImage = _defaultTitleImage;
@synthesize titleFont = _titleFont;
@synthesize subtitleFont = _subtitleFont;
@synthesize titleColor = _titleColor;
@synthesize titleShadowColor = _titleShadowColor;
@synthesize titleShadowOffset = _titleShadowOffset;

#pragma mark -
#pragma mark Class lifecycle
#pragma mark -

+(void) initialize {
  [[self class] configureForCurrentContentSizeCategory];
}

#pragma mark -
#pragma mark Object lifecycle
#pragma mark -

-(id) init {
  if (! (self = [super init])) {
    return nil;
  }

  // apply stylings
  [[self styling] applyTo:self];

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
}

-(void) didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  DLogClassAndMethod();
}

#pragma mark -
#pragma mark View lifecycle
#pragma mark -

-(void) loadView {
  [super loadView];
  DLogClassAndMethod();
  [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.loadView object:self];

  Class viewClass = [[self class] viewClass];
  if (viewClass) {
    OPView *view = [[viewClass alloc] initWithFrame:self.view.frame];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = view;
    if ([view respondsToSelector:@selector(setController:)]) {
      view.controller = self;
    }
  }
}

-(void) viewDidLoad {
  [super viewDidLoad];
  DLogClassAndMethod();

  [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewDidLoad object:self];

  // default the background color if the view doesn't already have one
	if (self.backgroundImage)
  {
    if (! CGSizeIsPowerOfTwo(self.backgroundImage.size)) {
      DLog(@"==============================================================");
      DLog(@"Pattern image drawing is most efficient with power of 2 images");
      DLog(@"==============================================================");
    }
		self.view.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
  }
  else if (self.backgroundColor) {
    self.view.backgroundColor = self.backgroundColor;
  } else {
    self.view.backgroundColor = [UIColor whiteColor];
  }

  if (self.toolbarView && [self.view isKindOfClass:[UIScrollView class]]) {
    [(UIScrollView*)self.view setContentInsetBottom:self.toolbarView.height];
    [(UIScrollView*)self.view setScrollIndicatorInsetBottom:self.toolbarView.height];
  } else if (self.toolbarView && [self.view isKindOfClass:[UIWebView class]]) {
    [[(UIWebView*)self.view scrollView] setContentInsetBottom:self.toolbarView.height];
    [[(UIWebView*)self.view scrollView] setScrollIndicatorInsetBottom:self.toolbarView.height];
  }
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  DLogClassAndMethod();
  [self configureForCurrentContentSizeCategory];
  [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewWillAppear object:self];

  // set the default navigation item title view
  if (self.defaultTitleImage && !self.navigationItem.titleView && !self.title) {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:self.defaultTitleImage];
  }
  if (self.defaultTitle && !self.navigationItem.titleView && !self.title) {
    [self setTitle:self.defaultTitle subtitle:self.defaultSubtitle];
  }
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  DLogClassAndMethod();
  [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewDidAppear object:self];
}

-(void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  DLogClassAndMethod();
  [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewWillDisappear object:self];
}

-(void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  DLogClassAndMethod();
  [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewDidDisappear object:self];
}

-(void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self configureForCurrentContentSizeCategory];
  [self layoutToolbarView];
}

#pragma mark -
#pragma mark Preferred content size methods
#pragma mark -

-(void) preferredContentSizeChanged:(NSNotification*)notification {
  dispatch_next_runloop(^{
    [[self class] configureForCurrentContentSizeCategory];
    [self configureForCurrentContentSizeCategory];
  });
}

-(void) configureForContentSizeCategory:(NSString *)category {
  if ([self isViewLoaded] && [self isViewVisible]) {
    [self.view setNeedsDisplayAndLayout];
    [self viewDidLayoutSubviews];
  }
}

+(void) configureForContentSizeCategory:(NSString *)category {
}

#pragma mark -
#pragma mark Private helper methods for preferred content size
#pragma mark -

-(void) configureForCurrentContentSizeCategory {
  NSString *currentContentSizeCategory = @"";

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
