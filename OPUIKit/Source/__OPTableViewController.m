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
#import "UIView+__OPTableViewCell.h"

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
#pragma mark UITableView methods
#pragma mark -

-(Class) tableView:(UITableView *)tableView classForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [UIView class];
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

-(void) tableView:(UITableView*)tableView willDisplayCell:(__OPTableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {

  if ([cell.cellView respondsToSelector:@selector(cellWillDisplay)]) {
    [cell.cellView cellWillDisplay];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  UIView *metricCellView = [self tableView:tableView metricCellViewForRowAtIndexPath:indexPath];

  metricCellView.width = tableView.bounds.size.width;
  metricCellView.height = 10000.0f;
  [self tableView:tableView configureCellView:metricCellView atIndexPath:indexPath];

  if ([metricCellView respondsToSelector:@selector(cellSize)]) {
    return ceilf(metricCellView.cellSize.height);
  }

  return ceilf(metricCellView.cellSizeWithManualLayout.height);
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

  Class viewClass = [self tableView:tableView classForRowAtIndexPath:indexPath];
  if ([viewClass respondsToSelector:@selector(estimatedCellSize)]) {
    return ceilf([viewClass estimatedCellSize].height);
  }

  return UITableViewAutomaticDimension;
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
