//
//  CSSSelectorTokeniserSpec.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 1/20/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CSSSelectorTokeniser.h"


SPEC_BEGIN(CSSSelectorTokeniserSpec)

describe(@"CSSSelectorTokeniser", ^{
    it(@"tokenize basic css", ^{
        CSSSelectorTokeniser* tokeniser = [[CSSSelectorTokeniser alloc] init];
        CPTokenStream *tokenStream = [tokeniser tokenise:@"table"];
        [[[tokenStream description] should] containString:@"<Identifier: table>"];

        tokenStream = [tokeniser tokenise:@"table a"];
        [[[tokenStream description] should] containString:@"<Identifier: table> <Whitespace> <Identifier: a>"];

        tokenStream = [tokeniser tokenise:@"table > .a"];
        [[[tokenStream description] should] containString:@"<Identifier: table> <Whitespace> <Keyword: >> <Whitespace> <Keyword: .> <Identifier: a>"];

        tokenStream = [tokeniser tokenise:@"#a[@a = 'b']"];
        [[[tokenStream description] should] containString:@"<Keyword: #> <Identifier: a> <Keyword: [> <Keyword: @> <Identifier: a> <Whitespace> <Keyword: => <Whitespace> <SingleQuoted: b> <Keyword: ]>"];
    });
       
});

SPEC_END
