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
#import "CSSSelectorAttribute.h"
#import "CSSPseudoClass.h"
#import "CSSCombinator.h"

@implementation CSSSelectorSequence

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree {
    self = [self init];
    if (self) {
        if ([syntaxTree valueForTag:@"universal"]) {
            self.universalOrTypeSelector = [syntaxTree valueForTag:@"universal"];
            NSArray* subtree = [syntaxTree valueForTag:@"selectorsWithType"];
            NSArray* selectors = [subtree valueForKeyPath:@"@unionOfArrays.self"];
            [selectors enumerateObjectsUsingBlock:^(CSSBaseSelector* selector, NSUInteger idx, BOOL *stop) {
                [self addSelector:selector];
            }];
        } else if ([syntaxTree valueForTag:@"type"]) {
            self.universalOrTypeSelector = [syntaxTree valueForTag:@"type"];
            NSArray* subtree = [syntaxTree valueForTag:@"selectorsWithType"];
            NSArray* selectors = [subtree valueForKeyPath:@"@unionOfArrays.self"];
            [selectors enumerateObjectsUsingBlock:^(CSSBaseSelector* selector, NSUInteger idx, BOOL *stop) {
                [self addSelector:selector];
            }];
        } else {
            NSArray* subtree = [syntaxTree valueForTag:@"selectorsWithoutType"];
            NSArray* selectors = [subtree valueForKeyPath:@"@unionOfArrays.self"];
            [selectors enumerateObjectsUsingBlock:^(CSSBaseSelector* selector, NSUInteger idx, BOOL *stop) {
                [self addSelector:selector];
            }];
        }
    }
    return self;
}

-(instancetype) init {
    self = [super init];
    self.universalOrTypeSelector = nil;
    self.otherSelectors = [[NSMutableArray alloc] init];
    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<CSSSelectorSequence %@ %@>", self.universalOrTypeSelector, [self.otherSelectors componentsJoinedByString:@" "]];
}

-(void) addSelector:(CSSBaseSelector*)selector {
    if ([selector isKindOfClass:[CSSIDSelector class]] ||
        [selector isKindOfClass:[CSSClassSelector class]] ||
        [selector isKindOfClass:[CSSSelectorAttribute class]]) {
        [self.otherSelectors addObject:selector];

    } else if ([selector isKindOfClass:[CSSPseudoClass class]]) {
        self.pseudoClass = (CSSPseudoClass*) selector;

    } else {
        DDLogError(@"attempt to add unknown selector to sequence: %@", selector);
        [NSException raise:NSInternalInconsistencyException format:@"attempt to add unknown selector to sequence: %@", selector];
    }
}

-(NSString*) toXPath {
    NSMutableString* result = [[NSMutableString alloc] init];
    
    if (!self.universalOrTypeSelector) {
        self.universalOrTypeSelector = [CSSUniversalSelector selector];
    }

    if (self.pseudoClass) {
        self.pseudoClass.parent = self.universalOrTypeSelector;
        [result appendString:self.pseudoClass.toXPath];
    } else {
        [result appendString:self.universalOrTypeSelector.toXPath];
    }

    
    if ([self.otherSelectors count] > 0) {
        [result appendString:@"["];
        [self.otherSelectors enumerateObjectsUsingBlock:^(CSSBaseSelector* selector, NSUInteger idx, BOOL *stop) {
            [result appendString:selector.toXPath];
            if (idx < self.otherSelectors.count - 1) {
                [result appendString:@" and "];
            }
        }];
        [result appendString:@"]"];
    }

    return [result copy];
}

@end
