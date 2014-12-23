//
//  __OPTableViewController.h
//  Kickstarter
//
//  Created by Brandon Williams on 1/2/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "__OPTableViewCell.h"

@class NSFetchedResultsController;
@protocol NSFetchedResultsControllerDelegate;

@interface __OPTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *tableResults;
@property (nonatomic, strong) NSMutableArray *tableData;

/**
 Set to YES if each row has a unique Class for benefits.
 */
@property (nonatomic, assign) BOOL hasUniqueCellViews;

/**
 Sometimes rotations can be really slow with custom cells,
 so set this to YES for a behavior that causes the cells
 to disappear and then reappear during rotation, but at least
 it rotates quickly.
 */
@property (nonatomic, assign) BOOL scorchedEarthRotationPolicy;

/**
 A convenience method that simply removes all objects
 from subsets.
 */
-(void) clearTableData;

/**
 Returns the class of the UIView that represents the cell
 at the specified index path.
 */
-(Class) tableView:(UITableView*)tableView classForRowAtIndexPath:(NSIndexPath*)indexPath;

/**
 */
-(UIEdgeInsets) tableViewInsetsForTableViewHeader:(UITableView*)tableView;
-(UIEdgeInsets) tableView:(UITableView*)tableView insetsForRowAtIndexPath:(NSIndexPath*)indexPath;

/**
 Returns the object that represents the cell at the 
 specified index path.
 */
-(id) tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath;

/**
 Any cell customization that needs to be done in the controller
 should be implemented here and not in cellForRowAtIndexPath.
 Implementations must call the super method.
 */
-(void) tableView:(UITableView*)tableView configureCellView:(UIView*)cellView atIndexPath:(NSIndexPath*)indexPath;

/**
 */
-(void) configureForContentSizeCategory:(NSString*)contentSize;

@end

/**
 UIScrollViewDelegate methods are forwarded to the tableView cells.
 */
@interface UIView (__OPTableViewController_OPCellView) <UIScrollViewDelegate>
@end

/**
 UIScrollViewDelegate methods are forwarded to the UITableView
 */
@interface UITableView (__OPTableViewController_UITableView) <UIScrollViewDelegate>
@end
