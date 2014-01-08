//
//  CSSSelectorGroup.m
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSSelectorGroup.h"

@implementation CSSSelectorGroup

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

+(instancetype) selectorsGroupWithAssembly:(PKAssembly*)assembly {
    CSSSelectorGroup* group = [[self alloc] init];
    id token;

    while ((token = [assembly pop])) {
        if ([token isKindOfClass:[CSSSelectors class]]) {
            NSLog(@" token is sequence: %@", token);
            CSSSelectors* selectors = token;
            [group addSelectors:selectors];
            
        } else {
            NSLog(@" token unknown: %@", token);
        }
    }

    [assembly push:group];
    return group;
}

@end
