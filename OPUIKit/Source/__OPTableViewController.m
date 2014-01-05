//
//  __OPTableViewController.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/2/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "__OPTableViewController.h"
#import "__OPTableViewCell.h"
#import "UIView+__OPTableViewCell.h"

@interface __OPTableViewController (/**/)
@property (nonatomic, strong) NSMutableDictionary *metricsCellViews;
-(UIView*) tableView:(UITableView *)tableView metricCellViewForRowAtIndexPath:(NSIndexPath*)indexPath;
@end

@implementation __OPTableViewController

-(Class) tableView:(UITableView *)tableView classForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [UITableViewCell class];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.tableResults) {
    return self.tableResults.sections.count;
  } else if (self.tableData) {
    return self.tableData.count;
  }
  return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.tableResults) {
    BOOL condition = section < self.tableResults.sections.count;
    NSAssert(condition, @"");
    if (condition) {
      return [self.tableResults.sections[section] count];
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
    BOOL condition = indexPath.section < self.tableResults.sections.count && indexPath.row < [self.tableResults.sections[indexPath.section] count];
    if (condition) {
      return [self.tableResults objectAtIndexPath:indexPath];
    }
  } else if (self.tableData) {
    BOOL condition = indexPath.section < self.tableData.count && indexPath.row < [self.tableData[indexPath.section] count];
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

  [self tableView:tableView configureCellView:cell.cellView atIndexPath:indexPath];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  UIView *metricCellView = [self tableView:tableView metricCellViewForRowAtIndexPath:indexPath];

  if ([metricCellView respondsToSelector:@selector(cellSize)]) {
    return ceilf(metricCellView.cellSize.height) + 1.0f;
  }

  return ceilf(metricCellView.cellSizeWithAutolayout.height);
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

  UIView *metricCellView = [self tableView:tableView metricCellViewForRowAtIndexPath:indexPath];

  if ([metricCellView respondsToSelector:@selector(estimatedCellSize)]) {
    return ceilf(metricCellView.estimatedCellSize.height);
  }

  return UITableViewAutomaticDimension;
}

#pragma mark -
#pragma mark Private methods
#pragma mark -

-(NSMutableDictionary*) metricsCellViews {
  if (! _metricsCellViews) {
    _metricsCellViews = [NSMutableDictionary new];
  }
  return _metricsCellViews;
}

-(UIView*) tableView:(UITableView *)tableView metricCellViewForRowAtIndexPath:(NSIndexPath*)indexPath {

  Class cellClass = [self tableView:tableView classForRowAtIndexPath:indexPath];

  UIView *metricCellView = self.metricsCellViews[cellClass];
  if (! metricCellView) {
    metricCellView = [[cellClass alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 44.0f)];
    metricCellView.hidden = YES;
    self.metricsCellViews[(id<NSCopying>)cellClass] = metricCellView;
  }

  metricCellView.width = tableView.bounds.size.width;
  metricCellView.height = 10000.0f;
  [self tableView:tableView configureCellView:metricCellView atIndexPath:indexPath];

  return metricCellView;
}

@end
