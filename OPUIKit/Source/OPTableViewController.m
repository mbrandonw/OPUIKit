//
//  OPTableViewController.m
//  OPUIKit
//
//  Created by Brandon Williams on 12/7/10.
//  Copyright 2010 Opetopic. All rights reserved.
//

#import "OPTableViewController.h"
#import "OPActiveScrollViewManager.h"
#import "UIView+Opetopic.h"
#import "OPNavigationController.h"
#import "OPTableView.h"
#import "CALayer+Opetopic.h"
#import "UIViewController+Opetopic.h"
#import "UIViewController+OPUIKit.h"
#import "OPMacros.h"
#import "Quartz+Opetopic.h"
#import "UIDevice+Opetopic.h"
#import "UITableView+Opetopic.h"
#import "UIApplication+Opetopic.h"
#import "NSFetchedResultsController+Opetopic.h"
#import "OPTabBarController.h"
#import "OPTabBar.h"
#import "OPTableViewCell.h"
#import "OPViewController.h"
#import "UIScrollView+Opetopic.h"
#import "OPTableSectionView.h"

@interface UIViewController (OPTableViewController)
@property (nonatomic, readonly) BOOL selfOrParentsHidesBottomBarWhenPushed;
@end

#pragma mark Private methods
@interface OPTableViewController (/*Private*/) <OPTableViewDelegate>

@property (nonatomic, assign) BOOL touchIsDown;
@property (nonatomic, assign) CGPoint beginDraggingContentOffset;
@property (nonatomic, assign) BOOL hasUsedFetchedResultsController;

-(void) __init;
-(void) updateCellScrollRatios;

// helper methods for dealing with content size
@property (nonatomic, strong) NSString *lastContentSizeCategory;
-(void) configureForCurrentContentSizeCategory;
+(void) configureForCurrentContentSizeCategory;
@end
#pragma mark -

@implementation OPTableViewController

// OPStyle storage
@synthesize backgroundColor;
@synthesize backgroundImage;
@synthesize defaultTitle;
@synthesize defaultSubtitle;
@synthesize defaultTitleImage;
@synthesize titleFont;
@synthesize subtitleFont;
@synthesize titleColor;
@synthesize titleShadowColor;
@synthesize titleShadowOffset;

#pragma mark -
#pragma mark Class lifecycle methods
#pragma mark -

+(void) initialize {
  [[self class] configureForCurrentContentSizeCategory];
}

#pragma mark -
#pragma mark Object lifecycle
#pragma mark -

-(id) initWithStyle:(UITableViewStyle)style title:(NSString *)title subtitle:(NSString *)subtitle {
	if (! (self = [self initWithStyle:style]))
		return nil;
	
	[self setTitle:title subtitle:subtitle];
	
	return self;
}

-(id) initWithStyle:(UITableViewStyle)style {
	if (! (self = [super initWithStyle:style]))
		return nil;
    [self __init];
	return self;
}

-(id) init {
	if (! (self = [super init]))
		return nil;
    [self __init];
	return self;
}

-(void) __init {
    
    // default ivars
    self.resignKeyboardScrollDelta = 40.0f;
    self.fetchedResultsControllerAnimation = UITableViewRowAnimationAutomatic;
    
    // apply stylings
    [[self styling] applyTo:self];

    if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(preferredContentSizeChanged:)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    }
}

-(void) dealloc {
  if ([self isViewLoaded]) {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
  }

  _fetchedResultsController.delegate = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];

  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
  }
}

-(void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    DLogClassAndMethod();
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
    
    [_fetchedResultsController faultUnfaultedFetchedObjects];
    _fetchedResultsController = nil;
}

#pragma mark -
#pragma mark View lifecycle
#pragma mark -

-(void) loadView {
    [super loadView];
    DLogClassAndMethod();
    [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.loadView object:self];
    
    if (self.useOPTableView)
    {
        OPTableView *v = [[OPTableView alloc] initWithFrame:self.tableView.frame style:self.tableView.style];
        v.autoresizingMask = self.tableView.autoresizingMask;
        v.delegate = self;
        v.dataSource = self;
        self.tableView = v;
    }
    
    if (self.fetchControllerEnterBackgroundActions != OPTableViewFetchControllerActionNone) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnteredBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
}

