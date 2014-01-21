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
#import "CSSNthChild.h"

@implementation CSSPseudoClass

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree {
    self = [self init];
    
    id token = [syntaxTree valueForTag:@"className"];
    if ([token isIdentifierToken]) {
        self.name = [token identifier];
    }

    return self;
}

+(NSArray*) supportedPseudoClass {
    return [[self pseudoClassXPathMapping] allKeys];
}

+(NSDictionary*) pseudoClassXPathMapping {
    static NSDictionary* _pseudoClassXPathMapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _pseudoClassXPathMapping = @{
                                  @"first-child": @"*[position() = 1 and self::%@]",
                                  @"last-child": @"*[position() = last() and self::%@]",
                                  @"first-of-type": @"%@[position() = 1]",
                                  @"last-of-type":@"%@[position() = last()]",
                                  @"only-child": @"*[last() = 1 and self::%@]",
                                  @"only-of-type": @"%@[last() = 1]",
                                  @"empty": @"%@[not(node())]",
                                  @"nth-child": @"%@" // implemented in subclass
                                  };
    });
    return _pseudoClassXPathMapping;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<CSSPseudoClass %@>", self.name];
}

-(NSString*) toXPath {
    NSString* parentName = self.parent ? self.parent.name : @"*";
    NSString* mapping = [CSSPseudoClass pseudoClassXPathMapping][self.name];
    
    if (mapping) {
        return [NSString stringWithFormat:mapping, parentName];
    } else {
        return @"";
    }
}

//+(void) pushPseudoClass:(PKAssembly*)assembly {
//    id token = nil;
//
//    NSMutableArray* tokens = [[NSMutableArray alloc] init];
//    while (( token = [assembly pop] )) {
//        if ([token isKindOfClass:[PKToken class]] && [token respondsToSelector:@selector(stringValue)]) {
//            NSString* name = [token stringValue];
//            [tokens addObject:name];
//        } else {
//            [assembly push:token];
//            break;
//        }
//    }
//    
//    if ([tokens count] == 0) {
//        return;
//    }
//    
//    NSString* className = [[[tokens reverseObjectEnumerator] allObjects] componentsJoinedByString:@""];
//    if ([[CSSPseudoClass supportedPseudoClass] indexOfObject:className] != NSNotFound) {
//        CSSPseudoClass* pseudo = [CSSPseudoClass selectorWithName:className];
//        [assembly push:pseudo];
//        DDLogInfo(@"Push Pseudo class %@", className);
//    } else {
//        DDLogWarn(@"Not supported pseudo class: %@", className);
//        return;
//    }
//}

@end
