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

@implementation CSSPseudoClass

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
                                  @"last-of-type":@"%@[position() = last()]"
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

+(void) pushPseudoClass:(PKAssembly*)assembly {
    id token = [assembly pop];
    if ([token isKindOfClass:[PKToken class]] && [token respondsToSelector:@selector(stringValue)]) {
        NSString* name = [token stringValue];
        if ([[CSSPseudoClass supportedPseudoClass] indexOfObject:name] != NSNotFound) {
            CSSPseudoClass* pseudo = [CSSPseudoClass selectorWithName:[token stringValue]];
            [assembly push:pseudo];
            DDLogInfo(@"Push Pseudo class %@", [pseudo description]);
        } else {
            DDLogWarn(@"Not supported pseudo class: %@", name);
        }
    } else {
        [assembly push:token];
    }
}

@end
