//
//  __OPCollectionViewController.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/14/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "__OPCollectionViewController.h"
#import "UIView+__OPCellView.h"
#import "__OPCollectionViewCell.h"
#import "OPExtensionKit.h"

@interface __OPCollectionViewController (/**/) <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableDictionary *metricsCellViews;
-(void) collectionView:(UICollectionView *)collectionView configureCell:(__OPCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(UIView*) collectionView:(UICollectionView*)collectionView metricCellViewForRowAtIndexPath:(NSIndexPath*)indexPath;
@end

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

-(CGFloat) collectionView:(UICollectionView*)collectionView widthForCellAtIndexPath:(NSIndexPath*)indexPath {

  UICollectionViewFlowLayout *layout = OPTypedAs(self.collectionView.collectionViewLayout, UICollectionViewFlowLayout);
  if (layout) {
    return layout.itemSize.width;
  }
  return 320.0f;
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

-(void) collectionView:(UICollectionView *)collectionView configureCell:(__OPCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  cell.contentEdgeInsets = [self collectionView:collectionView insetsForCellAtIndexPath:indexPath];
  [self collectionView:collectionView configureCellView:cell.cellView atIndexPath:indexPath];
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

-(void) collectionView:(UICollectionView *)collectionView layoutCell:(__OPCollectionViewCell*)cell {
  NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
  [self collectionView:collectionView configureCell:cell atIndexPath:indexPath];
  [cell setNeedsLayout];
  [cell layoutIfNeeded];
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

  Class cellClass = [self collectionView:collectionView classForCellAtIndexPath:indexPath];
  NSString *reuseIdentifier = NSStringFromClass(cellClass);

  [collectionView registerClass:__OPCollectionViewCell.class forCellWithReuseIdentifier:reuseIdentifier];

  __OPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  if (! cell.cellViewClass) {
    cell.cellViewClass = cellClass;
  }

  [self collectionView:collectionView configureCell:cell atIndexPath:indexPath];

  [cell.cellView traverseSelfAndSubviews:^(UIView *subview) {
    if ([subview respondsToSelector:@selector(cellWillDisplay)]) {
      [subview cellWillDisplay];
    }
  }];

  return cell;
}

#pragma mark -
#pragma mark UICollectionViewFlowLayout methods
#pragma mark -

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

  UIView *metricCellView = [self collectionView:collectionView metricCellViewForRowAtIndexPath:indexPath];

  UIEdgeInsets insets = [self collectionView:collectionView insetsForCellAtIndexPath:indexPath];
  CGSize size = {
    [self collectionView:collectionView widthForCellAtIndexPath:indexPath],
    insets.top + insets.bottom,
  };

  metricCellView.width = size.width;
  metricCellView.height = 10000.0f;
  [self collectionView:collectionView configureCellView:metricCellView atIndexPath:indexPath];

  if ([metricCellView respondsToSelector:@selector(cellSize)]) {
    size.height += ceilf(metricCellView.cellSize.height);
  } else {
    size.height += ceilf(metricCellView.cellSizeWithManualLayout.height);
  }

  size.width += insets.left + insets.right;
  return size;
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

  UICollectionViewFlowLayout *layout = OPTypedAs(collectionViewLayout, UICollectionViewFlowLayout);
  return layout.sectionInset;
}

-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

  UICollectionViewFlowLayout *layout = OPTypedAs(collectionViewLayout, UICollectionViewFlowLayout);
  return layout.minimumInteritemSpacing;
}

-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

  UICollectionViewFlowLayout *layout = OPTypedAs(collectionViewLayout, UICollectionViewFlowLayout);
  return layout.minimumLineSpacing;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

  UICollectionViewFlowLayout *layout = OPTypedAs(collectionViewLayout, UICollectionViewFlowLayout);
  return layout.footerReferenceSize;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

  UICollectionViewFlowLayout *layout = OPTypedAs(collectionViewLayout, UICollectionViewFlowLayout);
  return layout.headerReferenceSize;
}

#pragma mark -
#pragma mark Accessor methods
#pragma mark -

-(NSMutableDictionary*) metricsCellViews {
  if (! _metricsCellViews) {
    _metricsCellViews = [NSMutableDictionary new];
  }
  return _metricsCellViews;
}

#pragma mark -
#pragma mark Private methods
#pragma mark -

-(UIView*) collectionView:(UICollectionView*)collectionView metricCellViewForRowAtIndexPath:(NSIndexPath*)indexPath {

  id class = [self collectionView:collectionView classForCellAtIndexPath:indexPath];

  if (! self.metricsCellViews[class]) {
    self.metricsCellViews[class] = [[class alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 44.0f)];
  }

  return self.metricsCellViews[class];
}

@end
