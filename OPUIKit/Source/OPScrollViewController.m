//
//  OPScrollViewController.m
//  OPUIKit
//
//  Created by Brandon Williams on 5/6/13.
//  Copyright (c) 2013 Opetopic. All rights reserved.
//

#import "OPScrollViewController.h"

@implementation OPScrollViewController

-(void) viewDidLoad {
    self.view = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [super viewDidLoad];
}

-(UIScrollView*) scrollView {
    return [self.view isKindOfClass:[UIScrollView class]] ? (UIScrollView*)self.view : nil;
}

@end
