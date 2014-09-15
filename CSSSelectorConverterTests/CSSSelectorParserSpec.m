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
    it(@"parse css", ^{
        CSSSelectorParser *parser = [[CSSSelectorParser alloc] init];
        CSSSelectorGroup* tree = [parser parse:@"table:first-child" error:nil];
        [[tree shouldNot] beNil];
        NSLog(@"result = %@", tree);
    });
    
//    context(@"serialization", ^{
//        it(@"should serialize and deserialize a parser", ^{
//            NSString* path = [[NSBundle bundleForClass:[CSSSelectorGrammar class]] pathForResource:@"CSSSelectorGrammar" ofType:@"txt"];
//            CPGrammar* grammar1 = [[CPGrammar alloc] initWithStart:@"CSSSelectorGroup" backusNaurForm:[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] error:nil];
//
//            NSString* outputFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"grammar.plist"];
//            [NSKeyedArchiver archiveRootObject:@{@"grammar" : grammar1}
//                                        toFile:outputFile];
//
//            CPGrammar* grammar2 = [NSKeyedUnarchiver unarchiveObjectWithFile:outputFile][@"grammar"];
//            [[grammar2 should] equal:grammar1];
//            [[[grammar2 allRules] should] equal:[grammar1 allRules]];
//
//            CSSSelectorTokeniser* tokeniser = [[CSSSelectorTokeniser alloc] init];
//            CPTokenStream *tokenStream = [tokeniser tokenise:@"table"];
//            CPParser* parser = [CPLALR1Parser parserWithGrammar:grammar2];
//            id result = [parser parse:tokenStream];
//            NSLog(@"result = %@", result);
//        });
//    });
});

SPEC_END
