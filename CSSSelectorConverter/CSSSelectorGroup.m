//
//  CSSSelectorGroup.m
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSSelectorGroup.h"
#import "CoreParse.h"

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
        
        NSArray* subtree = [syntaxTree valueForTag:@"otherSelectors"];
        NSArray* flattenSubtree = [subtree valueForKeyPath: @"@unionOfArrays.self"];
        [flattenSubtree enumerateObjectsUsingBlock:^(CSSSelectors* other, NSUInteger idx, BOOL *stop) {
            if ([other isKindOfClass:[CSSSelectors class]]) {
                [self addSelectors:other];
            }
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
    return [NSString stringWithFormat:@"<CSSSelectorGroup %@>", [self.selectors componentsJoinedByString:@", "]];
}

@end
