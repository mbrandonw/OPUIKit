//
//  OPVectorView.m
//  OPUIKit
//
//  Created by Brandon Williams on 2/21/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPVectorView.h"
#import "UIView+Opetopic.h"

@interface OPVectorView (/**/)
@property (nonatomic, assign) CGPDFDocumentRef pdf;
@property (nonatomic, assign) CGPDFPageRef page;
@property (nonatomic, assign) CGRect pageRect;
@end

@implementation OPVectorView

@synthesize color = _color;
@synthesize pdf = _pdf;
@synthesize page = _page;
@synthesize pageRect = _pageRect;

-(id) initWithVectorNamed:(NSString*)name {
    return [self initWithVectorAtPath:[[NSBundle mainBundle] pathForResource:name ofType:@""]];
}

-(id) initWithVectorAtPath:(NSString *)path {
    if (! (self = [super init]))
        return nil;
    
    NSURL *url = [NSURL fileURLWithPath:path];
    self.pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)url);
    self.page = CGPDFDocumentGetPage(self.pdf, 1);
    self.pageRect = CGPDFPageGetBoxRect(self.page, kCGPDFCropBox);
    self.size = self.pageRect.size;
    
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    
    return self;
}

-(void) dealloc {
    if (_pdf)
        CGPDFDocumentRelease(_pdf);
    _pdf = NULL;
}

- (void)drawRect:(CGRect)rect {
    if (self.page)
    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        [self.backgroundColor set];
        CGContextFillRect(c, rect);
        
        CGContextSaveGState(c);
        {
            CGContextScaleCTM(c, 1.0f, -1.0f);
            CGContextTranslateCTM(c, 0.0f, -self.bounds.size.height);
             
            CGContextScaleCTM(c, rect.size.width / self.pageRect.size.width, rect.size.height / self.pageRect.size.height);
            CGContextTranslateCTM(c, -self.pageRect.origin.x, -self.pageRect.origin.y);
            
            CGContextSetInterpolationQuality(c, kCGInterpolationHigh);
            CGContextSetRenderingIntent(c, kCGRenderingIntentDefault);
            CGContextDrawPDFPage(c, self.page);
        }
        CGContextRestoreGState(c);
        
        if (self.color) {
            CGContextSetFillColorWithColor(c, self.color.CGColor);
            CGContextSetBlendMode(c, kCGBlendModeSourceIn);
            CGContextFillRect(c, rect);
        }
    }
}

-(CGSize) originalSize {
    return self.pageRect.size;
}

-(void) setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

@end