-(void) viewDidLoad {
    [super viewDidLoad];
    DLogClassAndMethod();
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewDidLoad object:self];
    
    // set up default background color
    if (self.backgroundImage)
    {
        if (! CGSizeIsPowerOfTwo(self.backgroundImage.size)) {
            DLogMessageCompat(@"==============================================================");
            DLogMessageCompat(@"Pattern image drawing is most efficient with power of 2 images");
            DLogMessageCompat(@"==============================================================");
        }
        self.view.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
    }
    else if (self.backgroundColor)
        self.view.backgroundColor = self.backgroundColor;
    else
        self.view.backgroundColor = self.tableView.style == UITableViewStylePlain ? [UIColor whiteColor] : [UIColor groupTableViewBackgroundColor];

    if (self.toolbarView) {
        self.tableView.contentInsetBottom += self.toolbarView.height;
        self.tableView.scrollIndicatorInsetBottom += self.toolbarView.height;
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLogClassAndMethod();
  
    [self configureForCurrentContentSizeCategory];
    [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewWillAppear object:self];
    
    // We try to free up memory by using the OPTableViewFetchControllerActions options, but this can create the following weird
    // situation. You drill down from a table view controller, something triggers that table view to release it's fetch controller,
    // and then you go back. Now the fetch controller gets recomputed and the fetched objects could have changed, yet the table
    // view didn't recompute it's rows and sections. So, bad things can happen. This fixes that situation.
    
    if (! _fetchedResultsController &&
        self.hasUsedFetchedResultsController &&
        (self.fetchControllerEnterBackgroundActions != OPTableViewFetchControllerActionNone || self.fetchControllerViewDisappearActions != OPTableViewFetchControllerActionNone))
    {
        [self.tableView reloadData];
    }

  [self updateCellScrollRatios];

  // set up default navigation item title view
  if (self.defaultTitleImage && !self.navigationItem.titleView && !self.title) {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:self.defaultTitleImage];
  } else if (self.defaultTitle && !self.navigationItem.titleView && !self.title) {
    [self setTitle:self.defaultTitle subtitle:self.defaultSubtitle];
  }
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    DLogClassAndMethod();
    [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewDidAppear object:self];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewWillDisappear object:self];
    
    if (self.tableView.decelerating) {
        [[OPActiveScrollViewManager sharedManager] removeActiveScrollView];
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    DLogClassAndMethod();
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OPViewControllerNotifications.viewDidDisappear object:self];
    
    if (self.fetchControllerViewDisappearActions & OPTableViewFetchControllerActionFlushObjects) {
        [_fetchedResultsController faultUnfaultedFetchedObjects];
    }
    
    if (self.fetchControllerViewDisappearActions & OPTableViewFetchControllerActionRelease) {
        _fetchedResultsController = nil;
    }
}

-(void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self configureForCurrentContentSizeCategory];
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods
#pragma mark -

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    CGPoint p1 = scrollView.contentOffset;
    CGPoint p2 = self.beginDraggingContentOffset;
    if (self.resignKeyboardWhileScrolling && (decelerate || ABS(p1.y-p2.y) >= self.resignKeyboardScrollDelta))
        [self.view endEditing:YES];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [[OPActiveScrollViewManager sharedManager] removeActiveScrollView];
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginDraggingContentOffset = scrollView.contentOffset;
    
    [[OPActiveScrollViewManager sharedManager] addActiveScrollView];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {

  // check if we need to resign the keyboard
  CGPoint p1 = scrollView.contentOffset;
  CGPoint p2 = self.beginDraggingContentOffset;
  if (self.touchIsDown && self.resignKeyboardWhileScrolling && ABS(p1.y-p2.y) >= self.resignKeyboardScrollDelta) {
    [self.view endEditing:YES];
  }

  [self updateCellScrollRatios];
}

