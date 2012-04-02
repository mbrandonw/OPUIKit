//
//  OPDataDetectorLabel.m
//  OPUIKit
//
//  Created by Brandon Williams on 2/1/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPDataDetectorLabel.h"
#import "NSString+Opetopic.h"
#import "UIView+Opetopic.h"

#pragma mark -
#pragma mark OPDataDetector
#pragma mark -

OPDataDetector *OPDataDetectorPhoneNumber;
OPDataDetector *OPDataDetectorEmailAddress;
OPDataDetector *OPDataDetectorLink;

@interface OPDataDetector (/**/)
@property (nonatomic, strong, readwrite) NSRegularExpression *regex;
@property (nonatomic, strong, readwrite) NSRegularExpression *userInfo;
@end

@implementation OPDataDetector

@synthesize regex = _regex;
@synthesize userInfo = _userInfo;

+(void) load {
    
//    OPDataDetectorEmailAddress = [[OPDataDetector alloc] initWithRegex:
//                                  [[NSRegularExpression alloc] initWithPattern:@"[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}"
//                                                                       options:NSRegularExpressionCaseInsensitive 
//                                                                         error:NULL] userInfo:nil];
//    
//    OPDataDetectorPhoneNumber = [[OPDataDetector alloc] initWithRegex:
//                                 [[NSRegularExpression alloc] initWithPattern:@"(\\+)?([0-9]{8,}+)"
//                                                                      options:NSRegularExpressionCaseInsensitive 
//                                                                        error:NULL] userInfo:nil];
//    
//    OPDataDetectorLink = [[OPDataDetector alloc] initWithRegex:
//                          [[NSRegularExpression alloc] initWithPattern:@"([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])"
//                                                               options:NSRegularExpressionCaseInsensitive
//                                                                 error:NULL] userInfo:nil];
}

-(id) initWithRegex:(NSRegularExpression*)regex userInfo:(id)userInfo {
    if (! (self = [self init]))
        return nil;
    
    self.regex = regex;
    self.userInfo = userInfo;
    
    return self;
}

@end


#pragma mark -
#pragma mark OPDataDetectorLabel
#pragma mark -

@interface OPDataDetectorLabel (/**/)
@property (nonatomic, strong, readwrite) UILabel *label;
-(void) removeButtons;
-(void) addButtons;
-(void) addButtonWithText:(NSString*)text withFrame:(CGRect)frame forDataDetectorIndex:(NSUInteger)index;
-(void) addButtonsWithText:(NSString*)text atPoint:(CGPoint)point;
@end

@implementation OPDataDetectorLabel

@synthesize label = _label;
@synthesize dataDetectors = _dataDetectors;
@synthesize eventHandler = _eventHandler;
@synthesize buttonGenerator = _buttonGenerator;
@synthesize dataDetectorsEnabled = _dataDetectorsEnabled;

-(id) initWithFrame:(CGRect)frame {
    if (! (self = [super initWithFrame:frame]))
        return nil;
    
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.label];
    
    self.dataDetectorsEnabled = YES;
    
    return self;
}

#pragma mark -
#pragma mark Overridden methods
#pragma mark -

-(void) layoutSubviews {
    [super layoutSubviews];
    
    [self removeButtons];
    if (self.dataDetectorsEnabled)
        [self addButtons];
}

-(void) setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.label.backgroundColor = backgroundColor;
}

-(void) setDataDetectorsEnabled:(BOOL)dataDetectorsEnabled {
    if (_dataDetectorsEnabled != dataDetectorsEnabled)
    {
        _dataDetectorsEnabled = dataDetectorsEnabled;
        if (_dataDetectorsEnabled)
            [self setNeedsLayout];
        else
            [self removeButtons];
    }
}

-(void) sizeToFit {
    [self.label sizeToFit];
    self.size = self.label.size;
}

#pragma mark -
#pragma mark Interface actions
#pragma mark -

-(void) buttonPressed:(UIButton*)sender {
    
    if (self.eventHandler)
        self.eventHandler(self, sender.titleLabel.text, [self.dataDetectors objectAtIndex:sender.tag]);
}

#pragma mark -
#pragma mark Private methods
#pragma mark -

-(void) removeButtons {
    for (UIView *view in self.subviews)
        if ([view isKindOfClass:[UIButton class]])
            [view removeFromSuperview];
}

