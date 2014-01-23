//
//  CSSToXPathConverter.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//
#import "DDLog.h"
#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF cssSelectorLogLevel
static const int cssSelectorLogLevel = LOG_LEVEL_VERBOSE;

#import "CSSSelectorToXPathConverter.h"
#import "CSSBaseSelector.h"
#import "CSSSelectorXPathVisitor.h"

@implementation CSSSelectorToXPathConverter

-(id) initWithParser:(CSSSelectorParser*)parser {
    self = [super init];
    self.parser = parser;
    return self;
}

-(id) init {
    return [self initWithParser:[[CSSSelectorParser alloc] init]];
}

-(NSString*)xpathWithCSS:(NSString*)css error:(NSError*__autoreleasing*)error{
    CSSSelectorGroup* group = [self.parser parse:css error:error];
    if (group) {
        CSSSelectorXPathVisitor* visitor = [[CSSSelectorXPathVisitor alloc] init];
        [visitor visit:group];
        return [visitor xpathString];
    } else {
        return nil;
    }
}

@end
