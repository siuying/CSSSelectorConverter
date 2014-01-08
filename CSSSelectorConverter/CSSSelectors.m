//
//  CSSSelectors.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "DDLog.h"
#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF cssSelectorLogLevel
static const int cssSelectorLogLevel = LOG_LEVEL_VERBOSE;

#import "CSSSelectors.h"
#import "CSSCombinator.h"
#import "CSSSelectorSequence.h"

@implementation CSSSelectors

-(instancetype) init {
    self = [super init];
    self.selectors = [[NSMutableArray alloc] init];
    return self;
}

-(void) addSelector:(CSSBaseSelector*)selector {
    if (![selector isKindOfClass:[CSSSelectorSequence class]] && ![selector isKindOfClass:[CSSCombinator class]]) {
        [NSException raise:NSInvalidArgumentException format:@"Only allowed to add selector of type CSSSelectorSequence or CSSCombinator, given: %@", [selector class]];
    }

    [self.selectors addObject:selector];
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<CSSSelectors %@>", self.selectors];
}

-(NSString*) toXPath {
    NSMutableString* result = [[NSMutableString alloc] init];
    
    NSArray* reverseSequence = [[self.selectors reverseObjectEnumerator] allObjects];
    [reverseSequence enumerateObjectsUsingBlock:^(CSSBaseSelector* selector, NSUInteger idx, BOOL *stop) {
        [result appendString:selector.toXPath];
    }];

    return [result copy];
}

+(void) pushSelectors:(PKAssembly*)assembly {
    DDLogVerbose(@"create CSSSelectors ...");
    CSSSelectors* selectors = [[self alloc] init];

    id token;
    while ((token = [assembly pop])) {
        if ([token isKindOfClass:[CSSSelectorSequence class]] || [token isKindOfClass:[CSSCombinator class]]) {
            DDLogVerbose(@"  add a sequence or combiantor: %@", token);
            [selectors addSelector:token];

        } else {
            DDLogVerbose(@"  %@ is not a sequence or separator, push it back and abort sequence", [token class]);
            [assembly push:token];
            [assembly push:selectors];
            return;
        }
    }

    [assembly push:selectors];
    return;
}

@end
