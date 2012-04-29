//
//  OPTableView.h
//  Kickstarter
//
//  Created by Brandon Williams on 4/27/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPTableView;
@protocol OPTableViewDelegate <UITableViewDelegate>
@optional
-(void) tableView:(OPTableView*)tableView willSnapToIndexPath:(NSIndexPath*)indexPath;
-(void) tableView:(OPTableView*)tableView didSnapToIndexPath:(NSIndexPath*)indexPath;
@end

@interface OPTableView : UITableView

@property (nonatomic, assign) id<OPTableViewDelegate> delegate;
@property (nonatomic, assign, getter = isHorizontal) BOOL horizontal;
@property (nonatomic, assign) BOOL snapToRows;

@end
