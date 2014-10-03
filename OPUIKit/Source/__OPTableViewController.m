//
//  __OPTableViewController.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/2/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "__OPTableViewController.h"
#import "__OPTableViewCell.h"
#import "OPEnumerable.h"
#import "UIView+__OPCellView.h"
#import "UIViewController+Opetopic.h"
#import "UIView+Opetopic.h"
#import "NSObject+Opetopic.h"
#import "GCD+Opetopic.h"
@import CoreData;

@interface __OPTableViewController (/**/)
@property (nonatomic, strong) NSMutableDictionary *metricsCellViews;
-(UIView*) tableView:(UITableView *)tableView metricCellViewForRowAtIndexPath:(NSIndexPath*)indexPath;

// helper methods for dealing with content size
@property (nonatomic, strong) NSString *lastContentSizeCategory;
-(void) configureForCurrentContentSizeCategory;
@end

@implementation __OPTableViewController

#pragma mark -
#pragma mark Object lifecycle methods
#pragma mark -

-(id) init {
  if (! (self = [super init])) {
    return nil;
  }

  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
  }

  return self;
}

-(void) dealloc {

  // This is just extra precaution. It seems sometimes delegates can
  // get left over, causing bad method calls.
  if ([self isViewLoaded]) {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
  }

  _tableResults.delegate = nil;

  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
  }
}

#pragma mark -
#pragma mark View lifecycle methods
#pragma mark -

-(void) viewDidLoad {
  [super viewDidLoad];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self configureForCurrentContentSizeCategory];
}

-(void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self configureForCurrentContentSizeCategory];
}

#pragma mark -
#pragma mark Convenience methods
#pragma mark -

-(void) clearTableData {
  [self.tableData makeObjectsPerformSelector:@selector(removeAllObjects)];
}

#pragma mark -
#pragma mark UITableView methods
#pragma mark -

-(Class) tableView:(UITableView *)tableView classForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [UIView class];
}

-(UIEdgeInsets) tableView:(UITableView*)tableView insetsForRowAtIndexPath:(NSIndexPath*)indexPath {
  return UIEdgeInsetsZero;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {

  if (self.tableResults) {
    return self.tableResults.sections.count;
  } else if (self.tableData) {
    return self.tableData.count;
  }
  return 0;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  if (self.tableResults) {
    BOOL condition = section < self.tableResults.sections.count;
    NSAssert(condition, @"");
    if (condition) {
      return [self.tableResults.sections[section] numberOfObjects];
    }
  } else if (self.tableData) {
    BOOL condition = section < self.tableData.count;
    NSAssert(condition, @"");
    if (condition) {
      return [self.tableData[section] count];
    }
  }
  return 0;
}

-(id) tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath {

  if (self.tableResults) {
    BOOL condition = indexPath.section < self.tableResults.sections.count && indexPath.row < [self.tableResults.sections[indexPath.section] numberOfObjects];
    NSAssert(condition, @"");
    if (condition) {
      return [self.tableResults objectAtIndexPath:indexPath];
    }
  } else if (self.tableData) {
    BOOL condition = indexPath.section < self.tableData.count && indexPath.row < [self.tableData[indexPath.section] count];
    NSAssert(condition, @"");
    if (condition) {
      return self.tableData[indexPath.section][indexPath.row];
    }
  }
  return nil;
}

-(void) tableView:(UITableView*)tableView configureCellView:(UIView*)cellView atIndexPath:(NSIndexPath*)indexPath {

  cellView.cellRowIsFirst = indexPath.row == 0;
  cellView.cellRowIsLast = indexPath.row+1 == [self tableView:tableView numberOfRowsInSection:indexPath.section];
  cellView.cellRowIsEven = indexPath.row % 2 == 0;

  cellView.cellSectionIsFirst = indexPath.section == 0;
  cellView.cellSectionIsLast = indexPath.section+1 == [self numberOfSectionsInTableView:tableView];
  cellView.cellSectionIsEven = indexPath.section % 2 == 0;

  cellView.cellIndexPath = indexPath;

  cellView.cellObject = [self tableView:tableView objectForRowAtIndexPath:indexPath];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  Class cellClass = [self tableView:tableView classForRowAtIndexPath:indexPath];
  NSString *reuseIdentifier = NSStringFromClass(cellClass);

  __OPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (! cell) {
    cell = [[__OPTableViewCell alloc] initWithViewClass:cellClass reuseIdentifier:reuseIdentifier];
  }

  UIEdgeInsets insets = [self tableView:tableView insetsForRowAtIndexPath:indexPath];
  cell.cellView.frame = UIEdgeInsetsInsetRect(cell.contentView.bounds, insets);

  [self tableView:tableView configureCellView:cell.cellView atIndexPath:indexPath];

  [cell.cellView traverseSelfAndSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(cellWillDisplay)]) {
      [subview cellWillDisplay];
    }
  }];
  
  return cell;
}

