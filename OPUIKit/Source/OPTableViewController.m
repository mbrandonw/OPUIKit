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
#import "OPCustomTableViewCell.h"

UITableViewRowAnimation OPCoalesceTableViewRowAnimation(UITableViewRowAnimation rowAnimation);
UITableViewRowAnimation OPCoalesceTableViewRowAnimation(UITableViewRowAnimation rowAnimation) {
    if (rowAnimation == NSIntegerMax)
        return UITableViewRowAnimationAutomaticOr(UITableViewRowAnimationFade);
    return rowAnimation;
}

@interface UIViewController (OPTableViewController)
@property (nonatomic, readonly) BOOL selfOrParentsHidesBottomBarWhenPushed;
@end

#pragma mark Private methods
@interface OPTableViewController (/*Private*/) <OPTableViewDelegate>

@property (nonatomic, assign) BOOL touchIsDown;
@property (nonatomic, assign) CGPoint beginDraggingContentOffset;
@property (nonatomic, assign, readwrite) CGPoint contentOffsetVelocity;
@property (nonatomic, assign) NSTimeInterval lastDragTimeInterval;
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, assign) BOOL hasUsedFetchedResultsController;

@property (nonatomic, strong, readwrite) CAGradientLayer *originShadowLayer;
@property (nonatomic, strong, readwrite) CAGradientLayer *topShadowLayer;
@property (nonatomic, strong, readwrite) CAGradientLayer *bottomShadowLayer;

-(void) __init;
-(void) layoutShadows;
@end
#pragma mark -

@implementation OPTableViewController

@synthesize tableViewShadows = _tableViewShadows;
@synthesize originShadowLayer = _originShadowLayer;
@synthesize topShadowLayer = _topShadowLayer;
@synthesize bottomShadowLayer = _bottomShadowLayer;
@synthesize useOPTableView = _useOPTableView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize fetchedResultsControllerAnimation = _fetchedResultsControllerAnimation;
@synthesize resignKeyboardWhileScrolling = _resignKeyboardWhileScrolling;
@synthesize resignKeyboardScrollDelta = _resignKeyboardScrollDelta;
@synthesize beginDraggingContentOffset = _beginDraggingContentOffset;
@synthesize touchIsDown = _touchIsDown;
@synthesize contentOffsetVelocity = _contentOffsetVelocity;
@synthesize lastDragTimeInterval = _lastDragTimeInterval;
@synthesize lastContentOffset = _lastContentOffset;
@synthesize toolbarView = _toolbarView;

