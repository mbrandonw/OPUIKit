//
//  OPTableViewController.m
//  MiStryker
//
//  Created by Brandon Williams on 12/7/10.
//  Copyright 2010 Opetopic. All rights reserved.
//

#import "OPTableViewController.h"
#import "UIView+Opetopic.h"
//#import "OPTableView.h"
#import "UIViewController+Opetopic.h"
#import "OPMacros.h"

#pragma mark Styling vars
static UIColor *OPTableViewControllerDefaultBackgroundColor;
static UIColor *OPTableViewControllerDefaultTitleTextColor;
static UIColor *OPTableViewControllerDefaultTitleShadowColor;
static CGSize OPTableViewControllerDefaultTitleShadowOffset;
static UIImage *OPTableViewControllerDefaultTitleImage;
#pragma mark -

#pragma mark Private methods
@interface OPTableViewController (/*Private*/)
@property (nonatomic, assign) BOOL touchIsDown;
@property (nonatomic, assign) CGPoint beginDraggingContentOffset;
-(void) lazilyLoadImages;
@end
#pragma mark -

@implementation OPTableViewController

@synthesize useOPTableView;
@synthesize resignKeyboardWhileScrolling;
@synthesize restoreExpandableSelectionOnViewWillAppear;
@synthesize beginDraggingContentOffset;
@synthesize touchIsDown;

#pragma mark Styling methods
+(void) setDefaultBackgroundColor:(UIColor*)color {
	OPTableViewControllerDefaultBackgroundColor = color;
}

+(void) setDefaultTitleTextColor:(UIColor*)color {
	OPTableViewControllerDefaultTitleTextColor = color;
}

+(void) setDefaultTitleShadowColor:(UIColor*)color {
	OPTableViewControllerDefaultTitleShadowColor = color;
}

+(void) setDefaultTitleShadowOffset:(CGSize)offset {
    OPTableViewControllerDefaultTitleShadowOffset = offset;
}

+(void) setDefaultTitleImage:(UIImage*)image {
	OPTableViewControllerDefaultTitleImage = image;
}
#pragma mark -


#pragma mark Object lifecycle
-(id) initWithStyle:(UITableViewStyle)style title:(NSString *)title subtitle:(NSString *)subtitle {
	if (! (self = [self initWithStyle:style]))
		return nil;
	
	[self setTitle:title subtitle:subtitle];
	
	return self;
}

-(id) initWithStyle:(UITableViewStyle)style {
	if (! (self = [super initWithStyle:style]))
		return nil;
	
	self.navigationItem.titleView = [[UIImageView alloc] initWithImage:OPTableViewControllerDefaultTitleImage];
	
	return self;
}

-(id) init {
	if (! (self = [super init]))
		return nil;
	
	self.navigationItem.titleView = [[UIImageView alloc] initWithImage:OPTableViewControllerDefaultTitleImage];
	
	return self;
}

- (void)didReceiveMemoryWarning {
	DLog(@"");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}
#pragma mark -


#pragma mark View lifecycle
-(void) loadView {
    [super loadView];
    
//    if (self.useOPTableView)
//        self.tableView = [[[OPTableView alloc] initWithFrame:self.tableView.frame style:self.tableView.style] autorelease];
    
    // default the background color if the view doesn't already have one
    if (OPTableViewControllerDefaultBackgroundColor)
        self.tableView.backgroundColor = OPTableViewControllerDefaultBackgroundColor;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // reselect the expanded row if needed
//    if (self.restoreExpandableSelectionOnViewWillAppear && [self.opTableView.expandedIndexPaths count] == 1) {
//        [NSObject performBlockNextRunloop:^{
//            [self.opTableView selectRowAtIndexPath:[self.opTableView.expandedIndexPaths lastObject] animated:NO scrollPosition:UITableViewScrollPositionNone];
//        }];
//    }
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self performSelector:@selector(lazilyLoadImages) withObject:nil afterDelay:0.3f];
    
    if (OP_NAVIGATION_CONTROLLER_SIMULATE_MEMORY_WARNINGS)
        [self simulateMemoryWarning];
    
    DLog(@"%@", OPCoalesce(self.title, NSStringFromClass([self class])));
}

-(UITableView*) activeTableView {
    return self.searchDisplayController.active ? self.searchDisplayController.searchResultsTableView : self.tableView;
}

-(OPTableView*) opTableView {
//    return [self.tableView isKindOfClass:[OPTableView class]] ? (OPTableView*)self.tableView : nil;
    return nil;
}
#pragma mark -


#pragma mark Titling methods
-(void) setTitle:(NSString *)title {
    [self setTitle:title subtitle:nil];
}