-(void) tableView:(UITableView *)tableView didEndDisplayingCell:(__OPTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

  if ([cell isKindOfClass:__OPTableViewCell.class]) {
    [cell.cellView traverseSelfAndSubviews:^(UIView *subview) {
      if ([subview respondsToSelector:@selector(cellDidEndDisplay)]) {
        [subview cellDidEndDisplay];
      }
    }];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat height = 0.0f;

  UIView *metricCellView = [self tableView:tableView metricCellViewForRowAtIndexPath:indexPath];

  UIEdgeInsets insets = [self tableView:tableView insetsForRowAtIndexPath:indexPath];
  height += insets.top + insets.bottom;

  metricCellView.width = tableView.bounds.size.width - insets.left - insets.right;
  metricCellView.height = 10000.0f;
  [self tableView:tableView configureCellView:metricCellView atIndexPath:indexPath];

  if ([metricCellView respondsToSelector:@selector(cellSize)]) {
    height += ceilf(metricCellView.cellSize.height);
  } else {
    height += ceilf(metricCellView.cellSizeWithManualLayout.height);
  }
  
  return height;
}

//-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//  Class viewClass = [self tableView:tableView classForRowAtIndexPath:indexPath];
//  if ([viewClass respondsToSelector:@selector(estimatedCellSize)]) {
//    return ceilf([viewClass estimatedCellSize].height);
//  }
//
//  return UITableViewAutomaticDimension;
//}

#pragma mark -
#pragma mark Content size methods
#pragma mark -

-(void) preferredContentSizeChanged:(NSNotification*)notification {
  dispatch_next_runloop(^{
    [self configureForCurrentContentSizeCategory];
  });
}

-(void) configureForContentSizeCategory:(NSString *)category {
  if ([self isViewLoaded] && [self isViewVisible]) {
    [self.tableView reloadData];
  }
}

#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate methods
#pragma mark -

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}

-(void) controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationAutomatic];
      break;

    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationAutomatic];
      break;
  }
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

  UITableView *tableView = self.tableView;
  switch(type) {

    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:@[newIndexPath]
                       withRowAnimation:UITableViewRowAnimationAutomatic];
      break;

    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:@[indexPath]
                       withRowAnimation:UITableViewRowAnimationAutomatic];
      break;

    case NSFetchedResultsChangeUpdate:
    {
      __OPTableViewCell *cell = [[tableView cellForRowAtIndexPath:indexPath] typedAs:__OPTableViewCell.class];
      [self tableView:tableView configureCellView:cell.cellView atIndexPath:indexPath];
      break;
    }
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:@[indexPath]
                       withRowAnimation:UITableViewRowAnimationAutomatic];
      [tableView insertRowsAtIndexPaths:@[newIndexPath]
                       withRowAnimation:UITableViewRowAnimationAutomatic];
      break;
  }
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
//  [self updateCellScrollRatios];
}

#pragma mark -
#pragma mark Private methods
#pragma mark -

-(void) configureForCurrentContentSizeCategory {
  // Make sure to call the public facing content size methods
  // only when the content size actually changes.

  NSString *currentContentSizeCategory = @"";
  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    currentContentSizeCategory = [[UIApplication sharedApplication] preferredContentSizeCategory];
  }

  if (! currentContentSizeCategory || ! [self.lastContentSizeCategory isEqualToString:currentContentSizeCategory]) {
    self.lastContentSizeCategory = currentContentSizeCategory ?: @"";

    [self configureForContentSizeCategory:currentContentSizeCategory];
  }
}

-(NSMutableDictionary*) metricsCellViews {
  if (! _metricsCellViews) {
    _metricsCellViews = [NSMutableDictionary new];
  }
  return _metricsCellViews;
}

-(UIView*) tableView:(UITableView *)tableView metricCellViewForRowAtIndexPath:(NSIndexPath*)indexPath {

  id class = [self tableView:tableView classForRowAtIndexPath:indexPath];

  if (! self.metricsCellViews[class]) {
    self.metricsCellViews[class] = [[class alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 44.0f)];
  }

  return self.metricsCellViews[class];
}

@end
