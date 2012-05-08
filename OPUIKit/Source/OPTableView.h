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

/**
 Delegate methods called just before and right after the table view has snapped to an index path.
 */
-(void) tableView:(OPTableView*)tableView willSnapToIndexPath:(NSIndexPath*)indexPath;
-(void) tableView:(OPTableView*)tableView didSnapToIndexPath:(NSIndexPath*)indexPath;

/**
 This delegate methods passes you the index path it is about to snap to, and you return the index path
 it should snap to. If you don't implement this method it will snap to the default index path. If you 
 return nil then the table view will scroll freely.
 */
-(NSIndexPath*) tableView:(UITableView *)tableView shouldSnapToIndexPath:(NSIndexPath*)indexPath;
@end

@interface OPTableView : UITableView

@property (nonatomic, assign) id<OPTableViewDelegate> delegate;
@property (nonatomic, assign, getter = isHorizontal) BOOL horizontal;
@property (nonatomic, assign) BOOL snapToRows;

@end