-(void) setTitle:(NSString*)title subtitle:(NSString*)subtitle {
    
    [super setTitle:title];
	
	UIView *wrapper = [[UIView alloc] initWithFrame:CGRectZero];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.text = title;
	titleLabel.textColor = OPTableViewControllerDefaultTitleTextColor;
	titleLabel.shadowColor = OPTableViewControllerDefaultTitleShadowColor;
	titleLabel.shadowOffset = OPTableViewControllerDefaultTitleShadowOffset;
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.font = [UIFont boldSystemFontOfSize:subtitle ? 15.0f : 18.0f];
	titleLabel.numberOfLines = 1;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.opaque = NO;
	titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	[titleLabel sizeToFit];
	titleLabel.width = MIN(titleLabel.width, 190.0f);
	
	UILabel *subtitleLabel = nil;
	if (subtitle != nil) {
		subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		subtitleLabel.text = subtitle;
		subtitleLabel.textColor = OPTableViewControllerDefaultTitleTextColor;
		subtitleLabel.shadowColor = OPTableViewControllerDefaultTitleShadowColor;
		subtitleLabel.shadowOffset = OPTableViewControllerDefaultTitleShadowOffset;
		subtitleLabel.textAlignment = UITextAlignmentCenter;
		subtitleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		subtitleLabel.numberOfLines = 1;
		subtitleLabel.backgroundColor = [UIColor clearColor];
		subtitleLabel.opaque = NO;
		subtitleLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[subtitleLabel sizeToFit];
		subtitleLabel.width = MIN(subtitleLabel.width, 190.0f);
	}
	
	CGFloat maxWidth = MAX(titleLabel.frame.size.width, subtitleLabel.frame.size.width);
	wrapper.frame = CGRectMake(0.0, 0.0, maxWidth, 44.0);
	titleLabel.frame = CGRectMake(0.0, (subtitle ? 4.0 : 11.0), maxWidth, 20.0);
	[wrapper addSubview:titleLabel];
	
	if (subtitleLabel) {
		subtitleLabel.frame = CGRectMake(0.0, 22.0, maxWidth, 16.0);
		[wrapper addSubview:subtitleLabel];
	}
	
	self.navigationItem.titleView = wrapper;
}
#pragma mark -


#pragma mark UIScrollViewDelegate methods
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (! decelerate) {
		[self lazilyLoadImages];
	}
    
    CGPoint p1 = scrollView.contentOffset;
    CGPoint p2 = self.beginDraggingContentOffset;
    if (self.resignKeyboardWhileScrolling && (decelerate || ((p1.x-p2.x)*(p1.x-p2.x) + (p1.y-p2.y)*(p1.y-p2.y)) > 1600.0f))
        [self.view endEditing:YES];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self lazilyLoadImages];
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	[self lazilyLoadImages];
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginDraggingContentOffset = scrollView.contentOffset;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint p1 = scrollView.contentOffset;
    CGPoint p2 = self.beginDraggingContentOffset;
    if (self.touchIsDown && self.resignKeyboardWhileScrolling && ((p1.x-p2.x)*(p1.x-p2.x) + (p1.y-p2.y)*(p1.y-p2.y)) > 1600.0f)
        [self.view endEditing:YES];
}

-(void) lazilyLoadImages {
	
	// loop through the visibile table cells to lazily load any images the cells may have
	UITableView *tableView = self.searchDisplayController.active ? self.searchDisplayController.searchResultsTableView : self.tableView;
	for (UITableViewCell *cell in [tableView visibleCells])
	{
		if ([cell respondsToSelector:@selector(lazilyLoadImages)])
			[cell performSelector:@selector(lazilyLoadImages)];
	}
}
#pragma mark -


#pragma mark Touch methods
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touchIsDown = YES;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touchIsDown = NO;
}
#pragma mark -


#pragma mark Data source methods
-(void) reloadData {
	
	if (self.searchDisplayController.active)
		[self.searchDisplayController.searchResultsTableView reloadData];
	else
		[self.tableView reloadData];
	
	[self lazilyLoadImages];
}
#pragma mark -


#pragma mark UITableView methods
-(void) tableView:(UITableView*)tableView configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    
}
#pragma mark -


#pragma mark NSFetchedResultsController methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self tableView:tableView configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
#pragma mark -


#pragma mark Memory methods
-(void) simulateMemoryWarning {
#if TARGET_IPHONE_SIMULATOR && defined(DEBUG)
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"UISimulatedMemoryWarningNotification", NULL, NULL, true);
#endif
}
#pragma mark -

@end
