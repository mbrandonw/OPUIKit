//
//  OPScrollViewController.m
//  OPUIKit
//
//  Created by Brandon Williams on 5/6/13.
//  Copyright (c) 2013 Opetopic. All rights reserved.
//

#import "OPScrollViewController.h"
#import "OPScrollView.h"

@interface OPScrollViewController (/**/)
@end

@implementation OPScrollViewController

+(Class) viewClass {
  return nil;
}

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
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void) loadView {
  [super loadView];

  Class viewClass = [[self class] viewClass];
  if (! viewClass || ! [viewClass isSubclassOfClass:[UIScrollView class]]) {
    self.view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleAll;
  }
}

-(UIScrollView*) scrollView {
  return [self.view typedAs:[UIScrollView class]];
}

-(void) updateInsetsForKeyboard:(NSNotification*)notification {

  CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  [self.scrollView setContentInsetBottom:keyboardRect.size.height];
  [self.scrollView setScrollIndicatorInsetBottom:keyboardRect.size.height];
}

@end
