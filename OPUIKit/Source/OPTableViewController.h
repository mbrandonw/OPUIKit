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

extern UITableViewRowAnimation UITableViewRowAnimationAutomaticOr(UITableViewRowAnimation rowAnimation);

@interface OPTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, OPStyleProtocol>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

/**
 Determines if we should automatically dismiss the keyboard while scrolling,
 as well as the threshold of scrolling for such behavior.
 */
@property (nonatomic, assign) BOOL resignKeyboardWhileScrolling;
@property (nonatomic, assign) CGFloat resignKeyboardScrollDelta;

/**
 The controlled tableView if it is active, or the searchDisplayController's tableView if it is active.
 */
@property (nonatomic, readonly) UITableView *activeTableView;

/**
 Shortcut to creating a controller with style, title and subtitle.
 */
-(id) initWithStyle:(UITableViewStyle)style title:(NSString*)title subtitle:(NSString*)subtitle;

/**
 Reloads the controlled tableView if it is active, or the searchDisplayController's tableView if it is active.
 Also sends out the scrollDidStop message so that images can be lazily loaded.
 */
-(void) reloadData;

/**
 The preferred place to do any table cell configuration. This method is used in the NSFetchedResultsControllerDelegate
 methods to update the cells from the data source.
 */
-(void) tableView:(UITableView*)tableView configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end
