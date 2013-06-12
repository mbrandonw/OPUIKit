//
//  OPTextView.m
//  OPUIKit
//
//  Created by Brandon Williams on 10/10/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import "OPTextView.h"

@interface OPTextView (/**/)
@property (nonatomic, strong, readwrite) UILabel *placeholderLabel;
-(void) updatePlaceholderLabel;
@end

@implementation OPTextView

@synthesize placeholderLabel = _placeholderLabel;

-(id) init {
    if (! (self = [super init]))
        return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    return self;
}

-(id) initWithFrame:(CGRect)frame {
    if (! (self = [super initWithFrame:frame]))
        return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    return self;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

-(UILabel*) placeholderLabel {
    if (! _placeholderLabel)
    {
        self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0f,8.0f,self.bounds.size.width - 16.0f,0)];
        _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.font = self.font;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = [UIColor grayColor];
    }
    return _placeholderLabel;
}

-(void) setText:(NSString *)text {
    [super setText:text];
    [self updatePlaceholderLabel];
}

-(void) textDidChange:(NSNotification*)notification {
    [self updatePlaceholderLabel];
}

-(void) updatePlaceholderLabel {
    
    [self.placeholderLabel sizeToFit];
    [self addSubview:self.placeholderLabel];
    [self bringSubviewToFront:self.placeholderLabel];
    
    // hide place holder label when there is text in the view
    self.placeholderLabel.hidden = ([self.text length] > 0);
}

-(void) drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    [self updatePlaceholderLabel];
}

@end
