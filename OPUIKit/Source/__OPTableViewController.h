//
//  __OPTableViewController.h
//  Kickstarter
//
//  Created by Brandon Williams on 1/2/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface __OPTableViewController : UITableViewController

@property (nonatomic, strong) NSFetchedResultsController *tableResults;
@property (nonatomic, strong) NSMutableArray *tableData;

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
-(UIEdgeInsets) tableView:(UITableView*)tableView cellInsetsForRowAtIndexPath:(NSIndexPath*)indexPath;

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
