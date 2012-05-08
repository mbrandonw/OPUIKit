//
//  OPTableView.m
//  Kickstarter
//
//  Created by Brandon Williams on 4/27/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import "OPTableView.h"
#import <objc/runtime.h>

@interface OPTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) NSObject<UITableViewDataSource> *realDataSource;
@property (nonatomic, weak) NSObject<OPTableViewDelegate> *realDelegate;
@property (nonatomic, assign) BOOL dataSourceIsSelf;
@property (nonatomic, assign) BOOL delegateIsSelf;

@property (nonatomic, strong) NSIndexPath *snappedIndexPath;
@property (nonatomic, assign) CGPoint contentOffsetDelta;

-(void) snapScrolling;
@end

@implementation OPTableView

@synthesize horizontal = _horizontal;
@synthesize snapToRows = _snapToRows;
@synthesize realDataSource = _realDataSource;
@synthesize realDelegate = _realDelegate;
@synthesize dataSourceIsSelf = _dataSourceIsSelf;
@synthesize delegateIsSelf = _delegateIsSelf;
@synthesize snappedIndexPath = _snappedIndexPath;
@synthesize contentOffsetDelta = _contentOffsetDelta;

-(id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (! (self = [super initWithFrame:frame style:style]))
        return nil;
    
    self.snappedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    return self;
}

-(void) setHorizontal:(BOOL)horizontal {
    _horizontal = horizontal;
    
    if (horizontal)
    {
        CGRect frame = self.frame;
        self.transform = CGAffineTransformMakeRotation(-M_PI / 2.0f);
        self.frame = frame;
    }
    else
    {
        CGRect frame = self.frame;
        self.transform = CGAffineTransformIdentity;
        self.frame = frame;
    }
}

#pragma mark -
#pragma mark UITableView methods
#pragma mark -

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.realDataSource tableView:tableView numberOfRowsInSection:section];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.realDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell && self.horizontal)
        cell.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
    
    return cell;
}

