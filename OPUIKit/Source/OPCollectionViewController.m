//
//  OPCollectionViewController.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/14/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "OPCollectionViewController.h"
#import "OPViewController.h"
#import "UIView+__OPCellView.h"
#import "OPCollectionViewCell.h"
#import "OPExtensionKit.h"

@interface OPCollectionViewController (/**/)
@property (nonatomic, strong) NSMutableDictionary *metricsCellViews;
-(void) collectionView:(UICollectionView *)collectionView configureCell:(OPCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(UIView*) collectionView:(UICollectionView*)collectionView metricCellViewForRowAtIndexPath:(NSIndexPath*)indexPath;
@end

@implementation OPCollectionViewController

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
#pragma mark View lifecycle methods
#pragma mark -

-(void) loadView {
  [super loadView];
  DLogClassAndMethod();
  [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.loadView object:self];
}

-(void) viewDidLoad {
  [super viewDidLoad];
  DLogClassAndMethod();
  [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewDidLoad object:self];
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  DLogClassAndMethod();
  [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewWillAppear object:self];

  if ([self.view respondsToSelector:@selector(viewWillAppear:)]) {
    [self.view viewWillAppear:animated];
  }
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  DLogClassAndMethod();
  [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewDidAppear object:self];

  if ([self.view respondsToSelector:@selector(viewDidAppear:)]) {
    [self.view viewDidAppear:animated];
  }
}

-(void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  DLogClassAndMethod();
  [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewWillDisappear object:self];

  if ([self.view respondsToSelector:@selector(viewWillDisappear:)]) {
    [self.view viewWillDisappear:animated];
  }
}

-(void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  DLogClassAndMethod();
  [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewDidDisappear object:self];

  if ([self.view respondsToSelector:@selector(viewDidDisappear:)]) {
    [self.view viewDidDisappear:animated];
  }
}

#pragma mark -
#pragma mark Convenience methods
#pragma mark -

-(void) clearCollectionData {
  [_collectionData makeObjectsPerformSelector:@selector(removeAllObjects)];
  [self.collectionView reloadData];
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods
#pragma mark -

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
    [(id)self.view scrollViewDidEndDecelerating:scrollView];
  }
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if ([self.view respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
    [(id)self.view scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
  }
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
    [(id)self.view scrollViewDidEndScrollingAnimation:scrollView];
  }
}

-(void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
  if ([self.view respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
    [(id)self.view scrollViewDidEndZooming:scrollView withView:view atScale:scale];
  }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewDidScroll:)]) {
    [(id)self.view scrollViewDidScroll:scrollView];
  }
}

-(void) scrollViewDidScrollToTop:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
    [(id)self.view scrollViewDidScrollToTop:scrollView];
  }
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewDidZoom:)]) {
    [(id)self.view scrollViewDidZoom:scrollView];
  }
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
    [(id)self.view scrollViewWillBeginDecelerating:scrollView];
  }
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
    [(id)self.view scrollViewWillBeginDragging:scrollView];
  }
}

-(void) scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
  if ([self.view respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
    [(id)self.view scrollViewWillBeginZooming:scrollView withView:view];
  }
}

-(void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
  if ([self.view respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
    [(id)self.view scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
  }
}

-(BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
    return [(id)self.view scrollViewShouldScrollToTop:scrollView];
  }
  return YES;
}

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
  if ([self.view respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
    [(id)self.view viewForZoomingInScrollView:scrollView];
  }
  return nil;
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

-(void) collectionView:(UICollectionView *)collectionView configureCell:(OPCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  [self collectionView:collectionView configureCellView:cell.cellView atIndexPath:indexPath];
  cell.contentEdgeInsets = [self collectionView:collectionView insetsForCellAtIndexPath:indexPath];
  [cell setNeedsLayout];
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

-(void) collectionView:(UICollectionView *)collectionView layoutCell:(OPCollectionViewCell*)cell {
  NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
  [self collectionView:collectionView configureCell:cell atIndexPath:indexPath];
  [cell layoutSubviews];
  [cell.cellView layoutSubviews];
}

-(NSIndexPath*) indexPathForObject:(id)object {
  for (NSInteger section = 0; section < [self numberOfSectionsInCollectionView:self.collectionView]; section++) {
    for (NSInteger item = 0; item < [self collectionView:self.collectionView numberOfItemsInSection:section]; item++) {
      NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
      id testObject = [self collectionView:self.collectionView objectForCellAtIndexPath:indexPath];
      if ([testObject isEqual:object]) {
        return indexPath;
      }
    }
  }
  return nil;
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

  Class cellClass = [self collectionView:collectionView classForCellAtIndexPath:indexPath];
  NSString *reuseIdentifier = NSStringFromClass(cellClass);

  [collectionView registerClass:OPCollectionViewCell.class forCellWithReuseIdentifier:reuseIdentifier];

  OPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  cell.viewController = self;
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

  [self collectionView:collectionView configureCellView:metricCellView atIndexPath:indexPath];
  size = [metricCellView sizeThatFitsWidth:size.width];

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
