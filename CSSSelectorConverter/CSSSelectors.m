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
#import "CSSChildSelector.h"

@implementation CSSSelectors

-(instancetype) init {
    self = [super init];
    self.sequences = [[NSMutableArray alloc] init];
    return self;
}

-(void) addSequence:(CSSSelectorSequence*)sequence {
    [self.sequences addObject:sequence];
}

-(void) addChild:(CSSChildSelector*)child {
    [self.sequences addObject:child];
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<CSSSelectors %@>", self.sequences];
}

-(NSString*) toXPath {
    NSMutableString* result = [[NSMutableString alloc] init];
    
    NSArray* reverseSequence = [[self.sequences reverseObjectEnumerator] allObjects];
    [reverseSequence enumerateObjectsUsingBlock:^(CSSBaseSelector* selector, NSUInteger idx, BOOL *stop) {
        [result appendString:selector.toXPath];
    }];

    return [result copy];
}

+(instancetype) selectorWithAssembly:(PKAssembly*)assembly {
    DDLogVerbose(@"create CSSSelectors ...");
    CSSSelectors* selectors = [[self alloc] init];
    CSSSelectorSequence* sequence1 = [assembly pop];
    [selectors addSequence:sequence1];

    id token;
    while ((token = [assembly pop])) {
        if ([token isKindOfClass:[CSSSelectorSequence class]]) {
            DDLogVerbose(@"  add a sequence: %@", token);
            CSSSelectorSequence* sequence = token;
            [selectors addSequence:sequence];

        } else {
            DDLogVerbose(@"  %@ is not a sequence or separator, push it back and abort sequence", [token class]);
            [assembly push:token];
            [assembly push:selectors];
            return selectors;
        }
    }

    [assembly push:selectors];
    return selectors;
}

@end
