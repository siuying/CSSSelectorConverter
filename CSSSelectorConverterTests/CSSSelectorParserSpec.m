//
//  CSSSelectorGrammarSpec.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 1/20/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CSSSelectorParser.h"
#import "NUIParse.h"
#import "CSSSelectorGrammar.h"
#import "CSSSelectorTokeniser.h"

SPEC_BEGIN(CSSSelectorParserSpec)

describe(@"CSSSelectorParser", ^{
    context(@"serialization", ^{
        xit(@"should serialize and deserialize a parser", ^{
            CSSSelectorTokeniser* tokenizer1 = [[CSSSelectorTokeniser alloc] init];
            CSSSelectorTokeniser* tokenizer2 = [[CSSSelectorTokeniser alloc] init];

            NUIPLALR1Parser* parser1 = [NUIPLALR1Parser parserWithGrammar:[[CSSSelectorGrammar alloc] initWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"CSSSelectorGrammar" ofType:@"txt"]]];
            NUIPSyntaxTree* result1 = [parser1 parse:[tokenizer1 tokenise:@"title .article"]];
            
            NSData* data = [NSKeyedArchiver archivedDataWithRootObject:parser1];
            NUIPLALR1Parser *parser2 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NUIPSyntaxTree* result2 = [parser2 parse:[tokenizer2 tokenise:@"title .article"]];
            
            [[result1 should] equal:result2];
        });
    });
});

SPEC_END
