//
//  CSSTypeSelector.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSTypeSelector.h"
#import "CoreParse.h"

@implementation CSSTypeSelector

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree {
    self = [self init];
    if (self) {
        NSArray *components = [syntaxTree children];
        if ([components count] == 1) {
            CPIdentifierToken* token = components[0];
            if ([token isIdentifierToken]) {
                self.name = [token identifier];
            }
        }
    }
    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<TypeSelector %@>", self.name];
}

@end
