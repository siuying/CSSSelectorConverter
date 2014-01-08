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
    static NSArray* _supportedPseudoClass;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _supportedPseudoClass = @[@"first-child", @"last-child", @"first-of-type", @"last-of-type"];
    });
    return _supportedPseudoClass;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<CSSPseudoClass %@>", self.name];
}

-(NSString*) toXPath {
    NSString* parentName = self.parent ? self.parent.name : @"*";
    if ([self.name isEqualToString:@"first-child"]) {
        return [NSString stringWithFormat:@"*[position() = 1 and self::%@]", parentName];
    } else if ([self.name isEqualToString:@"last-child"]) {
        return [NSString stringWithFormat:@"*[position() = last() and self::%@]", parentName];
    } else if ([self.name isEqualToString:@"first-of-type"]) {
        return [NSString stringWithFormat:@"%@[position() = 1]", parentName];
    } else if ([self.name isEqualToString:@"last-of-type"]) {
        return [NSString stringWithFormat:@"%@[position() = last()]", parentName];
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
