//
//  CSSSelectors.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSSelectors.h"

@implementation CSSSelectors

-(instancetype) init {
    self = [super init];
    self.sequences = [[NSMutableArray alloc] init];
    return self;
}

-(void) addSequence:(CSSSelectorSequence*)sequence {
    [self.sequences addObject:sequence];
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<CSSSelectors %@>", self.sequences];
}

-(NSString*) toXPath {
    NSMutableString* result = [[NSMutableString alloc] init];

    [self.sequences enumerateObjectsUsingBlock:^(CSSSelectorSequence* selector, NSUInteger idx, BOOL *stop) {
        [result appendString:selector.toXPath];
    }];

    return [result copy];
}

+(instancetype) selectorWithAssembly:(PKSTokenAssembly*)assembly {
    CSSSelectors* selectors = [[self alloc] init];
    CSSSelectorSequence* sequence = nil;
    while ((sequence = [assembly pop])) {
        if ([sequence isKindOfClass:[CSSSelectorSequence class]]) {
            [selectors addSequence:sequence];
        } else {
            [assembly push:sequence];
            [assembly push:selectors];
            return selectors;
        }
    }
    [assembly push:selectors];
    return selectors;
}

@end
