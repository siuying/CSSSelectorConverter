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
    DDLogVerbose(@"create CSSSelectorGroup ...");
    CSSSelectorGroup* group = [[self alloc] init];
    id token;

    while ((token = [assembly pop])) {
        if ([token isKindOfClass:[CSSSelectors class]]) {
            DDLogVerbose(@"  add a selector: %@", token);
            CSSSelectors* selectors = token;
            [group addSelectors:selectors];
            
        } else {
            DDLogVerbose(@"  %@ is not a selector, push it back and abort sequence", [token class]);
            [assembly push:token];
            [assembly push:group];
            return group;
        }
    }

    [assembly push:group];
    return group;
}

@end
