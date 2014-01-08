//
//  CSSCombinator.m
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSCombinator.h"
#import "DDLog.h"
#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF cssSelectorLogLevel
static const int cssSelectorLogLevel = LOG_LEVEL_WARN;

@implementation CSSCombinator

+(NSArray*) combinatorStrings {
    static dispatch_once_t onceToken;
    static NSArray* _combinatorStrings;
    dispatch_once(&onceToken, ^{
        _combinatorStrings = @[@">", @"+", @"~"];
    });
    return _combinatorStrings;
}

+(instancetype) emptyCombinator {
    CSSCombinator* combinator = [[self alloc] init];
    combinator.type = CSSCombinatorTypeNone;
    return combinator;
}

+(instancetype) descendantCombinator {
    CSSCombinator* combinator = [[self alloc] init];
    combinator.type = CSSCombinatorTypeDescendant;
    return combinator;
}

+(instancetype) adjacentCombinator {
    CSSCombinator* combinator = [[self alloc] init];
    combinator.type = CSSCombinatorTypeNone;
    return combinator;
}

+(instancetype) generalSiblingCombinator {
    CSSCombinator* combinator = [[self alloc] init];
    combinator.type = CSSCombinatorTypeGeneralSibling;
    return combinator;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<CSSCombinator %@>", self.typeString];
}

-(NSString*) typeString {
    switch (self.type) {
        case CSSCombinatorTypeNone:
        {
            return @"none";
        }
            break;
        case CSSCombinatorTypeDescendant:
        {
            return @"descendant";
        }
        case CSSCombinatorTypeAdjacent:
        {
            return @"adjacent";
        }
        case CSSCombinatorTypeGeneralSibling:
        {
            return @"general-sibling";
        }
    }
    return nil;
}

-(NSString*) toXPath {
    switch (self.type) {
        case CSSCombinatorTypeNone:
        {
            return @"//";
        }
            break;
        case CSSCombinatorTypeDescendant:
        {
            return @"/";
        }
        case CSSCombinatorTypeAdjacent:
        {
            return @"/following-sibling::*[1]/self::";
        }
        case CSSCombinatorTypeGeneralSibling:
        {
            return @"/following-sibling::";
        }
    }
    [NSException raise:NSInternalInconsistencyException format:@"unexpected type: %d", self.type];
}

+(void) pushCombinator:(PKAssembly*)assembly {
    id firstToken = [assembly pop];

    // if stack is empty, do nothing.
    if (!firstToken) {
        return;
    }

    if ([firstToken isSymbol]) {
        NSString* firstTokenString = [firstToken stringValue];
        if ([firstTokenString isEqualToString:@">"]) {
            DDLogVerbose(@"Push descendant combinator");
            CSSCombinator* combinator = [CSSCombinator descendantCombinator];
            [assembly push:combinator];
            return;
        } else if ([firstTokenString isEqualToString:@"+"]) {
            DDLogVerbose(@"Push adjacent combinator");
            CSSCombinator* combinator = [CSSCombinator adjacentCombinator];
            [assembly push:combinator];
            return;
        } else if ([firstTokenString isEqualToString:@"~"]) {
            DDLogVerbose(@"Push general sibling combinator");
            CSSCombinator* combinator = [CSSCombinator generalSiblingCombinator];
            [assembly push:combinator];
            return;
        }
    }

    DDLogVerbose(@"  stack is not a valid combinator, abort");
    [assembly push:firstToken];
    return;
}

@end
