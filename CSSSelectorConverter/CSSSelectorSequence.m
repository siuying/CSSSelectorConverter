//
//  CSSSelectorSequence.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "DDLog.h"

#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF cssSelectorLogLevel
static const int cssSelectorLogLevel = LOG_LEVEL_VERBOSE;

#import "CSSSelectorSequence.h"

#import "CSSUniversalSelector.h"
#import "CSSNamedSelector.h"
#import "CSSTypeSelector.h"
#import "CSSIDSelector.h"
#import "CSSClassSelector.h"

@implementation CSSSelectorSequence

-(instancetype) init {
    self = [super init];
    self.universalOrTypeSelector = nil;
    self.otherSelectors = [[NSMutableArray alloc] init];
    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<CSSSelectorSequence %@ %@>", self.universalOrTypeSelector, self.otherSelectors];
}

-(void) addSelector:(CSSBaseSelector*)selector {
    if ([selector isKindOfClass:[CSSUniversalSelector class]] || [selector isKindOfClass:[CSSTypeSelector class]]) {
        if (self.universalOrTypeSelector != nil) {
            DDLogError(@"selector sequence only begin with one universal selector or type selector, already added: %@, attempt to add: %@", self.universalOrTypeSelector, selector);
            [NSException raise:NSInternalInconsistencyException format:@"selector sequence only begin with one universal selector or type selector, already added: %@, attempt to add: %@", self.universalOrTypeSelector, selector];
        } else {
            self.universalOrTypeSelector = selector;
        }
    } else if ([selector isKindOfClass:[CSSIDSelector class]] || [selector isKindOfClass:[CSSClassSelector class]]) {
        [self.otherSelectors addObject:selector];
    } else {
        DDLogError(@"attempt to add unknown selector to sequence: %@", selector);
        [NSException raise:NSInternalInconsistencyException format:@"attempt to add unknown selector to sequence: %@", selector];
    }
}

-(NSString*) toXPath {
    NSMutableString* result = [[NSMutableString alloc] init];
    if (self.universalOrTypeSelector) {
        [result appendString:self.universalOrTypeSelector.toXPath];
    } else {
        [result appendString:@"*"];
    }
    
    if ([self.otherSelectors count] > 0) {
        [result appendString:@"["];
        NSArray* reversedOtherSelectors = [[self.otherSelectors reverseObjectEnumerator] allObjects];
        [reversedOtherSelectors enumerateObjectsUsingBlock:^(CSSBaseSelector* selector, NSUInteger idx, BOOL *stop) {
            [result appendString:selector.toXPath];
            if (idx < self.otherSelectors.count - 1) {
                [result appendString:@" and "];
            }
        }];
        [result appendString:@"]"];
    }

    return [result copy];
}

+(instancetype) selectorWithAssembly:(PKAssembly*)assembly {
    DDLogVerbose(@"create a sequence ...");
    CSSSelectorSequence* seq = [[self alloc] init];
    CSSBaseSelector* selector = nil;

    while ((selector = [assembly pop])) {
        if ([selector isKindOfClass:[CSSUniversalSelector class]] || [selector isKindOfClass:[CSSTypeSelector class]] ||
            [selector isKindOfClass:[CSSIDSelector class]] || [selector isKindOfClass:[CSSClassSelector class]]) {
            DDLogVerbose(@"  add %@ (%@) to sequence", [selector class], selector);
            [seq addSelector:selector];
        } else {
            DDLogVerbose(@"  not a supported selector, push it back and abort sequence %@(%@)", [selector class], selector);
            [assembly push:selector];
            [assembly push:seq];
            return seq;
        }
    }
    [assembly push:seq];
    return seq;
}

@end
