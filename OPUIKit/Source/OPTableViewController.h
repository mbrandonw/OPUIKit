//
//  OPTableViewController.h
//  MiStryker
//
//  Created by Brandon Williams on 12/7/10.
//  Copyright 2010 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef OP_NAVIGATION_CONTROLLER_SIMULATE_MEMORY_WARNINGS
#define OP_NAVIGATION_CONTROLLER_SIMULATE_MEMORY_WARNINGS   NO
#endif

@class OPTableView;

@interface OPTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, assign) BOOL useOPTableView;
@property (nonatomic, assign) BOOL resignKeyboardWhileScrolling;
@property (nonatomic, assign) BOOL restoreExpandableSelectionOnViewWillAppear;

@property (nonatomic, readonly) UITableView *activeTableView; // returns the search table view if it is active, otherwise the default table view
@property (nonatomic, readonly) OPTableView *opTableView;

// styling methods
+(void) setDefaultBackgroundColor:(UIColor*)color;
+(void) setDefaultTitleTextColor:(UIColor*)color;
+(void) setDefaultTitleShadowColor:(UIColor*)color;
+(void) setDefaultTitleShadowOffset:(CGSize)offset;
+(void) setDefaultTitleImage:(UIImage*)image;

// initialization methods
-(id) initWithStyle:(UITableViewStyle)style title:(NSString*)title subtitle:(NSString*)subtitle;

// titling methods
-(void) setTitle:(NSString*)title subtitle:(NSString*)subtitle;

// this is the preferred method to reload data instead of [self.tableView reloadData] or [self.searchDisplayController.searchResultsTableView reloadData]
-(void) reloadData;

-(void) tableView:(UITableView*)tableView configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end
