//
//  OPTableViewController.h
//  OPUIKit
//
//  Created by Brandon Williams on 12/7/10.
//  Copyright 2010 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "OPStyle.h"

typedef enum {
    OPTableViewFetchControllerActionNone         = 1 << 0,
    OPTableViewFetchControllerActionFlushObjects = 1 << 1,
    OPTableViewFetchControllerActionRelease      = 1 << 2,
} OPTableViewFetchControllerActions;

@interface OPTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, OPStyleProtocol>

/**
 */
@property (nonatomic, assign) BOOL useOPTableView;

/**
 */
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) UITableViewRowAnimation fetchedResultsControllerAnimation;
@property (nonatomic, assign) OPTableViewFetchControllerActions fetchControllerViewDisappearActions;
@property (nonatomic, assign) OPTableViewFetchControllerActions fetchControllerEnterBackgroundActions;

/**
 Determines if we should automatically dismiss the keyboard while scrolling,
 as well as the threshold of scrolling for such behavior.
 */
@property (nonatomic, assign) BOOL resignKeyboardWhileScrolling;
@property (nonatomic, assign) CGFloat resignKeyboardScrollDelta;

/**
 Shortcut to creating a controller with style, title and subtitle.
 */
-(id) initWithStyle:(UITableViewStyle)style title:(NSString*)title subtitle:(NSString*)subtitle;

/**
 The preferred place to do any table cell configuration. This method is used in the NSFetchedResultsControllerDelegate
 methods to update the cells from the data source.
 */
-(void) tableView:(UITableView*)tableView configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

/**
 The default implementation of -tableView:cellForRowAtIndexPath: will use this method to automatically create
 a cell with a common reusable identifier among the same cell view class.
 */
-(Class) tableView:(UITableView*)tableView classForRowAtIndexPath:(NSIndexPath*)indexPath;

/**
 The default implementation of -tableView:viewForHeaderInSection: will use this method to automatically create
 headers for the table view.
 */
-(Class) tableView:(UITableView *)tableView classForHeaderInSection:(NSInteger)section;

/**
 The default implementation of -tableView:cellForRowAtIndexPath: will use this method to get the object
 representing the row and pass it off to the dequeued cell.
 */
-(id) tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath;

/**
 The default implementation of -tableView:viewForHeaderInSection: will use this method to get the object
 representing the section and pass it off to the section view.
 */
-(id) tableView:(UITableView*)tableView objectForHeaderAtSection:(NSInteger)section;

/**
 Sometimes we want to use a fetched results controller for part of the content of our table view, but then 
 the indices of the fetch controller may not match the indices of the table view. Override all of these 
 methods to translate between the two types of indices and everything will work magically.
 */
-(NSInteger) tableViewSectionToFetchedResultsSection:(NSUInteger)section;
-(NSInteger) fetchedResultsSectionToTableViewSection:(NSUInteger)section;
-(NSIndexPath*) tableViewIndexPathToFetchedResultsIndexPath:(NSIndexPath*)indexPath;
-(NSIndexPath*) fetchedResultsIndexPathToTableViewIndexPath:(NSIndexPath*)indexPath;

/**
 Called when the preferred content size is changed in user's settings.
 */
-(void) preferredContentSizeChanged:(NSNotification*)notification;

/**
 Called at certain key times when the controller might need to respond
 to content size, e.g. viewWillAppear, when preferred size changes, just before
 view layout, etc. It is only called when the preferred content size has
 changed since the last time it was called.
 */
-(void) configureForContentSizeCategory:(NSString*)category;

/**
 Same as `-configureForContentSizeCategory:` except called only when
 the class initializes and when the preferred content size changes.
 This method is called before the corresponding instance method.
 */
+(void) configureForContentSizeCategory:(NSString*)category;

@end
