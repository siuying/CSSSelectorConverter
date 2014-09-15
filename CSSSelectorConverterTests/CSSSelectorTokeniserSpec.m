//
//  CSSSelectorTokeniserSpec.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 1/20/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CSSSelectorTokeniser.h"
#import "NUIParse.h"

SPEC_BEGIN(CSSSelectorTokeniserSpec)

describe(@"CSSSelectorTokeniser", ^{
    it(@"tokenize basic css", ^{
        CSSSelectorTokeniser* tokeniser = [[CSSSelectorTokeniser alloc] init];
        NUIPTokenStream *tokenStream = [tokeniser tokenise:@"table"];
        NUIPTokenStream *expected = [NUIPTokenStream tokenStreamWithTokens:[NSArray arrayWithObjects:
                                                                        [NUIPIdentifierToken tokenWithIdentifier:@"table"],
                                                                        [NUIPEOFToken eof],
                                                                        nil]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"table.a"];
        expected = [NUIPTokenStream tokenStreamWithTokens:@[
                                                          [NUIPIdentifierToken tokenWithIdentifier:@"table"],
                                                          [NUIPKeywordToken tokenWithKeyword:@"."],
                                                          [NUIPIdentifierToken tokenWithIdentifier:@"a"],
                                                          [NUIPEOFToken eof]
                                                          ]];
        [[tokenStream should] equal:expected];
    });
    
    it(@"tokenize complex selector", ^{
        CSSSelectorTokeniser* tokeniser = [[CSSSelectorTokeniser alloc] init];
        NUIPTokenStream *tokenStream = [tokeniser tokenise:@"table a"];
        NUIPTokenStream *expected = [NUIPTokenStream tokenStreamWithTokens:@[
                                                          [NUIPIdentifierToken tokenWithIdentifier:@"table"],
                                                          [NUIPWhiteSpaceToken whiteSpace:@" "],
                                                          [NUIPIdentifierToken tokenWithIdentifier:@"a"],
                                                          [NUIPEOFToken eof]
                                                          ]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"table > a"];
        expected = [NUIPTokenStream tokenStreamWithTokens:@[
                                                          [NUIPIdentifierToken tokenWithIdentifier:@"table"],
                                                          [NUIPKeywordToken tokenWithKeyword:@">"],
                                                          [NUIPIdentifierToken tokenWithIdentifier:@"a"],
                                                          [NUIPEOFToken eof]
                                                          ]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"table ~ a"];
        expected = [NUIPTokenStream tokenStreamWithTokens:@[
                                                          [NUIPIdentifierToken tokenWithIdentifier:@"table"],
                                                          [NUIPKeywordToken tokenWithKeyword:@"~"],
                                                          [NUIPIdentifierToken tokenWithIdentifier:@"a"],
                                                          [NUIPEOFToken eof]
                                                          ]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"table ~ a"];
        expected = [NUIPTokenStream tokenStreamWithTokens:@[
                                                          [NUIPIdentifierToken tokenWithIdentifier:@"table"],
                                                          [NUIPKeywordToken tokenWithKeyword:@"~"],
                                                          [NUIPIdentifierToken tokenWithIdentifier:@"a"],
                                                          [NUIPEOFToken eof]
                                                          ]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"table , a"];
        expected = [NUIPTokenStream tokenStreamWithTokens:@[
                                                          [NUIPIdentifierToken tokenWithIdentifier:@"table"],
                                                          [NUIPKeywordToken tokenWithKeyword:@","],
                                                          [NUIPIdentifierToken tokenWithIdentifier:@"a"],
                                                          [NUIPEOFToken eof]
                                                          ]];
        [[tokenStream should] equal:expected];
    });
    
    it(@"tokenize pseudo class", ^{
        CSSSelectorTokeniser* tokeniser = [[CSSSelectorTokeniser alloc] init];
        NUIPTokenStream *tokenStream = [tokeniser tokenise:@"div > p:first-child"];
        NUIPTokenStream *expected = [NUIPTokenStream tokenStreamWithTokens:@[
                                                                         [NUIPIdentifierToken tokenWithIdentifier:@"div"],
                                                                         [NUIPKeywordToken tokenWithKeyword:@">"],
                                                                         [NUIPIdentifierToken tokenWithIdentifier:@"p"],
                                                                         [NUIPKeywordToken tokenWithKeyword:@":"],
                                                                         [NUIPIdentifierToken tokenWithIdentifier:@"first-child"],
                                                                         [NUIPEOFToken eof]]];
        [[tokenStream should] equal:expected];
    });
    
    it(@"tokenize attribute", ^{
        CSSSelectorTokeniser* tokeniser = [[CSSSelectorTokeniser alloc] init];
        NUIPTokenStream *tokenStream = [tokeniser tokenise:@"div[class~=\"100\"]"];
        NUIPTokenStream *expected = [NUIPTokenStream tokenStreamWithTokens:[NSArray arrayWithObjects:
                                                                  [NUIPIdentifierToken tokenWithIdentifier:@"div"],
                                                                  [NUIPKeywordToken tokenWithKeyword:@"["],
                                                                  [NUIPIdentifierToken tokenWithIdentifier:@"class"],
                                                                  [NUIPKeywordToken tokenWithKeyword:@"~="],
                                                                  [NUIPQuotedToken content:@"100" quotedWith:@"\"" name:@"String"],
                                                                  [NUIPKeywordToken tokenWithKeyword:@"]"],
                                                                  [NUIPEOFToken eof],
                                                                  nil]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"div[class  |= \"100\"]"];
        expected = [NUIPTokenStream tokenStreamWithTokens:[NSArray arrayWithObjects:
                                                                        [NUIPIdentifierToken tokenWithIdentifier:@"div"],
                                                                        [NUIPKeywordToken tokenWithKeyword:@"["],
                                                                        [NUIPIdentifierToken tokenWithIdentifier:@"class"],
                                                                        [NUIPKeywordToken tokenWithKeyword:@"|="],
                                                                        [NUIPQuotedToken content:@"100" quotedWith:@"\"" name:@"String"],
                                                                        [NUIPKeywordToken tokenWithKeyword:@"]"],
                                                                        [NUIPEOFToken eof],
                                                                        nil]];
        [[tokenStream should] equal:expected];
        
        tokenStream = [tokeniser tokenise:@"div[class = '100']"];
        expected = [NUIPTokenStream tokenStreamWithTokens:[NSArray arrayWithObjects:
                                                         [NUIPIdentifierToken tokenWithIdentifier:@"div"],
                                                         [NUIPKeywordToken tokenWithKeyword:@"["],
                                                         [NUIPIdentifierToken tokenWithIdentifier:@"class"],
                                                         [NUIPKeywordToken tokenWithKeyword:@"="],
                                                         [NUIPQuotedToken content:@"100" quotedWith:@"'" name:@"String"],
                                                         [NUIPKeywordToken tokenWithKeyword:@"]"],
                                                         [NUIPEOFToken eof],
                                                         nil]];
        [[tokenStream should] equal:expected];
    });
    
});

SPEC_END
