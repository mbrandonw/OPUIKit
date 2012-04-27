//
//  OPTableView.h
//  Kickstarter
//
//  Created by Brandon Williams on 4/27/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPTableView : UITableView

@property (nonatomic, assign, getter = isHorizontal) BOOL horizontal;
@property (nonatomic, assign) BOOL snapToRows;

@end
