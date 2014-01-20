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

@implementation CSSSelectorSequence

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree {
    self = [self init];
    if (self) {
        if ([syntaxTree valueForTag:@"universal"]) {
            self.universalOrTypeSelector = [syntaxTree valueForTag:@"universal"];
            self.otherSelectors = [[syntaxTree valueForTag:@"selectorsWithType"] firstObject];
        } else if ([syntaxTree valueForTag:@"type"]) {
            self.universalOrTypeSelector = [syntaxTree valueForTag:@"type"];
            self.otherSelectors = [[syntaxTree valueForTag:@"selectorsWithType"] firstObject];
        } else {
            self.otherSelectors = [[syntaxTree valueForTag:@"selectorsWithoutType"] firstObject];
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
    } else {
        DDLogError(@"attempt to add unknown selector to sequence: %@", selector);
        [NSException raise:NSInternalInconsistencyException format:@"attempt to add unknown selector to sequence: %@", selector];
    }
}

//-(NSString*) toXPath {
//    NSMutableString* result = [[NSMutableString alloc] init];
//    if (self.combinator) {
//        [result appendString:self.combinator.toXPath];
//    } else {
//        [result appendString:@"//"];
//    }
//    
//    if (!self.universalOrTypeSelector) {
//        self.universalOrTypeSelector = [CSSUniversalSelector selector];
//    }
//
//    if (self.pseudoClass) {
//        self.pseudoClass.parent = self.universalOrTypeSelector;
//        [result appendString:self.pseudoClass.toXPath];
//    } else {
//        [result appendString:self.universalOrTypeSelector.toXPath];
//    }
//
//    
//    if ([self.otherSelectors count] > 0) {
//        [result appendString:@"["];
//        NSArray* reversedOtherSelectors = [[self.otherSelectors reverseObjectEnumerator] allObjects];
//        [reversedOtherSelectors enumerateObjectsUsingBlock:^(CSSBaseSelector* selector, NSUInteger idx, BOOL *stop) {
//            [result appendString:selector.toXPath];
//            if (idx < self.otherSelectors.count - 1) {
//                [result appendString:@" and "];
//            }
//        }];
//        [result appendString:@"]"];
//    }
//
//    return [result copy];
//}

@end
