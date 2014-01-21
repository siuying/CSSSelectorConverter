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

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree {
    self = [self init];
    NSArray *components = [syntaxTree children];
    if ([components count] >= 1) {
        id component = components[0];
        if ([component isWhiteSpaceToken]) {
            self.type = CSSCombinatorTypeNone;
        } else if ([component isSyntaxTree]) {
            id token = [component children][0];
            if ([token isKeywordToken]) {
                NSString* keyword = [token keyword];
                if ([keyword isEqualToString:@">"]) {
                    self.type = CSSCombinatorTypeDescendant;
                } else if ([keyword isEqualToString:@"+"]) {
                    self.type = CSSCombinatorTypeAdjacent;
                } else if ([keyword isEqualToString:@"~"]) {
                    self.type = CSSCombinatorTypeGeneralSibling;
                } else {
                    [NSException raise:NSInvalidArgumentException format:@"Unexpected keyword: %@", keyword];
                }
            } else {
                [NSException raise:NSInvalidArgumentException format:@"Unexpected token, not a keyword: %@", token];
            }
        }

    }
    return self;
}

+(NSArray*) combinatorStrings {
    static dispatch_once_t onceToken;
    static NSArray* _combinatorStrings;
    dispatch_once(&onceToken, ^{
        _combinatorStrings = @[@">", @"+", @"~"];
    });
    return _combinatorStrings;
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


@end
