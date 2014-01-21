//
//  CSSSelectorGroup.m
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSSelectorGroup.h"
#import "DDLog.h"
#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF cssSelectorLogLevel
static const int cssSelectorLogLevel = LOG_LEVEL_VERBOSE;

@implementation CSSSelectorGroup

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree {
    self = [self init];
    if (self) {
        CSSSelectors* selector = [syntaxTree valueForTag:@"firstSelector"];
        if (selector) {
            [self addSelectors:selector];
        } else {
            [NSException raise:NSInvalidArgumentException format:@"should at least contain one selector"];
        }
        
        NSArray* selectors = [syntaxTree valueForTag:@"otherSelectors"];
        [selectors enumerateObjectsUsingBlock:^(CSSSelectors* other, NSUInteger idx, BOOL *stop) {
            [self addSelectors:other];
        }];
    }
    return self;
}

-(instancetype) init {
    self = [super init];
    self.selectors = [[NSMutableArray alloc] init];
    return self;
}

-(void) addSelectors:(CSSSelectors *)theSelectors {
    [self.selectors addObject:theSelectors];
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<CSSSelectorGroup %@>", self.selectors];
}

-(NSString*) toXPath {
    NSMutableString* result = [[NSMutableString alloc] init];
    
    NSArray* reverseSequence = [[self.selectors reverseObjectEnumerator] allObjects];
    [reverseSequence enumerateObjectsUsingBlock:^(CSSBaseSelector* selector, NSUInteger idx, BOOL *stop) {
        [result appendString:selector.toXPath];
        if (idx < reverseSequence.count-1) {
            [result appendString:@" | "];
        }
    }];

    return [result copy];
}

@end
