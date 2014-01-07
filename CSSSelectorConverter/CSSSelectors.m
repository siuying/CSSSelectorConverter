//
//  CSSSelectors.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

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
        if (idx == 0) {
            [result appendString:@"//"];
        } else {
            if ([selector isKindOfClass:[CSSChildSelector class]]) {
                [result appendString:selector.toXPath];
                return;
            } else if (![[reverseSequence objectAtIndex:idx-1] isKindOfClass:[CSSChildSelector class]]) {
                [result appendString:@"//"];
            }
        }
        [result appendString:selector.toXPath];
    }];

    return [result copy];
}

+(instancetype) selectorWithAssembly:(PKAssembly*)assembly {
    CSSSelectors* selectors = [[self alloc] init];
    CSSSelectorSequence* sequence1 = [assembly pop];
    [selectors addSequence:sequence1];

    id token;
    while ((token = [assembly pop])) {
        if ([token isKindOfClass:[CSSSelectorSequence class]]) {
            NSLog(@" token is sequence: %@", token);
            CSSSelectorSequence* sequence = token;
            [selectors addSequence:sequence];

        } else {
            NSLog(@" token is separator: %@", token);
            NSString* tokenString;
            if ([token respondsToSelector:@selector(stringValue)]) {
                tokenString = [token stringValue];
            } else {
                tokenString = [token description];
            }
            if ([tokenString isEqualToString:@">"]) {
                [selectors addChild:[CSSChildSelector selector]];
            }
        }
    }

    [assembly push:selectors];
    return selectors;
}

@end