#define MIN_WHITESPACE_LOCATION 5
-(void) addButtons {
    
	CGRect frame = self.frame;
	UIFont *font = self.label.font;
	NSString *text = self.label.text;
	NSUInteger textLength = [text length];
    
    
    if (! [text isPresent])
        return ;
    if (frame.size.width == 0.0f || frame.size.height == 0.0f)
        return ;
    
    
	// by default, the output starts at the top of the frame
	CGPoint outputPoint = CGPointZero;
	CGSize textSize = [text sizeWithFont:font constrainedToSize:frame.size];
	CGRect bounds = [self bounds];
	if (textSize.height < bounds.size.height)
	{
		// the lines of text are centered in the bounds, so adjust the output point
		CGFloat boundsMidY = CGRectGetMidY(bounds);
		CGFloat textMidY = textSize.height / 2.0;
		outputPoint.y = ceilf(boundsMidY - textMidY);
	}
    
    
	// initialize whitespace tracking
	BOOL scanningWhitespace = NO;
	NSRange whitespaceRange = NSMakeRange(NSNotFound, 0);
	
	// scan the text
	NSRange scanRange = NSMakeRange(0, 1);
	while (NSMaxRange(scanRange) < textLength)
	{
		NSRange tokenRange = NSMakeRange(NSMaxRange(scanRange) - 1, 1);
		NSString *token = [text substringWithRange:tokenRange];
        
		if ([token isEqualToString:@" "] || [token isEqualToString:@"?"] || [token isEqualToString:@"-"])
		{
			// handle whitespace
			if (! scanningWhitespace)
			{
				// start of whitespace
				whitespaceRange.location = tokenRange.location;
				whitespaceRange.length = 1;
			}
			else
			{
				// continuing whitespace
				whitespaceRange.length += 1;
			}
            
			scanningWhitespace = YES;
			
			// scan the next position
			scanRange.length += 1;
		}
        else
		{
			// end of whitespace
			scanningWhitespace = NO;
            
			NSString *scanText = [text substringWithRange:scanRange];
			CGSize currentSize = [scanText sizeWithFont:font];
			
			BOOL breakLine = NO;
			if ([token isEqualToString:@"\r"] || [token isEqualToString:@"\n"])
			{
				// carriage return or newline caused line to break
				breakLine = YES;
			}
			BOOL breakWidth = NO;
			if (currentSize.width > frame.size.width)
			{
				// the width of the text in the frame caused the line to break
				breakWidth = YES;
			}
			
			if (breakLine || breakWidth)
			{
				// the line broke, compute the range of text we want to output
				NSRange outputRange;
				
				if (breakLine)
				{
					// output before the token that broke the line
					outputRange.location = scanRange.location;
					outputRange.length = tokenRange.location - scanRange.location;
				}
				else
				{
					if (whitespaceRange.location != NSNotFound && whitespaceRange.location > MIN_WHITESPACE_LOCATION)
					{
						// output before beginning of the last whitespace
						outputRange.location = scanRange.location;
						outputRange.length = whitespaceRange.location - scanRange.location;
					}
					else
					{
						// output before the token that cause width overflow
						outputRange.location = scanRange.location;
						outputRange.length = tokenRange.location - scanRange.location;
					}
				}
				
				// make the buttons in this line of text
				[self addButtonsWithText:[text substringWithRange:outputRange] atPoint:outputPoint];
                
				if (breakLine)
				{
					// start scanning after token that broke the line
					scanRange.location = NSMaxRange(tokenRange);
					scanRange.length = 1;
				}
				else
				{
					if (whitespaceRange.location != NSNotFound && whitespaceRange.location > MIN_WHITESPACE_LOCATION)
					{
						// start scanning at end of last whitespace
						scanRange.location = NSMaxRange(whitespaceRange);
						scanRange.length = 1;
					}
					else
					{
						// start scanning at token that cause width overflow
						scanRange.location = NSMaxRange(tokenRange) - 1;
						scanRange.length = 1;
					}
				}
                
				// reset whitespace
				whitespaceRange.location = NSNotFound;
				whitespaceRange.length = 0;
				
				// move output to next line
				outputPoint.y += currentSize.height;
			}
			else
			{
				// the line did not break, scan the next position
				scanRange.length += 1;
			}
		}
	}
	
	// output to end
	[self addButtonsWithText:[text substringFromIndex:scanRange.location] atPoint:outputPoint];
}

-(void) addButtonWithText:(NSString*)text withFrame:(CGRect)frame forDataDetectorIndex:(NSUInteger)index {
    
    if (! [text isPresent])
        return ;
    
    UIButton *button = nil;
    if (self.buttonGenerator)
        button = self.buttonGenerator(self, nil);
    else
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button.frame = frame;
    button.tag = index;
    button.titleLabel.font = self.label.font;
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

-(void) addButtonsWithText:(NSString *)text atPoint:(CGPoint)point {
    
	UIFont *font = self.label.font;
    
	[self.dataDetectors enumerateObjectsUsingBlock:^(OPDataDetector *dataDetector, NSUInteger idx, BOOL *stop) {
        
        [dataDetector.regex enumerateMatchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, [text length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            NSString *match = [text substringWithRange:result.range];
            CGSize matchSize = [match sizeWithFont:font];
            NSRange measureRange = NSMakeRange(0, result.range.location);
            NSString *measureText = [text substringWithRange:measureRange];
            CGSize measureSize = [measureText sizeWithFont:font];
            
            CGRect matchFrame = CGRectMake(measureSize.width-3.0f, point.y, matchSize.width+6.0f, matchSize.height);
            [self addButtonWithText:match withFrame:matchFrame forDataDetectorIndex:idx];
        }];
        
	}];
}

@end
