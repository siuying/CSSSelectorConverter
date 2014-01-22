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

#import "CSSToXPathConverter.h"
#import "CSSBaseSelector.h"
#import "CSSSelectorXPathVisitor.h"

@implementation CSSToXPathConverter

-(id) initWithParser:(CSSSelectorParser*)parser {
    self = [super init];
    self.parser = parser;
    return self;
}

-(id) init {
    return [self initWithParser:[[CSSSelectorParser alloc] init]];
}

-(NSString*)xpathWithCSS:(NSString*)css {
    CSSSelectorGroup* group = [self.parser parse:css];
    CSSSelectorXPathVisitor* visitor = [[CSSSelectorXPathVisitor alloc] init];
    [visitor visit:group];
    return [visitor xpathString];
}

@end
