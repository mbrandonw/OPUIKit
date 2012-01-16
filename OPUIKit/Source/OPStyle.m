//
//  OPStyle.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/16/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPStyle.h"
#import "NSObject+Opetopic.h"
#import "RTProtocol.h"
#import "RTMethod.h"
#import "MARTNSObject.h"


@interface OPStyleProxy : NSProxy
@property (nonatomic, strong) OPStyle *style;
@end

@implementation OPStyleProxy

-(void) forwardInvocation:(NSInvocation *)invocation {
    
    invocation.
}

@end


@interface OPStyle (/**/)
@property (nonatomic, strong) NSMutableArray *touchedMethods;
@property (nonatomic, assign) Class styledClass;
-(id) initForClass:(Class)styledClass;
@end

@implementation OPStyle

@synthesize styledClass = _styledClass;
@synthesize touchedMethods = _touchedMethods;

@synthesize backgroundImage = _backgroundImage;
@synthesize backgroundColor = _backgroundColor;
@synthesize glossAmount = _glossAmount;
@synthesize glossOffset = _glossOffset;
@synthesize gradientAmount = _gradientAmount;
@synthesize shadowHeight = _shadowHeight;
@synthesize shadowColors = _shadowColors;
@synthesize titleFont = _titleFont;
@synthesize subtitleFont = _subtitleFont;
@synthesize titleTextColor = _titleTextColor;
@synthesize titleShadowColor = _titleShadowColor;
@synthesize titleShadowOffset = _titleShadowOffset;
@synthesize defaultTitle = _defaultTitle;
@synthesize defaultTitleImage = _defaultTitleImage;

+(void) initialize {
    if (self == [OPStyle class])
    {
        
    }
}

-(id) initForClass:(Class)styledClass {
    if (! (self = [super init]))
        return nil;
    
    _styledClass = styledClass;
    
    return self;
}

-(void) applyTo:(id)target {
    
    // first apply any stylings from the superclass so that styles inherit
    if ([self.styledClass superclass])
        [[[self.styledClass superclass] op_style] applyTo:target];
    
    // loop through the methods in our protocol so we can apply the properties to the object passed in
    RTProtocol *protocol = [RTProtocol protocolWithObjCProtocol:@protocol(OPStyleProtocol)];
    for (RTMethod *method in [protocol methodsRequired:NO instance:YES])
    {
        // only look at setter methods
        if ([method.selectorName hasPrefix:@"set"] && [target respondsToSelector:method.selector])
        {
            // find the corresponding getter method
            NSString *selector = [method.selectorName substringFromIndex:3];
            selector = [selector stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[selector substringToIndex:1] lowercaseString]];
            selector = [selector substringToIndex:[selector length]-1];
            SEL getterSelector = NSSelectorFromString(selector);
            
            // get the value stored in this class so that we can send it to the target
            void *value = NULL;
            [self rt_returnValue:&value sendSelector:getterSelector];
            
            // send the setter method to 
            [target rt_returnValue:NULL sendSelector:method.selector, RTARG(value)];
        }
    }
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<%@: %p> for %@", NSStringFromClass([self class]), self, NSStringFromClass(self.styledClass)];
}

@end


/**
 Internal mapping of classes to OPStyle instances.
 */
static NSMutableDictionary *OPStylesByClass;

@implementation NSObject (OPStyle)

+(OPStyle*) op_style {
    
    // lazily create the dictionary that maps classes to style objects
    if (! OPStylesByClass)
        OPStylesByClass = [NSMutableDictionary new];
    
    // lazily create the style object for this class
    NSString *classString = NSStringFromClass([self class]);
    if (! [OPStylesByClass objectForKey:classString])
    {
        OPStyle *style = [[OPStyle alloc] initForClass:[self class]];
        [OPStylesByClass setObject:style forKey:classString];
    }
    
    return [OPStylesByClass objectForKey:classString];
}

-(OPStyle*) op_style {
    return [[self class] op_style];
}

@end
