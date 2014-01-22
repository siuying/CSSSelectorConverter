//
//  CSSSelectorXPathVisitorSpec.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 1/22/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CSSSelectorXPathVisitor.h"
#import "CSSSelectorGroup.h"
#import "CSSUniversalSelector.h"
#import "CSSIDSelector.h"
#import "CSSTypeSelector.h"
#import "CSSClassSelector.h"
#import "CSSSelectorSequence.h"

SPEC_BEGIN(CSSSelectorXPathVisitorSpec)

describe(@"CSSSelectorXPathVisitor", ^{
    __block CSSSelectorXPathVisitor* visitor;

    beforeEach(^{
        visitor = [[CSSSelectorXPathVisitor alloc] init];
    });

    it(@"render xpath for CSSUniversalSelector", ^{
        CSSUniversalSelector* selector = [[CSSUniversalSelector alloc] init];
        [visitor visit:selector];
        NSString* xpath = [visitor xpathString];
        [[xpath should] equal:@"*"];
    });
    
    it(@"render xpath for CSSTypeSelector", ^{
        CSSTypeSelector* selector = [[CSSTypeSelector alloc] init];
        selector.name = @"table";
        [visitor visit:selector];
        NSString* xpath = [visitor xpathString];
        [[xpath should] equal:@"table"];
    });
    
    it(@"render xpath for CSSIDSelector", ^{
        CSSIDSelector* selector = [[CSSIDSelector alloc] init];
        selector.name = @"p";
        [visitor visit:selector];
        NSString* xpath = [visitor xpathString];
        [[xpath should] equal:@"@id = 'p'"];
    });
    
    it(@"render xpath for CSSClassSelector", ^{
        CSSClassSelector* selector = [[CSSClassSelector alloc] init];
        selector.name = @"red";
        [visitor visit:selector];
        NSString* xpath = [visitor xpathString];
        [[xpath should] equal:@"contains(concat(' ', normalize-space(@class), ' '), ' red ')"];
    });
    
    it(@"render xpath for CSSSelectorSequence", ^{
        CSSClassSelector* classSelector = [[CSSClassSelector alloc] init];
        classSelector.name = @"red";
        
        CSSSelectorSequence* seq = [[CSSSelectorSequence alloc] init];
        seq.universalOrTypeSelector = [[CSSUniversalSelector alloc] init];
        [seq addSelector:classSelector];
        [visitor visit:seq];

        NSString* xpath = [visitor xpathString];
        [[xpath should] equal:@"*[contains(concat(' ', normalize-space(@class), ' '), ' red ')]"];
    });
});

SPEC_END
