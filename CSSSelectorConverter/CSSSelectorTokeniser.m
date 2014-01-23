//
//  CSSSelectorTokeniser.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 1/20/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSSelectorTokeniser.h"
#import "CPNumberRecogniser.h"
#import "CPWhiteSpaceRecogniser.h"
#import "CPQuotedRecogniser.h"
#import "CPKeywordRecogniser.h"
#import "CPIdentifierRecogniser.h"
#import "CPRegexpRecogniser.h"

@implementation CSSSelectorTokeniser
    
-(id) init {
    self = [super init];

    [self addTokenRecogniser:[CPIdentifierRecogniser identifierRecogniser]];
    [self addTokenRecogniser:[CPNumberRecogniser numberRecogniser]];
    [self addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"\""
                                                                       endQuote:@"\""
                                                                           name:@"String"]];
    [self addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"\'"
                                                                       endQuote:@"\'"
                                                                           name:@"String"]];
    
    CPRegexpKeywordRecogniserMatchHandler trimSpaceHandler = ^(NSString* tokenString, NSTextCheckingResult* match){
        NSString* matched = [tokenString substringWithRange:match.range];
        return [CPKeywordToken tokenWithKeyword:[matched stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    };
    
    [self addTokenRecogniser:[CPRegexpRecogniser recogniserForRegexp:[NSRegularExpression regularExpressionWithPattern:@"[ \t\r\n\f]*(\\~\\=)[ \t\r\n\f]*" options:0 error:nil]
                                                        matchHandler:trimSpaceHandler]];
    [self addTokenRecogniser:[CPRegexpRecogniser recogniserForRegexp:[NSRegularExpression regularExpressionWithPattern:@"[ \t\r\n\f]*(\\|\\=)[ \t\r\n\f]*" options:0 error:nil]
                                                        matchHandler:trimSpaceHandler]];
    [self addTokenRecogniser:[CPRegexpRecogniser recogniserForRegexp:[NSRegularExpression regularExpressionWithPattern:@"[ \t\r\n\f]*(\\=)[ \t\r\n\f]*" options:0 error:nil]
                                                        matchHandler:trimSpaceHandler]];
    [self addTokenRecogniser:[CPRegexpRecogniser recogniserForRegexp:[NSRegularExpression regularExpressionWithPattern:@"[ \t\r\n\f]*(\\~)[ \t\r\n\f]*" options:0 error:nil]
                                                        matchHandler:trimSpaceHandler]];
    [self addTokenRecogniser:[CPRegexpRecogniser recogniserForRegexp:[NSRegularExpression regularExpressionWithPattern:@"[ \t\r\n\f]*(\\+)[ \t\r\n\f]*" options:0 error:nil]
                                                        matchHandler:trimSpaceHandler]];
    [self addTokenRecogniser:[CPRegexpRecogniser recogniserForRegexp:[NSRegularExpression regularExpressionWithPattern:@"[ \t\r\n\f]*(\\>)[ \t\r\n\f]*" options:0 error:nil]
                                                        matchHandler:trimSpaceHandler]];
    [self addTokenRecogniser:[CPRegexpRecogniser recogniserForRegexp:[NSRegularExpression regularExpressionWithPattern:@"[ \t\r\n\f]*(\\,)[ \t\r\n\f]*" options:0 error:nil]
                                                        matchHandler:trimSpaceHandler]];

    [self addTokenRecogniser:[CPWhiteSpaceRecogniser whiteSpaceRecogniser]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@":"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"."]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"#"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"-"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"("]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@")"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"["]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"]"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"*"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"@"]];

    return self;
}

@end