// OPStyle storage
@synthesize backgroundColor = _backgroundColor;
@synthesize backgroundImage = _backgroundImage;
@synthesize defaultTitle = _defaultTitle;
@synthesize defaultSubtitle = _defaultSubtitle;
@synthesize defaultTitleImage = _defaultTitleImage;
@synthesize titleFont = _titleFont;
@synthesize subtitleFont = _subtitleFont;
@synthesize titleColor = _titleColor;
@synthesize titleShadowColor = _titleShadowColor;
@synthesize titleShadowOffset = _titleShadowOffset;

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
    self.fetchedResultsControllerAnimation = UITableViewRowAnimationNone;
    
    self.originShadowLayer = [CAGradientLayer new];
    self.originShadowLayer.height = 10.0f;
    self.originShadowLayer.colors = @[(id)[UIColor colorWithWhite:0.0f alpha:0.1f].CGColor, 
                                     (id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor];
    
    self.topShadowLayer = [CAGradientLayer new];
    self.topShadowLayer.height = 10.0f;
    self.topShadowLayer.colors = @[(id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor, 
                                  (id)[UIColor colorWithWhite:0.0f alpha:0.1f].CGColor];
    
    self.bottomShadowLayer = [CAGradientLayer new];
    self.bottomShadowLayer.height = 20.0f;
    self.bottomShadowLayer.colors = @[(id)[UIColor colorWithWhite:0.0f alpha:0.1f].CGColor, 
                                  (id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor];
    
    // apply stylings
    [[self styling] applyTo:self];
}

-(void) dealloc {
    _fetchedResultsController.delegate = nil;
}

-(void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    DLogClassAndMethod();
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
    
    [self.fetchedResultsController faultUnfaultedFetchedObjects];
    self.fetchedResultsController = nil;
}

#pragma mark -
#pragma mark View lifecycle
#pragma mark -

-(void) loadView {
    [super loadView];
    
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnteredBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

-(void) viewDidLoad {
    [super viewDidLoad];
    DLogClassAndMethod();
    
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
    
    // set up default navigation item title view
    if (self.defaultTitleImage && !self.navigationItem.titleView)
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:self.defaultTitleImage];
    if (self.defaultTitle && !self.title)
        [self setTitle:self.defaultTitle subtitle:self.defaultSubtitle];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.toolbarView) {
        [self.toolbarView bringToFront];
        [self scrollViewDidScroll:self.tableView];
    }
    
    // We try to free up memory by using the OPTableViewFetchControllerActions options, but this can create the following weird
    // situation. You drill down from a table view controller, something triggers that table view to release it's fetch controller,
    // and then you go back. Now the fetch controller gets recomputed and the fetched objects could have changed, yet the table
    // view didn't recompute it's rows and sections. So, bad things can happen. This fixes that situation.
    
    if (self.hasUsedFetchedResultsController && (self.fetchControllerEnterBackgroundActions != OPTableViewFetchControllerActionNone || self.fetchControllerViewDisappearActions != OPTableViewFetchControllerActionNone))
    {
        [self.tableView reloadData];
    }
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    [self layoutShadows];
    [self.toolbarView bringToFront];
    
    // this is a hacky thing to get the prevent the shifting of the table view when transitioning to a controller
    // that chooses to hide the bottom bar
    if (self.tabController && ! self.selfOrParentsHidesBottomBarWhenPushed) {
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top,
                                                       self.tableView.contentInset.left,
                                                       MAX(0.0f, self.tableView.contentInset.bottom - self.tabController.tabBar.height),
                                                       self.tableView.contentInset.right);
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.tableView.decelerating)
        [[OPActiveScrollViewManager sharedManager] removeActiveScrollView];
    
    // this is a hacky thing to get the prevent the shifting of the table view when transitioning to a controller
    // that chooses to hide the bottom bar
    if (self.tabController && ! self.selfOrParentsHidesBottomBarWhenPushed) {
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top,
                                                       self.tableView.contentInset.left,
                                                       self.tableView.contentInset.bottom + self.tabController.tabBar.height,
                                                       self.tableView.contentInset.right);
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.fetchControllerViewDisappearActions & OPTableViewFetchControllerActionFlushObjects)
        [self.fetchedResultsController faultUnfaultedFetchedObjects];
    
    if (self.fetchControllerViewDisappearActions & OPTableViewFetchControllerActionRelease)
        self.fetchedResultsController = nil;
}

-(void) viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
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
    
    // layout the shadows if we are using any
    if (self.tableViewShadows != OPTableViewControllerShadowNone)
    {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        [self layoutShadows];
        [CATransaction commit];
    }
    
    // computes the velocity of the content offset
    if (CGPointEqualToPoint(self.lastContentOffset, CGPointMax))
    {
        self.lastContentOffset = scrollView.contentOffset;
        self.lastDragTimeInterval = [NSDate timeIntervalSinceReferenceDate];
    }
    else
    {
        CGFloat timeDelta = (CGFloat)([NSDate timeIntervalSinceReferenceDate] - self.lastDragTimeInterval);
        CGPoint contentOffsetDelta = CGPointMake(scrollView.contentOffset.x-self.lastContentOffset.x, scrollView.contentOffset.y-self.lastContentOffset.y);
        
        self.contentOffsetVelocity = CGPointMake(contentOffsetDelta.x/timeDelta, contentOffsetDelta.y/timeDelta);
        
        self.lastContentOffset = scrollView.contentOffset;
        self.lastDragTimeInterval = [NSDate timeIntervalSinceReferenceDate];
    }
    
    // check if we need to resign the keyboard
    CGPoint p1 = scrollView.contentOffset;
    CGPoint p2 = self.beginDraggingContentOffset;
    if (self.touchIsDown && self.resignKeyboardWhileScrolling && ABS(p1.y-p2.y) >= self.resignKeyboardScrollDelta)
        [self.view endEditing:YES];
    
    // snap the toolbar to the bottom
    self.toolbarView.bottom = self.view.height + scrollView.contentOffset.y;
    [self.toolbarView bringToFront];
}

