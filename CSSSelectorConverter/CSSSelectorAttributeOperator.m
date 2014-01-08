//
//  CSSSelectorAttributeType.m
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//
#import "DDLog.h"
#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF cssSelectorLogLevel
static const int cssSelectorLogLevel = LOG_LEVEL_VERBOSE;

#import "CSSSelectorAttributeOperator.h"

@implementation CSSSelectorAttributeOperator

+(instancetype) selectorWithName:(NSString*)name {
    CSSSelectorAttributeOperator* attrType = [[self alloc] init];
    attrType.name = name;
    attrType.attributeOperator = [self operatorWithString:name];
    return attrType;
}

-(NSString*) toXPath {
    return self.name;
}

+(CSSSelectorAttributeOperatorType) operatorWithString:(NSString*) type {
    if ([type isEqualToString:@"="]) {
        return CSSSelectorAttributeOperatorTypeEqual;
    } else if ([type isEqualToString:@"~="]) {
        return CSSSelectorAttributeOperatorTypeIncludes;
    }

    DDLogError(@"operator must be = or ~=, given: %@", type);
    [NSException raise:NSInvalidArgumentException format:@"operator must be = or ~=, given: %@", type];
    return CSSSelectorAttributeOperatorTypeNone;
}

@end
