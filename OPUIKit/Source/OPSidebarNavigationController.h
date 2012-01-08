//
//  OPSidebarNavigationController.h
//  OPUIKit
//
//  Created by Brandon Williams on 11/19/11.
//  Copyright (c) 2011 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPNavigationController.h"

typedef enum {
    OPSidebarNavigationDraggableAreaNavBar = 0,
    OPSidebarNavigationDraggableAreaEntireArea,
} OPSidebarNavigationDraggableArea;

@interface OPSidebarNavigationController : OPNavigationController

@property (nonatomic, retain) UIViewController *sidebarViewController;
@property (nonatomic, assign) OPSidebarNavigationDraggableArea draggableArea;
@property (nonatomic, assign) CGFloat minimumSidebarWidth;
@property (nonatomic, assign) CGFloat maximumSidebarWidth;
@property (nonatomic, assign) BOOL sidebarVisible;
@property (nonatomic, assign) BOOL visible;

-(void) setSidebarVisible:(BOOL)sidebarVisible animated:(BOOL)animated;
-(void) setVisible:(BOOL)visible animated:(BOOL)animated;

@end
