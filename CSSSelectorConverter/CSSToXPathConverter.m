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
#import <ParseKit/ParseKit.h>
#import "CSSBaseSelector.h"

@implementation CSSToXPathConverter

-(id) initWithParser:(CSSSelectorParser*)parser {
    self = [super init];
    self.parser = parser;
    return self;
}

-(id) init {
    return [self initWithParser:[[CSSSelectorParser alloc] init]];
}

-(NSString*)xpathWithCSS:(NSString*)css error:(NSError**)error{
    PKAssembly* assembly = [self.parser parseString:css assembler:self error:error];
    
    NSMutableString* output = [[NSMutableString alloc] init];
    [assembly.stack enumerateObjectsUsingBlock:^(CSSBaseSelector* selector, NSUInteger idx, BOOL *stop) {
        if ([selector respondsToSelector:@selector(toXPath)]) {
            [output appendString:selector.toXPath];
        } else {
            DDLogError(@"not a xpath node! %@", selector);
        }
    }];
    return [output copy];
}

@end
