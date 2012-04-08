//
//  OPPDFView.m
//  OPUIKit
//
//  Created by Brandon Williams on 2/10/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPPDFView.h"
#import "UIView+Opetopic.h"

@interface OPPDFView (/**/)
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) CGPDFDocumentRef pdf;
@property (nonatomic, assign) CGPDFPageRef page;
@property (nonatomic, assign) CGRect pageRect;
@end

@implementation OPPDFView

@synthesize url = _url;
@synthesize pdf = _pdf;
@synthesize page = _page;
@synthesize pageRect = _pageRect;

-(void) dealloc {
    CGPDFDocumentRelease(self.pdf);
}

-(void) loadPDFAtPath:(NSString*)path {
    
    self.url = [NSURL fileURLWithPath:path];
    
    self.pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)self.url);
    self.page = CGPDFDocumentGetPage(self.pdf, 1);
    self.pageRect = CGPDFPageGetBoxRect(self.page, kCGPDFCropBox);
    self.size = self.pageRect.size;
    _pageRect.origin.x = roundf(self.pageRect.origin.x);
    _pageRect.origin.y = roundf(self.pageRect.origin.y);
    _pageRect.size.width = roundf(self.pageRect.size.width);
    _pageRect.size.height = roundf(self.pageRect.size.height);
    
    [self setNeedsDisplay];
}

-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.page)
    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        [self.backgroundColor set];
        CGContextFillRect(c, rect);
        
        CGContextScaleCTM(c, 1.0f, -1.0f);
        CGContextTranslateCTM(c, 0.0f, -self.bounds.size.height);
        
        CGContextScaleCTM(c, rect.size.width / self.pageRect.size.width, rect.size.height / self.pageRect.size.height);
        CGContextTranslateCTM(c, -self.pageRect.origin.x, -self.pageRect.origin.y);
        
        CGContextDrawPDFPage(c, self.page);
    }
}

@end
