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
        CPTokenStream *expected = [CPTokenStream tokenStreamWithTokens:[NSArray arrayWithObjects:
                                                                        [CPIdentifierToken tokenWithIdentifier:@"table"],
                                                                        [CPEOFToken eof],
                                                                        nil]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"table.a"];
        expected = [CPTokenStream tokenStreamWithTokens:@[
                                                          [CPIdentifierToken tokenWithIdentifier:@"table"],
                                                          [CPKeywordToken tokenWithKeyword:@"."],
                                                          [CPIdentifierToken tokenWithIdentifier:@"a"],
                                                          [CPEOFToken eof]
                                                          ]];
        [[tokenStream should] equal:expected];
    });
    
    it(@"tokenize complex selector", ^{
        CSSSelectorTokeniser* tokeniser = [[CSSSelectorTokeniser alloc] init];
        CPTokenStream *tokenStream = [tokeniser tokenise:@"table a"];
        CPTokenStream *expected = [CPTokenStream tokenStreamWithTokens:@[
                                                          [CPIdentifierToken tokenWithIdentifier:@"table"],
                                                          [CPWhiteSpaceToken whiteSpace:@" "],
                                                          [CPIdentifierToken tokenWithIdentifier:@"a"],
                                                          [CPEOFToken eof]
                                                          ]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"table > a"];
        expected = [CPTokenStream tokenStreamWithTokens:@[
                                                          [CPIdentifierToken tokenWithIdentifier:@"table"],
                                                          [CPKeywordToken tokenWithKeyword:@">"],
                                                          [CPIdentifierToken tokenWithIdentifier:@"a"],
                                                          [CPEOFToken eof]
                                                          ]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"table ~ a"];
        expected = [CPTokenStream tokenStreamWithTokens:@[
                                                          [CPIdentifierToken tokenWithIdentifier:@"table"],
                                                          [CPKeywordToken tokenWithKeyword:@"~"],
                                                          [CPIdentifierToken tokenWithIdentifier:@"a"],
                                                          [CPEOFToken eof]
                                                          ]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"table ~ a"];
        expected = [CPTokenStream tokenStreamWithTokens:@[
                                                          [CPIdentifierToken tokenWithIdentifier:@"table"],
                                                          [CPKeywordToken tokenWithKeyword:@"~"],
                                                          [CPIdentifierToken tokenWithIdentifier:@"a"],
                                                          [CPEOFToken eof]
                                                          ]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"table , a"];
        expected = [CPTokenStream tokenStreamWithTokens:@[
                                                          [CPIdentifierToken tokenWithIdentifier:@"table"],
                                                          [CPKeywordToken tokenWithKeyword:@","],
                                                          [CPIdentifierToken tokenWithIdentifier:@"a"],
                                                          [CPEOFToken eof]
                                                          ]];
        [[tokenStream should] equal:expected];
    });
    
    it(@"tokenize pseudo class", ^{
        CSSSelectorTokeniser* tokeniser = [[CSSSelectorTokeniser alloc] init];
        CPTokenStream *tokenStream = [tokeniser tokenise:@"div > p:first-child"];
        CPTokenStream *expected = [CPTokenStream tokenStreamWithTokens:@[
                                                                         [CPIdentifierToken tokenWithIdentifier:@"div"],
                                                                         [CPKeywordToken tokenWithKeyword:@">"],
                                                                         [CPIdentifierToken tokenWithIdentifier:@"p"],
                                                                         [CPKeywordToken tokenWithKeyword:@":"],
                                                                         [CPIdentifierToken tokenWithIdentifier:@"first-child"],
                                                                         [CPEOFToken eof]]];
        [[tokenStream should] equal:expected];
    });
    
    it(@"tokenize attribute", ^{
        CSSSelectorTokeniser* tokeniser = [[CSSSelectorTokeniser alloc] init];
        CPTokenStream *tokenStream = [tokeniser tokenise:@"div[class~=\"100\"]"];
        CPTokenStream *expected = [CPTokenStream tokenStreamWithTokens:[NSArray arrayWithObjects:
                                                                  [CPIdentifierToken tokenWithIdentifier:@"div"],
                                                                  [CPKeywordToken tokenWithKeyword:@"["],
                                                                  [CPIdentifierToken tokenWithIdentifier:@"class"],
                                                                  [CPKeywordToken tokenWithKeyword:@"~="],
                                                                  [CPQuotedToken content:@"100" quotedWith:@"\"" name:@"String"],
                                                                  [CPKeywordToken tokenWithKeyword:@"]"],
                                                                  [CPEOFToken eof],
                                                                  nil]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"div[class  |= \"100\"]"];
        expected = [CPTokenStream tokenStreamWithTokens:[NSArray arrayWithObjects:
                                                                        [CPIdentifierToken tokenWithIdentifier:@"div"],
                                                                        [CPKeywordToken tokenWithKeyword:@"["],
                                                                        [CPIdentifierToken tokenWithIdentifier:@"class"],
                                                                        [CPKeywordToken tokenWithKeyword:@"|="],
                                                                        [CPQuotedToken content:@"100" quotedWith:@"\"" name:@"String"],
                                                                        [CPKeywordToken tokenWithKeyword:@"]"],
                                                                        [CPEOFToken eof],
                                                                        nil]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"div[class = '100']"];
        expected = [CPTokenStream tokenStreamWithTokens:[NSArray arrayWithObjects:
                                                         [CPIdentifierToken tokenWithIdentifier:@"div"],
                                                         [CPKeywordToken tokenWithKeyword:@"["],
                                                         [CPIdentifierToken tokenWithIdentifier:@"class"],
                                                         [CPKeywordToken tokenWithKeyword:@"="],
                                                         [CPQuotedToken content:@"100" quotedWith:@"'" name:@"String"],
                                                         [CPKeywordToken tokenWithKeyword:@"]"],
                                                         [CPEOFToken eof],
                                                         nil]];
        [[tokenStream should] equal:expected];
    });
    
});

SPEC_END
