//
//  OPTableViewController.h
//  MiStryker
//
//  Created by Brandon Williams on 12/7/10.
//  Copyright 2010 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "OPStyle.h"


@interface OPTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, OPStyleProtocol>

@property (nonatomic, assign) BOOL resignKeyboardWhileScrolling;
@property (nonatomic, assign) CGFloat resignKeyboardScrollDelta;

@property (nonatomic, readonly) UITableView *activeTableView; // returns the search table view if it is active, otherwise the default table view

// initialization methods
-(id) initWithStyle:(UITableViewStyle)style title:(NSString*)title subtitle:(NSString*)subtitle;

// this is the preferred method to reload data instead of [self.tableView reloadData] or [self.searchDisplayController.searchResultsTableView reloadData]
-(void) reloadData;

-(void) tableView:(UITableView*)tableView configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end
