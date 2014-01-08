//
//  CSSNthChild.m
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//
#import "DDLog.h"
#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF cssSelectorLogLevel
static const int cssSelectorLogLevel = LOG_LEVEL_WARN;

#import "CSSNthChild.h"

static const NSInteger CSSNthChildUnassigned = NSIntegerMax;

@interface CSSNthChild()
@property (nonatomic, assign) BOOL nAssigned;
@end

@implementation CSSNthChild

-(instancetype) init {
    self = [super init];
    self.constantA = CSSNthChildUnassigned;
    self.constantB = CSSNthChildUnassigned;
    self.nAssigned = NO;
    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<CSSNthChild %d n %d>", self.constantA, self.constantB];
}

-(NSString*) toXPath {
    NSString* parentName = self.parent ? self.parent.name : @"*";
    NSString* positionSign = self.constantA > 0 ? @">=" : @"<=";
    if (self.constantB == 0) {
        return [NSString stringWithFormat:@"%@[(position() mod %d) = 0]", parentName, self.constantA];
    } else {
        if (self.constantB > 0) {
            return [NSString stringWithFormat:@"%@[(position() %@ %d) and (((position()-%d) mod %d) = 0)]", parentName, positionSign,
                    self.constantB, self.constantB, self.constantA];
        } else {
            return [NSString stringWithFormat:@"%@[(position() %@ %d) and (((position()-%d) mod %d) = 0)]", parentName, positionSign,
                    self.constantA + self.constantB, self.constantA + self.constantB, self.constantA];
        }
    }
}

+(void) pushPseudoClass:(PKAssembly*)assembly {
    CSSNthChild* nthChild = [[CSSNthChild alloc] init];
    id token = nil;
    while ((token = [assembly pop])) {
        if ([token isKindOfClass:[PKToken class]]) {
            PKToken* pkToken = token;
            NSString* stringValue = [pkToken stringValue];
            if ([stringValue isEqualToString:@"nth"]) {
                if (nthChild.constantA == CSSNthChildUnassigned) {
                    nthChild.constantA = nthChild.constantB;
                    nthChild.constantB = CSSNthChildUnassigned;
                }
                [assembly push:nthChild];
                DDLogVerbose(@"Pushed: %@", nthChild);
                return;
            } else if ([stringValue isEqualToString:@"-"] || [stringValue isEqualToString:@"+"] || [stringValue isEqualToString:@"child"]) {
                // do nothing

            } else if ([stringValue isEqualToString:@"odd"]) {
                nthChild.constantA = 2;
                nthChild.constantB = 1;

            } else if ([stringValue isEqualToString:@"even"]) {
                nthChild.constantA = 2;
                nthChild.constantB = 0;
                
            } else if ([stringValue isEqualToString:@"even"]) {
                nthChild.constantA = 2;
                nthChild.constantB = 0;
                
            } else if ([stringValue isEqualToString:@"n"]) {
                nthChild.nAssigned = YES;
                
            } else if ([token isNumber]) {
                NSInteger intVal = [@([pkToken floatValue]) integerValue];
                if (nthChild.nAssigned) {
                    nthChild.constantA = intVal;
                } else {
                    nthChild.constantB = intVal;
                }
            }
        } else {
            [assembly push:token];
            [assembly push:nthChild];
            return;
        }
    }
}

@end