#pragma mark -
#pragma mark Overridden methods
#pragma mark -

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.touchIsDown = YES;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.touchIsDown = NO;
}

-(void) setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
    _fetchedResultsController = fetchedResultsController;
    self.hasUsedFetchedResultsController |= (fetchedResultsController != nil);
}

-(void) viewDidLayoutSubviews {
    [self layoutToolbarView];
}

#pragma mark -
#pragma mark UITableView methods
#pragma mark -

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections] objectAtIndex:[self tableViewSectionToFetchedResultsSection:section]] numberOfObjects];
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    Class class = [self tableView:tableView classForHeaderInSection:section];
    if ([class isSubclassOfClass:[OPTableSectionView class]])
        return (CGFloat)[(id)class heightForWidth:self.view.width];
    return 0.0f;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    Class class = [self tableView:tableView classForHeaderInSection:section];
    UIView *header = [class new];
    
    if ([header isKindOfClass:[OPTableSectionView class]]) {
        [(OPTableSectionView*)header setObject:[self tableView:tableView objectForHeaderAtSection:section]];
        [(OPTableSectionView*)header setSection:section];
        [(OPTableSectionView*)header setBackgroundColor:self.view.backgroundColor];
    }
    
    return header;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  Class class = [self tableView:tableView classForRowAtIndexPath:indexPath];
  CGFloat height = tableView.rowHeight;

  if ([class isSubclassOfClass:[OPTableViewCell class]]) {
    NSUInteger numberOfRows = [self tableView:tableView numberOfRowsInSection:indexPath.section];

    if ([class implementsSelector:@selector(heightForCellWidth:isFirst:isLast:)]) {
      height = [class heightForCellWidth:self.view.width isFirst:indexPath.row==0 isLast:indexPath.row==numberOfRows-1];
    } else if ([class implementsSelector:@selector(heightForObject:cellWidth:isFirst:isLast:)]) {
      id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
      height = [class heightForObject:object cellWidth:self.view.width isFirst:indexPath.row==0 isLast:indexPath.row==numberOfRows-1];
    }
  }
  return height;
}

//-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//  Class class = [self tableView:tableView classForRowAtIndexPath:indexPath];
//  CGFloat height = tableView.estimatedRowHeight;
//
//  if ([class isSubclassOfClass:[OPTableViewCell class]]) {
//    NSUInteger numberOfRows = [self tableView:tableView numberOfRowsInSection:indexPath.section];
//
//    if ([class implementsSelector:@selector(estimatedHeightForCellWidth:isFirst:isLast:)]) {
//      height = [class estimatedHeightForCellWidth:self.view.width isFirst:indexPath.row==0 isLast:indexPath.row==numberOfRows-1];
//    } else if ([class implementsSelector:@selector(estimatedHeightForObject:cellWidth:isFirst:isLast:)]) {
//      id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
//      height = [class estimatedHeightForObject:object cellWidth:self.view.width isFirst:indexPath.row==0 isLast:indexPath.row==numberOfRows-1];
//    }
//  }
//
//  return height > 0 ? height : UITableViewAutomaticDimension;
//}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = NSStringFromClass([self tableView:tableView classForRowAtIndexPath:indexPath]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (! cell)
        cell = [[[self tableView:tableView classForRowAtIndexPath:indexPath] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    [self tableView:tableView configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void) tableView:(UITableView*)tableView configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    
    if ([cell isKindOfClass:[OPTableViewCell class]]) {
        [(OPTableViewCell*)cell setFirstInSection:(indexPath.row == 0)];
        [(OPTableViewCell*)cell setFirstSection:(indexPath.section == 0)];
        [(OPTableViewCell*)cell setLastInSection:(indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1)];
        [(OPTableViewCell*)cell setLastSection:(indexPath.section == [self numberOfSectionsInTableView:tableView]-1)];
        [(OPTableViewCell*)cell setEven:(indexPath.row % 2 == 0)];
        [(OPTableViewCell*)cell setIndexPath:indexPath];
        [(OPTableViewCell*)cell setObject:[self tableView:tableView objectForRowAtIndexPath:indexPath]];
    }
}

-(Class) tableView:(UITableView*)tableView classForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [UITableViewCell class];
}

