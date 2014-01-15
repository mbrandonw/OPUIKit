//
//  __OPCollectionViewController.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/14/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "__OPCollectionViewController.h"
#import "UIView+__OPTableViewCell.h"
#import "__OPCollectionViewCell.h"
#import "OPExtensionKit.h"

@implementation __OPCollectionViewController

#pragma mark -
#pragma mark Object lifecycle methods
#pragma mark -

-(id) init {
  if (! (self = [super init])) {
    return nil;
  }

  return self;
}

-(void) dealloc {

  // This is just extra precaution. It seems sometimes delegates can
  // get left over, causing bad method calls.
  if ([self isViewLoaded]) {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
  }

  _collectionResults.delegate = nil;
}

#pragma mark -
#pragma mark Convenience methods
#pragma mark -

-(void) clearCollectionData {
  [self.collectionData makeObjectsPerformSelector:@selector(removeAllObjects)];
}

#pragma mark -
#pragma mark UICollectionView methods
#pragma mark -

-(Class) collectionView:(UICollectionView *)collectionView classForCellAtIndexPath:(NSIndexPath *)indexPath {
  return [UIView class];
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView insetsForCellAtIndexPath:(NSIndexPath *)indexPath {
  return UIEdgeInsetsZero;
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

  if (self.collectionResults) {
    return self.collectionResults.sections.count;
  } else if (self.collectionData) {
    return self.collectionData.count;
  }
  return 0;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

  if (self.collectionResults) {
    BOOL condition = section < self.collectionResults.sections.count;
    NSAssert(condition, @"");
    if (condition) {
      return [self.collectionResults.sections[section] numberOfObjects];
    }
  } else if (self.collectionData) {
    BOOL condition = section < self.collectionData.count;
    NSAssert(condition, @"");
    if (condition) {
      return [self.collectionData[section] count];
    }
  }
  return 0;
}

-(id) collectionView:(UICollectionView *)collectionView objectForCellAtIndexPath:(NSIndexPath *)indexPath {

  if (self.collectionResults) {
    BOOL condition = indexPath.section < self.collectionResults.sections.count && indexPath.row < [self.collectionResults.sections[indexPath.section] numberOfObjects];
    NSAssert(condition, @"");
    if (condition) {
      return [self.collectionResults objectAtIndexPath:indexPath];
    }
  } else if (self.collectionData) {
    BOOL condition = indexPath.section < self.collectionData.count && indexPath.row < [self.collectionData[indexPath.section] count];
    NSAssert(condition, @"");
    if (condition) {
      return self.collectionData[indexPath.section][indexPath.row];
    }
  }
  return nil;
}

-(void) collectionView:(UICollectionView *)collectionView configureCellView:(UIView *)cellView atIndexPath:(NSIndexPath *)indexPath {

  cellView.cellRowIsFirst = indexPath.row == 0;
  cellView.cellRowIsLast = indexPath.row+1 == [self collectionView:collectionView numberOfItemsInSection:indexPath.section];
  cellView.cellRowIsEven = indexPath.row % 2 == 0;

  cellView.cellSectionIsFirst = indexPath.section == 0;
  cellView.cellSectionIsLast = indexPath.section+1 == [self numberOfSectionsInCollectionView:collectionView];
  cellView.cellSectionIsEven = indexPath.section % 2 == 0;

  cellView.cellIndexPath = indexPath;

  cellView.cellObject = [self collectionView:collectionView objectForCellAtIndexPath:indexPath];
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

  Class cellClass = [self collectionView:collectionView classForCellAtIndexPath:indexPath];
  NSString *reuseIdentifier = NSStringFromClass(cellClass);

  [collectionView registerClass:__OPCollectionViewCell.class forCellWithReuseIdentifier:reuseIdentifier];
  
  __OPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  if (! cell.cellViewClass) {
    cell.cellViewClass = cellClass;
  }

  [self collectionView:collectionView configureCellView:cell.cellView atIndexPath:indexPath];
  [cell.cellView traverseSelfAndSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(cellWillDisplay)]) {
      [subview cellWillDisplay];
    }
  }];

  return cell;
}

//-(void) tableView:(UITableView*)tableView willDisplayCell:(__OPTableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
//
//  UIEdgeInsets insets = [self tableView:tableView insetsForRowAtIndexPath:indexPath];
//  cell.cellView.frame = UIEdgeInsetsInsetRect(cell.bounds, insets);
//
//  if ([cell.cellView respondsToSelector:@selector(cellWillDisplay)]) {
//    [cell.cellView cellWillDisplay];
//  }
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//  CGFloat height = 0.0f;
//
//  UIView *metricCellView = [self tableView:tableView metricCellViewForRowAtIndexPath:indexPath];
//
//  UIEdgeInsets insets = [self tableView:tableView insetsForRowAtIndexPath:indexPath];
//  height += insets.top + insets.bottom;
//
//  metricCellView.width = tableView.bounds.size.width - insets.left - insets.right;
//  metricCellView.height = 10000.0f;
//  [self tableView:tableView configureCellView:metricCellView atIndexPath:indexPath];
//
//  if ([metricCellView respondsToSelector:@selector(cellSize)]) {
//    height += ceilf(metricCellView.cellSize.height);
//  } else {
//    height += ceilf(metricCellView.cellSizeWithManualLayout.height);
//  }
//  
//  return height;
//}

@end
