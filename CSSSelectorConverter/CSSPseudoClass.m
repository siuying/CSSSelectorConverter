//
//  CSSPseudoClass.m
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//
#import "DDLog.h"
#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF cssSelectorLogLevel
static const int cssSelectorLogLevel = LOG_LEVEL_WARN;

#import "CSSPseudoClass.h"
#import "CoreParse.h"

@implementation CSSPseudoClass

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree {
    self = [self init];
    
    id token = [syntaxTree valueForTag:@"className"];
    if ([token isIdentifierToken]) {
        self.name = [token identifier];
    }

    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<CSSPseudoClass %@>", self.name];
}

@end