-(Class) tableView:(UITableView *)tableView classForHeaderInSection:(NSInteger)section {
    return nil;
}

-(id) tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:[self tableViewIndexPathToFetchedResultsIndexPath:indexPath]];
}

-(id) tableView:(UITableView *)tableView objectForHeaderAtSection:(NSInteger)section {
    return nil;
}

-(NSInteger) tableViewSectionToFetchedResultsSection:(NSUInteger)section {
    return section;
}

-(NSInteger) fetchedResultsSectionToTableViewSection:(NSUInteger)section {
    return section;
}

-(NSIndexPath*) tableViewIndexPathToFetchedResultsIndexPath:(NSIndexPath*)indexPath {
    return indexPath;
}

-(NSIndexPath*) fetchedResultsIndexPathToTableViewIndexPath:(NSIndexPath*)indexPath {
    return indexPath;
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
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:[self fetchedResultsSectionToTableViewSection:sectionIndex]]
                          withRowAnimation:self.fetchedResultsControllerAnimation];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:[self fetchedResultsSectionToTableViewSection:sectionIndex]] 
                          withRowAnimation:self.fetchedResultsControllerAnimation];
            break;
    }
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[[self fetchedResultsIndexPathToTableViewIndexPath:newIndexPath]]
                             withRowAnimation:self.fetchedResultsControllerAnimation];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[[self fetchedResultsIndexPathToTableViewIndexPath:indexPath]] 
                             withRowAnimation:self.fetchedResultsControllerAnimation];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self tableView:tableView 
              configureCell:[tableView cellForRowAtIndexPath:[self fetchedResultsIndexPathToTableViewIndexPath:indexPath]] 
                atIndexPath:[self fetchedResultsIndexPathToTableViewIndexPath:indexPath]];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[[self fetchedResultsIndexPathToTableViewIndexPath:indexPath]] 
                             withRowAnimation:self.fetchedResultsControllerAnimation];
            [tableView insertRowsAtIndexPaths:@[[self fetchedResultsIndexPathToTableViewIndexPath:newIndexPath]] 
                             withRowAnimation:self.fetchedResultsControllerAnimation];
            break;
    }
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
  [self updateCellScrollRatios];
}

#pragma mark -
#pragma mark Custom getters/setters
#pragma mark -

-(void) setUseOPTableView:(BOOL)useOPTableView {
    _useOPTableView = useOPTableView;
    
    // if the view is loaded then check if we need to swap out the table views
    if ([self isViewLoaded])
    {
        if (self.useOPTableView && ! [self.tableView isKindOfClass:[OPTableView class]])
        {
            self.tableView = nil;
            OPTableView *v = [[OPTableView alloc] initWithFrame:self.tableView.frame style:self.tableView.style];
            v.autoresizingMask = self.tableView.autoresizingMask;
            self.tableView = v;
        }
        else if (! self.useOPTableView && [self.tableView isKindOfClass:[OPTableView class]])
        {
            self.tableView = nil;
            UITableView *v = [[UITableView alloc] initWithFrame:self.tableView.frame style:self.tableView.style];
            v.autoresizingMask = self.tableView.autoresizingMask;
            self.tableView = v;
        }
    }
}

#pragma mark -
#pragma mark Notification methods
#pragma mark -

-(void) appEnteredBackground {
    
    if (self.fetchControllerEnterBackgroundActions != OPTableViewFetchControllerActionNone)
    {
        [[UIApplication sharedApplication] performBackgroundTaskOnMainThread:^{
            
            if (self.fetchControllerEnterBackgroundActions & OPTableViewFetchControllerActionFlushObjects) {
                [_fetchedResultsController faultUnfaultedFetchedObjects];
            }
            
            if (self.fetchControllerEnterBackgroundActions & OPTableViewFetchControllerActionRelease) {
                _fetchedResultsController = nil;
            }
            
        } completion:nil expiration:nil];
    }
}

