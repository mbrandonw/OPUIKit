//
//  __OPTableViewController.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/2/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "__OPTableViewController.h"
#import "__OPTableViewCell.h"
#import "OPViewController.h"
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

-(void) enumerateVisibleCellViews:(void(^)(UIView *cellView))block;
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

-(void) loadView {
  [super loadView];

  Class viewClass = [[self class] viewClass];
  if (viewClass) {
    if ([viewClass instancesRespondToSelector:@selector(initWithFrame:viewController:)]) {
      self.view = [[viewClass alloc] initWithFrame:self.view.frame viewController:self];
    } else {
      self.view = [[viewClass alloc] initWithFrame:self.view.frame];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  }
}

-(void) viewDidLoad {
  [super viewDidLoad];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self configureForCurrentContentSizeCategory];

  if ([self.view respondsToSelector:@selector(viewWillAppear:)]) {
    [self.view viewWillAppear:animated];
  }
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  if ([self.view respondsToSelector:@selector(viewDidAppear:)]) {
    [self.view viewDidAppear:animated];
  }
}

-(void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  if ([self.view respondsToSelector:@selector(viewWillDisappear:)]) {
    [self.view viewWillDisappear:animated];
  }
}

-(void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];

  if ([self.view respondsToSelector:@selector(viewDidDisappear:)]) {
    [self.view viewDidDisappear:animated];
  }
}

-(void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self configureForCurrentContentSizeCategory];
}

#pragma mark - UIViewController methods

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

  if ([self.view respondsToSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)]) {
    [self.view viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  }
}

#pragma mark -
#pragma mark Convenience methods
#pragma mark -

-(void) clearTableData {
  [self.tableData makeObjectsPerformSelector:@selector(removeAllObjects)];
}

#pragma mark - UITableView methods

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

  if ([metricCellView respondsToSelector:@selector(_cellSize)]) {
    height += ceilf(metricCellView._cellSize.height);
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

#pragma mark - UIScrollView methods

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

  if (scrollView == self.tableView && [self.view respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
    [(id)self.view scrollViewDidEndDecelerating:scrollView];
  }

  [self enumerateVisibleCellViews:^(UIView *cellView) {
    if ([cellView respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
      [cellView scrollViewDidEndDecelerating:scrollView];
    }
  }];
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (scrollView == self.tableView && [self.view respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
    [(id)self.view scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
  }
}

-(void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
  if (scrollView == self.tableView && [self.view respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
    [(id)self.view scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
  }

  [self enumerateVisibleCellViews:^(UIView *cellView) {
    if ([cellView respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
      [cellView scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
  }];
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  if (scrollView == self.tableView && [self.view respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
    [(id)self.view scrollViewDidEndScrollingAnimation:scrollView];
  }
}

-(void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
  if (scrollView == self.tableView && [self.view respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
    [(id)self.view scrollViewDidEndZooming:scrollView withView:view atScale:scale];
  }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView == self.tableView && [self.view respondsToSelector:@selector(scrollViewDidScroll:)]) {
    [(id)self.view scrollViewDidScroll:scrollView];
  }
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  if (scrollView == self.tableView && [self.view respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
    [(id)self.view scrollViewWillBeginDragging:scrollView];
  }
}

-(void) scrollViewDidScrollToTop:(UIScrollView *)scrollView {
  if (scrollView == self.tableView && [self.view respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
    [(id)self.view scrollViewDidScrollToTop:scrollView];
  }
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollView {
  if (scrollView == self.tableView && [self.view respondsToSelector:@selector(scrollViewDidZoom:)]) {
    [(id)self.view scrollViewDidZoom:scrollView];
  }
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
  if (scrollView == self.tableView && [self.view respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
    [(id)self.view scrollViewWillBeginDecelerating:scrollView];
  }
}

-(BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
  if (scrollView == self.tableView && [self.view respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
    return [(id)self.view scrollViewShouldScrollToTop:scrollView];
  }
  return YES;
}

-(void) scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
  if (scrollView == self.tableView && [self.view respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
    [(id)self.view scrollViewWillBeginZooming:scrollView withView:view];
  }
}

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
  if (scrollView == self.tableView && [self.view respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
    return [(id)self.view viewForZoomingInScrollView:scrollView];
  }
  return nil;
}

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

-(void) enumerateVisibleCellViews:(void(^)(UIView *cellView))block {

  for (__OPTableViewCell *cell in self.tableView.visibleCells) {
    if ([cell isKindOfClass:__OPTableViewCell.class]) {
      block(cell.cellView);
    }
  }
}

@end
