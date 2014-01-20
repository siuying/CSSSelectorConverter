//
//  CSSSelectorGrammarSpec.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 1/20/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CSSSelectorGrammar.h"
#import "CPLALR1Parser.h"
#import "CSSSelectorTokeniser.h"
#import "CSSSelectorParserDelegate.h"

SPEC_BEGIN(CSSSelectorGrammarSpec)

describe(@"CSSSelectorGrammar", ^{
    it(@"parse css", ^{
        CSSSelectorTokeniser *tokeniser = [[CSSSelectorTokeniser alloc] init];
        CPTokenStream *tokenStream = [tokeniser tokenise:@"table"];
        CSSSelectorGrammar* grammar = [[CSSSelectorGrammar alloc] init];
        [[grammar shouldNot] beNil];
        
        CSSSelectorParserDelegate* delegate = [[CSSSelectorParserDelegate alloc] init];

        CPParser *parser = [CPLALR1Parser parserWithGrammar:grammar];
        parser.delegate = delegate;
        [[parser shouldNot] beNil];

        CPSyntaxTree* tree = [parser parse:tokenStream];
        [[tree shouldNot] beNil];
        NSLog(@"result = %@", tree);
    });
});

SPEC_END
