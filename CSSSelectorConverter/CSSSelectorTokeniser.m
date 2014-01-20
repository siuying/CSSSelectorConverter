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

@implementation CSSSelectorTokeniser
    
-(id) init {
    self = [super init];

    [self addTokenRecogniser:[CPIdentifierRecogniser identifierRecogniser]];
    [self addTokenRecogniser:[CPNumberRecogniser numberRecogniser]];
    [self addTokenRecogniser:[CPWhiteSpaceRecogniser whiteSpaceRecogniser]];
    [self addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"\""
                                                                       endQuote:@"\""
                                                                           name:@"DoubleQuoted"]];
    [self addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"\'"
                                                                       endQuote:@"\'"
                                                                           name:@"SingleQuoted"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"|="]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"~="]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@":"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@","]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"."]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"#"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"+"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"-"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"="]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"("]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@")"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"["]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"]"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"*"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@">"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"@"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"~"]];

    return self;
}

@end
