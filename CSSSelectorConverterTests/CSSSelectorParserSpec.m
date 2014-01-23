//
//  CSSSelectorGrammarSpec.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 1/20/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CSSSelectorParser.h"

SPEC_BEGIN(CSSSelectorParserSpec)

describe(@"CSSSelectorParser", ^{
    it(@"parse css", ^{
        CSSSelectorParser *parser = [[CSSSelectorParser alloc] init];
        CSSSelectorGroup* tree = [parser parse:@"table:first-child" error:nil];
        [[tree shouldNot] beNil];
        NSLog(@"result = %@", tree);
    });
});

SPEC_END