#pragma mark -
#pragma mark UIScrollView methods
#pragma mark -

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    static CGPoint previousOffset;
    self.contentOffsetDelta = CGPointMake(self.contentOffset.x - previousOffset.x, self.contentOffset.y - previousOffset.y);
    previousOffset = self.contentOffset;
    
    // pass message to the delegate
    if ([self.realDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.realDelegate scrollViewDidScroll:scrollView];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self snapScrolling];
    
    // pass message to the delegate
    if ([self.realDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [self.realDelegate scrollViewDidEndDecelerating:scrollView];
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self snapScrolling];
    
    // pass message to the delegate
    if ([self.realDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [self.realDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

-(void) scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    self.snappedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    // pass message to the delegate
    if ([self.realDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [self.realDelegate scrollViewDidScrollToTop:scrollView];
}

#pragma mark -
#pragma mark UITableView overridden methods
#pragma mark -

-(void) scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    [super scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    self.snappedIndexPath = indexPath;
}

#pragma mark -
#pragma mark NSObject overridden methods
#pragma mark -

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector])
        return [super respondsToSelector:aSelector];
    
    struct objc_method_description dataSourceMethod = protocol_getMethodDescription(@protocol(UITableViewDataSource), aSelector, NO, YES);
    if (! _dataSourceIsSelf && dataSourceMethod.name != nil && [_realDataSource respondsToSelector:aSelector])
        return YES;
    
    struct objc_method_description delegateMethod = protocol_getMethodDescription(@protocol(UITableViewDelegate), aSelector, NO, YES);
    if (! _delegateIsSelf && delegateMethod.name != nil && [_realDelegate respondsToSelector:aSelector])
        return YES;
    
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([super methodSignatureForSelector:aSelector])
        return [super methodSignatureForSelector:aSelector];
    
    struct objc_method_description dataSourceMethod = protocol_getMethodDescription(@protocol(UITableViewDataSource), aSelector, NO, YES);
    if (dataSourceMethod.name != nil && [_realDataSource methodSignatureForSelector:aSelector])
        return [_realDataSource methodSignatureForSelector:aSelector];
    
    struct objc_method_description delegateMethod = protocol_getMethodDescription(@protocol(UITableViewDelegate), aSelector, NO, YES);
    if (delegateMethod.name != nil && [_realDelegate methodSignatureForSelector:aSelector])
        return [_realDelegate methodSignatureForSelector:aSelector];
    
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = [anInvocation selector];
    struct objc_method_description dataSourceMethod = protocol_getMethodDescription(@protocol(UITableViewDataSource), selector, NO, YES);
    struct objc_method_description delegateMethod = protocol_getMethodDescription(@protocol(UITableViewDelegate), selector, NO, YES);
    
    if (dataSourceMethod.name != nil && [self.realDataSource respondsToSelector:selector])
        [anInvocation invokeWithTarget:self.realDataSource];
    else if (delegateMethod.name != nil && [self.realDelegate respondsToSelector:selector])
        [anInvocation invokeWithTarget:self.realDelegate];
    else
        [super forwardInvocation:anInvocation];
}

#pragma mark -
#pragma mark Delegate / data source methods
#pragma mark -

-(id<OPTableViewDelegate>) delegate {
    return self.realDelegate;
}

-(void) setDelegate:(id<OPTableViewDelegate>)delegate {
    self.realDelegate = delegate;
    self.delegateIsSelf = (id)delegate == (id)self;
    [super setDelegate:self];
}

-(void) setDataSource:(id<UITableViewDataSource>)dataSource {
    self.realDataSource = dataSource;
    self.dataSourceIsSelf = dataSource == self;
    [super setDataSource:self];
}

#pragma mark -
#pragma mark Private methods
#pragma mark -

-(void) snapScrolling {
    
    if (self.snapToRows)
    {
        // A little trick here. This method is usually called from a UIScrollView delegate method, which is taking place
        // on the UI event tracking run loop mode. This means any UI animation stuff we try to do here may get skipped. But, 
        // if we dispatch async to the current queue we will pick up the NEXT run loop, which will be in default mode, and
        // so these animations will go through fine.
        dispatch_async(dispatch_get_current_queue(), ^{
            
            // allow for overflow elasticity in the scroll view
            if (self.contentOffset.y < 0.0f)
                return ;
            else if (self.contentOffset.y > self.contentSize.height - self.frame.size.height)
                return ;
            
            // figure out which index path we should snap to next
            UITableViewCell *firstCell = [[self visibleCells] objectAtIndex:0];
            UITableViewCell *secondCell = [[self visibleCells] lastObject];
            CGFloat top = firstCell.frame.origin.y - self.contentOffset.y;
            CGFloat bottom = top + firstCell.frame.size.height;
            
            if (self.contentOffsetDelta.y > 0 && ((top < -firstCell.frame.size.height/5.0f) || (self.contentOffsetDelta.y >= 10.0f)))
                self.snappedIndexPath = [[self indexPathsForVisibleRows] lastObject];
            else if (self.contentOffsetDelta.y < 0 && ((bottom > secondCell.frame.size.height/5.0f) || (self.contentOffsetDelta.y <= -10.0f)))
                self.snappedIndexPath = [[self indexPathsForVisibleRows] objectAtIndex:0];
            
            // allow the delegate to customize the snapped index path
            if ([self.realDelegate respondsToSelector:@selector(tableView:shouldSnapToIndexPath:)])
                self.snappedIndexPath = [self.realDelegate tableView:self shouldSnapToIndexPath:self.snappedIndexPath];
            
            // let our delegate know we are about to snap to the index path
            if ([self.realDelegate respondsToSelector:@selector(tableView:willSnapToIndexPath:)])
                [self.realDelegate tableView:self willSnapToIndexPath:self.snappedIndexPath];
            
            [self scrollToRowAtIndexPath:self.snappedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            // a little hackish, but by waiting 0.3 seconds we can assume the above scroll animation finished, 
            // and so then we call the didSnap delegate method
            if ([self.realDelegate respondsToSelector:@selector(tableView:didSnapToIndexPath:)]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                    [self.realDelegate tableView:self didSnapToIndexPath:self.snappedIndexPath];
                });
            }
            
        });
    }
}

@end
