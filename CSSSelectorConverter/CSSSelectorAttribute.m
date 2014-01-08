//
//  CSSSelectorAttribute.m
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSSelectorAttribute.h"
#import "DDLog.h"
#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF cssSelectorLogLevel
static const int cssSelectorLogLevel = LOG_LEVEL_VERBOSE;

@implementation CSSSelectorAttribute

-(NSString*) description {
    return [NSString stringWithFormat:@"<CSSSelectorAttribute %@ %@ %@>", self.name, self.type, self.value];
}

-(NSString*) toXPath {
    NSMutableString* result = [[NSMutableString alloc] init];

    if (self.value) {
        switch (self.type.attributeOperator) {
            case CSSSelectorAttributeOperatorTypeEqual: {
                [result appendString:@"@"];
                [result appendString:self.name];
                [result appendString:@" = "];
                [result appendString:self.value];
            }
                break;
            case CSSSelectorAttributeOperatorTypeIncludes: {
                [result appendString:[NSString stringWithFormat:@"contains(concat(\" \", @%@, \" \"),concat(\" \", %@, \" \"))", self.name, self.value]];
            }
                break;
            default:
                break;
        }
    } else {
        [result appendString:@"@"];
        [result appendString:self.name];
    }

    return [result copy];
}

// '['! Word ((equal | includes) QuotedString)? ']'!
+(instancetype) attributeWithAssembly:(PKAssembly*)assembly {
    DDLogVerbose(@"create CSSSelectorAttribute ...");
    CSSSelectorAttribute* attribute = [CSSSelectorAttribute selector];
    PKToken* token = assembly.pop;
    if (![token isWord] && ![token isNumber] && ![token isQuotedString]) {
        [NSException raise:NSInvalidArgumentException format:@"Attribute first token must be a Word or Number or QuotedString!"];
        return nil;
    }
    NSString* firstValue = [token stringValue];

    id secondToken = assembly.pop;
    if (!secondToken || ![secondToken respondsToSelector:@selector(isSymbol)]) {
        attribute.name = firstValue;
        DDLogVerbose(@"  name=%@", attribute.name);
        [assembly push:secondToken];
        [assembly push:attribute];
        return attribute;
    } else if (secondToken && [secondToken respondsToSelector:@selector(isSymbol)] && [secondToken isSymbol]) {
        attribute.value = firstValue;
        attribute.type = [CSSSelectorAttributeOperator selectorWithName:[secondToken stringValue]];
    }

    PKToken* thirdToken = assembly.pop;
    if (!thirdToken || ![thirdToken isKindOfClass:[PKToken class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Attribute with operator require third operator"];
        return nil;
    }

    attribute.name = thirdToken.stringValue;
    DDLogVerbose(@"  %@%@%@", attribute.name, attribute.type, attribute.value);

    [assembly push:attribute];
    return attribute;
}

@end
