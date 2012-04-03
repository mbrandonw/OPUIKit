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
#import "CALayer+Opetopic.h"
#import "UIViewController+Opetopic.h"
#import "UIViewController+OPUIKit.h"
#import "OPMacros.h"
#import "Quartz+Opetopic.h"
#import "UIDevice+Opetopic.h"

#define kScrollingDidStopDelay  0.3f

UITableViewRowAnimation UITableViewRowAnimationAutomaticOr(UITableViewRowAnimation rowAnimation) {
    if ([UIDevice isAtLeastiOS5])
        return UITableViewRowAnimationAutomatic;
    return rowAnimation;
}

#pragma mark Private methods
@interface OPTableViewController (/*Private*/)
@property (nonatomic, assign) BOOL touchIsDown;
@property (nonatomic, assign) CGPoint beginDraggingContentOffset;
@property (nonatomic, assign, readwrite) CGPoint contentOffsetVelocity;
@property (nonatomic, assign) NSTimeInterval lastDragTimeInterval;
@property (nonatomic, assign) CGPoint lastContentOffset;

@property (nonatomic, strong, readwrite) CAGradientLayer *originShadowLayer;
@property (nonatomic, strong, readwrite) CAGradientLayer *topShadowLayer;
@property (nonatomic, strong, readwrite) CAGradientLayer *bottomShadowLayer;

-(void) __init;
-(void) scrollingDidStop;
-(void) layoutShadows;
@end
#pragma mark -

@implementation OPTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize tableViewShadows = _tableViewShadows;
@synthesize originShadowLayer = _originShadowLayer;
@synthesize topShadowLayer = _topShadowLayer;
@synthesize bottomShadowLayer = _bottomShadowLayer;
@synthesize resignKeyboardWhileScrolling = _resignKeyboardWhileScrolling;
@synthesize resignKeyboardScrollDelta = _resignKeyboardScrollDelta;
@synthesize beginDraggingContentOffset = _beginDraggingContentOffset;
@synthesize touchIsDown = _touchIsDown;
@synthesize contentOffsetVelocity = _contentOffsetVelocity;
@synthesize lastDragTimeInterval = _lastDragTimeInterval;
@synthesize lastContentOffset = _lastContentOffset;

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
    
    self.originShadowLayer = [CAGradientLayer new];
    self.originShadowLayer.height = 10.0f;
    self.originShadowLayer.colors = [NSArray arrayWithObjects:
                                     (id)[UIColor colorWithWhite:0.0f alpha:0.2f].CGColor, 
                                     (id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor, nil];
    
    self.topShadowLayer = [CAGradientLayer new];
    self.topShadowLayer.height = 10.0f;
    self.topShadowLayer.colors = [NSArray arrayWithObjects:
                                  (id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor, 
                                  (id)[UIColor colorWithWhite:0.0f alpha:0.2f].CGColor, nil];
    
    self.bottomShadowLayer = [CAGradientLayer new];
    self.bottomShadowLayer.height = 20.0f;
    self.bottomShadowLayer.colors = [NSArray arrayWithObjects:
                                  (id)[UIColor colorWithWhite:0.0f alpha:0.25f].CGColor, 
                                  (id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor, nil];
    
    // apply stylings
    [[self styling] applyTo:self];
}

-(void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    DLogClassAndMethod();
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
    
    for (NSManagedObject *obj in [self.fetchedResultsController fetchedObjects])
        if (! [obj isFault] && ! [obj hasChanges])
            [obj.managedObjectContext refreshObject:obj mergeChanges:NO];
}

#pragma mark -
#pragma mark View lifecycle
#pragma mark -

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
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self performSelector:@selector(scrollingDidStop) withObject:nil afterDelay:0.3f];
    [self layoutShadows];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.tableView.decelerating)
        [[OPActiveScrollViewManager sharedManager] removeActiveScrollView];
}

-(void) viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

-(UITableView*) activeTableView {
    return self.searchDisplayController.active ? self.searchDisplayController.searchResultsTableView : self.tableView;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods
#pragma mark -

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (! decelerate) {
		[self performSelector:@selector(scrollingDidStop) withObject:nil afterDelay:kScrollingDidStopDelay];
	}
    
    CGPoint p1 = scrollView.contentOffset;
    CGPoint p2 = self.beginDraggingContentOffset;
    if (self.resignKeyboardWhileScrolling && (decelerate || ABS(p1.y-p2.y) >= self.resignKeyboardScrollDelta))
        [self.view endEditing:YES];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self performSelector:@selector(scrollingDidStop) withObject:nil afterDelay:kScrollingDidStopDelay];
    
    [[OPActiveScrollViewManager sharedManager] removeActiveScrollView];
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	[self performSelector:@selector(scrollingDidStop) withObject:nil afterDelay:kScrollingDidStopDelay];
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
}

-(void) scrollingDidStop {
    
    self.lastContentOffset = CGPointMax;
	
	// loop through the visibile table cells to notify them of scroll stopping
    
	UITableView *tableView = nil;
    if (self.searchDisplayController.active)
        tableView = self.searchDisplayController.searchResultsTableView;
    else if ([self isViewLoaded])
        tableView = self.tableView;
    
	for (UITableViewCell *cell in [tableView visibleCells])
	{
		if ([cell respondsToSelector:@selector(scrollingDidStop)])
			[cell performSelector:@selector(scrollingDidStop)];
	}
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

#pragma mark -
#pragma mark Data source methods
#pragma mark -

-(void) reloadData {
	
	if (self.searchDisplayController.active)
		[self.searchDisplayController.searchResultsTableView reloadData];
	else if ([self isViewLoaded])
		[self.tableView reloadData];
	
	[self performSelector:@selector(scrollingDidStop) withObject:nil afterDelay:kScrollingDidStopDelay];
}

#pragma mark -
#pragma mark UITableView methods
#pragma mark -

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

-(void) tableView:(UITableView*)tableView configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
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
                          withRowAnimation:UITableViewRowAnimationAutomaticOr(UITableViewRowAnimationFade)];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] 
                          withRowAnimation:UITableViewRowAnimationAutomaticOr(UITableViewRowAnimationFade)];
            break;
    }
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] 
                             withRowAnimation:UITableViewRowAnimationAutomaticOr(UITableViewRowAnimationFade)];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                             withRowAnimation:UITableViewRowAnimationAutomaticOr(UITableViewRowAnimationFade)];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self tableView:tableView configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                             withRowAnimation:UITableViewRowAnimationAutomaticOr(UITableViewRowAnimationFade)];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] 
                             withRowAnimation:UITableViewRowAnimationAutomaticOr(UITableViewRowAnimationFade)];
            break;
    }
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self scrollingDidStop];
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

#pragma mark -
#pragma mark Private methods
#pragma mark -

-(void) layoutShadows {
    
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

@end