-(void) appEnteredForeground {
    if (! _fetchedResultsController &&
        [self isViewVisible] &&
        self.hasUsedFetchedResultsController &&
        self.fetchControllerEnterBackgroundActions != OPTableViewFetchControllerActionNone)
    {
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark Preferred content size methods
#pragma mark -

-(void) preferredContentSizeChanged:(NSNotification*)notification {
  dispatch_next_runloop(^{
    [[self class] configureForCurrentContentSizeCategory];
    [self configureForCurrentContentSizeCategory];
  });
}

-(void) configureForContentSizeCategory:(NSString *)category {
  if ([self isViewLoaded] && [self isViewVisible]) {
      [self.tableView reloadData];
  }
}

+(void) configureForContentSizeCategory:(NSString *)category {
}

#pragma mark -
#pragma mark Private helper methods for preferred content size
#pragma mark -

-(void) configureForCurrentContentSizeCategory {
  NSString *currentContentSizeCategory = @"";
  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    currentContentSizeCategory = [[UIApplication sharedApplication] preferredContentSizeCategory];
  }

  if (! currentContentSizeCategory || ! [self.lastContentSizeCategory isEqualToString:currentContentSizeCategory]) {
    self.lastContentSizeCategory = currentContentSizeCategory ?: @"";
    [self configureForContentSizeCategory:currentContentSizeCategory];
  }
}

+(void) configureForCurrentContentSizeCategory {
  static NSMutableDictionary *lastContentSizeCategoryByClass = nil;
  lastContentSizeCategoryByClass = lastContentSizeCategoryByClass ?: [NSMutableDictionary new];

  NSString *classString = NSStringFromClass(self.class);
  NSString *currentContentSizeCategory = nil;
  NSString *lastContentSizeCategory = lastContentSizeCategoryByClass[classString];
  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    currentContentSizeCategory = [[UIApplication sharedApplication] preferredContentSizeCategory];
  }

  if (! currentContentSizeCategory || ! [lastContentSizeCategory isEqualToString:currentContentSizeCategory]) {
    lastContentSizeCategoryByClass[classString] = currentContentSizeCategory ?: @"";
    [[self class] configureForContentSizeCategory:currentContentSizeCategory];
  }
}

#pragma mark -
#pragma mark Private methods
#pragma mark -

-(void) updateCellScrollRatios {

  for (OPTableViewCell *cell in self.tableView.visibleCells) {
    CGFloat y = cell.frame.origin.y - self.tableView.contentOffsetY;

    // TODO: fix this hackiness. If I do the right thing and use topLayoutGuide, then
    // a weird bug appears where everytime you drill down to content the table view
    // scrolls back to the top.
    if ([UIDevice isiOS7OrLater]) {
      y -= 64.0f;
    }

    [OPTypedAs(cell, OPTableViewCell) setScrollRatio:-y / cell.height];
  }
}

#pragma mark -
#pragma mark UIRefreshControl methods
#pragma mark -

-(UIRefreshControl*) refreshControl {
    if ([UITableViewController instancesRespondToSelector:@selector(refreshControl)]) {
        return [super refreshControl];
    }
    return nil;
}

-(void) setRefreshControl:(UIRefreshControl *)refreshControl {
    if ([UITableViewController instancesRespondToSelector:@selector(setRefreshControl:)]) {
        [super setRefreshControl:refreshControl];
    }
}

@end


@implementation UIViewController (OPTableViewController)
-(BOOL) selfOrParentsHidesBottomBarWhenPushed {
    BOOL retVal = NO;
    UIViewController *controller = self;
    while (! retVal && controller) {
        retVal = controller.hidesBottomBarWhenPushed;
        controller = controller.parentViewController;
    }
    return retVal;
}
@end
