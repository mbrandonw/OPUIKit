//
//  OPTextView.m
//  OPUIKit
//
//  Created by Brandon Williams on 10/10/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import "OPTextView.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface OPTextView (/**/) <EKEventEditViewDelegate>
@property (nonatomic, strong, readwrite) UILabel *placeholderLabel;
-(void) updatePlaceholderLabel;
@end

@implementation OPTextView

-(id) init {
  if (! (self = [super init])) {
    return nil;
  }

  self.delegate = self;

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
  if (! _placeholderLabel) {
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
  // update placeholder only if we are actually using it.
  if (_placeholderLabel) {
    [self.placeholderLabel sizeToFit];
    [self addSubview:self.placeholderLabel];
    [self bringSubviewToFront:self.placeholderLabel];
    self.placeholderLabel.left = self.placeholderLabel.top = 8.0f;

    // hide place holder label when there is text in the view
    self.placeholderLabel.hidden = ([self.text length] > 0);
  }
}

-(void) layoutSubviews {
  [super layoutSubviews];
  [self updatePlaceholderLabel];
}


-(void) setAttributedTextWithPlainText:(NSString*)plainText
                         dataDetectors:(UIDataDetectorTypes)dataDetectorTypes
                     defaultAttributes:(NSDictionary*)defaultAttributes {
  [self setAttributedTextWithPlainText:plainText
                         dataDetectors:dataDetectorTypes
                     defaultAttributes:defaultAttributes
                        linkAttributes:[UIDevice isiOS7OrLater] ? self.linkTextAttributes : @{}];
}

-(void) setAttributedTextWithPlainText:(NSString*)plainText
                         dataDetectors:(UIDataDetectorTypes)dataDetectorTypes
                     defaultAttributes:(NSDictionary*)defaultAttributes
                        linkAttributes:(NSDictionary*)linkAttributes {

  linkAttributes = linkAttributes ?: @{};

  NSTextCheckingTypes textCheckingTypes = 0;
  if (dataDetectorTypes | UIDataDetectorTypeAddress) {
    textCheckingTypes |= NSTextCheckingTypeAddress;
  }
  if (dataDetectorTypes | UIDataDetectorTypeCalendarEvent) {
    textCheckingTypes |= NSTextCheckingTypeDate;
  }
  if (dataDetectorTypes | UIDataDetectorTypeLink) {
    textCheckingTypes |= NSTextCheckingTypeLink;
  }
  if (dataDetectorTypes | UIDataDetectorTypePhoneNumber) {
    textCheckingTypes |= NSTextCheckingTypePhoneNumber;
  }

  NSString *key = [NSString stringWithFormat:@"UITextView_Opetopic_DataDetector_%llu", textCheckingTypes];
  NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
  NSDataDetector *detector = threadDictionary[key] = threadDictionary[key] ?: [NSDataDetector dataDetectorWithTypes:textCheckingTypes error:NULL];

  NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:plainText attributes:defaultAttributes];
  [text beginEditing];

  [[detector matchesInString:plainText options:0] enumerateObjectsUsingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL *stop) {
    id dataValue = nil;

    if (match.resultType == NSTextCheckingTypeLink && match.URL) {
      dataValue = match.URL;
    } else if (match.resultType == NSTextCheckingTypePhoneNumber && match.phoneNumber) {
      dataValue = $url($strfmt(@"tel://%@", match.phoneNumber));
    } else if (match.resultType == NSTextCheckingTypeAddress && match.addressComponents) {
      // compile all the address components into one big string
      NSString *address = [[NSString stringWithFormat:@"%@, %@, %@ %@, %@, %@",
                            match.addressComponents[NSTextCheckingNameKey] ?: @"",
                            match.addressComponents[NSTextCheckingStreetKey] ?: @"",
                            match.addressComponents[NSTextCheckingCityKey] ?: @"",
                            match.addressComponents[NSTextCheckingStateKey] ?: @"",
                            match.addressComponents[NSTextCheckingZIPKey] ?: @"",
                            match.addressComponents[NSTextCheckingCountryKey] ?: @""]
                           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

      // prefer the native google maps app if it is installed.
      if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        dataValue = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?q=%@", address]];
      } else {
        // fall back to apple maps :-(
        dataValue = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?q=%@", address]];
      }
    } else if (match.resultType == NSTextCheckingTypeDate && match.date) {
      dataValue = [NSURL URLWithString:[NSString stringWithFormat:@"op_cal://?date=%f&duration=%f&time_zone_name=%@", [match.date timeIntervalSince1970], match.duration, match.timeZone.name]];
    }

    if (dataValue && NSIntersectionRange(match.range, [text.string fullRange]).length > 0) {
      [text addAttribute:NSLinkAttributeName value:dataValue range:match.range];
      [text addAttributes:linkAttributes range:match.range];
    }
  }];

  [text endEditing];
  self.attributedText = text;
}

#pragma mark -
#pragma mark UITextViewDelegate methods
#pragma mark -

-(BOOL) textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {

  if ([URL.absoluteString hasPrefix:@"op_cal://"] && NSClassFromString(@"EKEvent")) {

    NSDictionary *params = [URL queryParameters];

    EKEventStore *eventStore = [EKEventStore new];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    event.startDate = [NSDate dateWithTimeIntervalSince1970:[params[@"date"] doubleValue]];
    event.endDate = [event.startDate dateByAddingTimeInterval:[params[@"duration"] doubleValue]];
    event.timeZone = event.timeZone ?: [NSTimeZone timeZoneWithName:params[@"time_zone_name"]];

    EKEventEditViewController *controller = [[EKEventEditViewController alloc] init];
    controller.event = event;
    controller.eventStore = eventStore;
    controller.editViewDelegate = self;
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
      // NB: delaying this presentation for one run loop helps the animation
      // to always play. Before it was sometimes just skipping animation and
      // going straight to the screen.
      dispatch_next_runloop(^{
        UIViewController *root = self.window.rootViewController.presentedViewController ?: self.window.rootViewController;
        [root presentViewController:controller animated:YES completion:nil];
      });
    }];

    return NO;
  }

  return [[UIApplication sharedApplication] openURL:URL];
}

#pragma mark -
#pragma mark EKEventEditViewDelegate methods
#pragma mark -

-(void) eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {

  // NB: This dispatch is here for the same reason as above.
  dispatch_next_runloop(^{
    [controller dismissViewControllerAnimated:YES completion:nil];
  });
}

@end
