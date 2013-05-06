//
//  OPScrollViewController.m
//  OPUIKit
//
//  Created by Brandon Williams on 5/6/13.
//  Copyright (c) 2013 Opetopic. All rights reserved.
//

#import "OPScrollViewController.h"

@implementation OPScrollViewController

-(void) loadView {
    [super loadView];
    self.view = [[UIScrollView alloc] initWithFrame:self.view.frame];
}

-(UIScrollView*) scrollView {
    return (UIScrollView*)self.view;
}

-(void) setView:(UIView *)view {
    [super setView:[view isKindOfClass:[UIScrollView class]] ? view : nil];
}

@end
