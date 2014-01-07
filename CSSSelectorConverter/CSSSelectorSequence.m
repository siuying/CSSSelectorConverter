//
//  CSSSelectorSequence.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

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
            [NSException raise:NSInternalInconsistencyException format:@"selector sequence only begin with one universal selector or type selector, already added: %@, attempt to add: %@", self.universalOrTypeSelector, selector];
        } else {
            self.universalOrTypeSelector = selector;
        }
    } else if ([selector isKindOfClass:[CSSIDSelector class]] || [selector isKindOfClass:[CSSClassSelector class]]) {
        [self.otherSelectors addObject:selector];
    } else {
        [NSException raise:NSInternalInconsistencyException format:@"attempt to add unknown selector to sequence: %@", selector];
    }
}

-(NSString*) toXPath {
    NSMutableString* result = [[NSMutableString alloc] init];
    if (self.universalOrTypeSelector) {
        [result appendString:self.universalOrTypeSelector.toXPath];
    } else {
        [result appendString:@"//*"];
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
    CSSSelectorSequence* seq = [[self alloc] init];
    CSSBaseSelector* selector = nil;

    while ((selector = [assembly pop])) {
        if ([selector isKindOfClass:[CSSUniversalSelector class]] || [selector isKindOfClass:[CSSTypeSelector class]] ||
            [selector isKindOfClass:[CSSIDSelector class]] || [selector isKindOfClass:[CSSClassSelector class]]) {
            [seq addSelector:selector];
        } else {
            [assembly push:selector];
            [assembly push:seq];
            return seq;
        }
    }
    [assembly push:seq];
    return seq;
}

@end