#pragma mark -
#pragma mark Overridden touch methods
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
    self.hasUsedFetchedResultsController = YES;
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

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Class class = [self tableView:tableView classForRowAtIndexPath:indexPath];
    if ([class isSubclassOfClass:[OPCustomTableViewCell class]])
    {
        id object = [self.fetchedResultsController objectAtIndexPath:[self tableViewIndexPathToFetchedResultsIndexPath:indexPath]];
        return (CGFloat)[(id)class heightForObject:object cellWidth:self.view.width];
    }
    return 44.0f;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = NSStringFromClass([self tableView:tableView classForRowAtIndexPath:indexPath]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (! cell)
        cell = [[[self tableView:tableView classForRowAtIndexPath:indexPath] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    return cell;
}

-(void) tableView:(UITableView*)tableView configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
}

-(Class) tableView:(UITableView*)tableView classForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [UITableViewCell class];
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
                          withRowAnimation:OPCoalesceTableViewRowAnimation(self.fetchedResultsControllerAnimation)];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:[self fetchedResultsSectionToTableViewSection:sectionIndex]] 
                          withRowAnimation:OPCoalesceTableViewRowAnimation(self.fetchedResultsControllerAnimation)];
            break;
    }
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[[self fetchedResultsIndexPathToTableViewIndexPath:newIndexPath]]
                             withRowAnimation:OPCoalesceTableViewRowAnimation(self.fetchedResultsControllerAnimation)];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[[self fetchedResultsIndexPathToTableViewIndexPath:indexPath]] 
                             withRowAnimation:OPCoalesceTableViewRowAnimation(self.fetchedResultsControllerAnimation)];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self tableView:tableView 
              configureCell:[tableView cellForRowAtIndexPath:[self fetchedResultsIndexPathToTableViewIndexPath:indexPath]] 
                atIndexPath:[self fetchedResultsIndexPathToTableViewIndexPath:indexPath]];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[[self fetchedResultsIndexPathToTableViewIndexPath:indexPath]] 
                             withRowAnimation:OPCoalesceTableViewRowAnimation(self.fetchedResultsControllerAnimation)];
            [tableView insertRowsAtIndexPaths:@[[self fetchedResultsIndexPathToTableViewIndexPath:newIndexPath]] 
                             withRowAnimation:OPCoalesceTableViewRowAnimation(self.fetchedResultsControllerAnimation)];
            break;
    }
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark -
#pragma mark Custom getters/setters
#pragma mark -

-(void) setTableViewShadows:(OPTableViewControllerShadows)tableViewShadows {
    _tableViewShadows = tableViewShadows;
    
    // check if we need to remove any of the shadow layers
    if (! (_tableViewShadows & OPTableViewControllerShadowOrigin))
        [self.originShadowLayer removeFromSuperlayer];
    if (! (_tableViewShadows & OPTableViewControllerShadowTop))
        [self.topShadowLayer removeFromSuperlayer];
    if (! (_tableViewShadows & OPTableViewControllerShadowBottom))
        [self.bottomShadowLayer removeFromSuperlayer];
}

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

-(void) setToolbarView:(UIView *)toolbarView {
    [_toolbarView removeFromSuperview];
    _toolbarView = toolbarView;
    [self.view addSubview:_toolbarView];
    
    _toolbarView.width = self.view.width;
    _toolbarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top,
                                                   self.tableView.contentInset.left,
                                                   self.tableView.contentInset.bottom + _toolbarView.height,
                                                   self.tableView.contentInset.right);
}

#pragma mark -
#pragma mark Private methods
#pragma mark -

-(void) layoutShadows {
    
    // don't ever use shadows on grouped table views
    if (! [self isViewLoaded] || self.tableView.style == UITableViewStyleGrouped)
        return ;
    
    if (self.tableViewShadows & OPTableViewControllerShadowOrigin)
    {
        if (self.tableView.contentOffset.y >= 0.0f)
            [self.originShadowLayer removeFromSuperlayer];
        else
        {
            self.originShadowLayer.top = self.tableView.contentOffset.y;
            self.originShadowLayer.width = self.tableView.width;
            [self.tableView.layer insertSublayer:self.originShadowLayer atIndex:0];
        }
    }
    
    if (self.tableViewShadows & OPTableViewControllerShadowTop)
    {
        if (self.tableView.contentOffset.y >= 0.0f)
            [self.topShadowLayer removeFromSuperlayer];
        else
        {
            self.topShadowLayer.top = -self.topShadowLayer.height;
            self.topShadowLayer.width = self.tableView.width;
            [self.tableView.layer insertSublayer:self.topShadowLayer atIndex:0];
        }
    }
    
    if (self.tableViewShadows & OPTableViewControllerShadowBottom)
    {
        if (self.tableView.contentOffset.y + self.tableView.height <= self.tableView.contentSize.height)
            [self.bottomShadowLayer removeFromSuperlayer];
        else
        {
            self.bottomShadowLayer.top = self.tableView.contentSize.height;
            self.bottomShadowLayer.width = self.tableView.width;
            [self.tableView.layer insertSublayer:self.bottomShadowLayer atIndex:0];
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
            
            if (self.fetchControllerEnterBackgroundActions & OPTableViewFetchControllerActionFlushObjects)
                [self.fetchedResultsController faultUnfaultedFetchedObjects];
            
            if (self.fetchControllerEnterBackgroundActions & OPTableViewFetchControllerActionRelease)
                self.fetchedResultsController = nil;
            
        } completion:nil expiration:nil];
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