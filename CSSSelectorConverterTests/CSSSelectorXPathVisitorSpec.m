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
#import "CSSSelectors.h"
#import "CSSCombinator.h"
#import "CSSSelectorAttribute.h"
#import "CSSSelectorAttributeOperator.h"
#import "NUIParse.h"

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
    
    it(@"render xpath for CSSCombinator", ^{
        CSSCombinator* selector = [[CSSCombinator alloc] init];
        selector.type = CSSCombinatorTypeNone;
        [visitor visit:selector];
        
        NSString* xpath = [visitor xpathString];
        [[xpath should] equal:@"//"];
    });

    it(@"render xpath for CSSSelectors", ^{
        CSSClassSelector* classSelector = [[CSSClassSelector alloc] init];
        classSelector.name = @"red";
        
        CSSSelectorSequence* seq = [[CSSSelectorSequence alloc] init];
        seq.universalOrTypeSelector = [[CSSUniversalSelector alloc] init];
        [seq addSelector:classSelector];
        
        CSSSelectors* selectors = [[CSSSelectors alloc] init];
        [selectors addSelector:seq];
        [visitor visit:selectors];
        
        NSString* xpath = [visitor xpathString];
        [[xpath should] equal:@"//*[contains(concat(' ', normalize-space(@class), ' '), ' red ')]"];
    });
    
    it(@"render xpath for CSSSelectorGroup", ^{
        CSSClassSelector* classSelector = [[CSSClassSelector alloc] init];
        classSelector.name = @"red";
        
        CSSSelectorSequence* seq = [[CSSSelectorSequence alloc] init];
        seq.universalOrTypeSelector = [[CSSTypeSelector alloc] init];
        seq.universalOrTypeSelector.name = @"table";
        [seq addSelector:classSelector];
        
        CSSSelectors* selectors = [[CSSSelectors alloc] init];
        [selectors addSelector:seq];

        CSSSelectorSequence* seq2 = [[CSSSelectorSequence alloc] init];
        seq2.universalOrTypeSelector = [[CSSTypeSelector alloc] init];
        seq2.universalOrTypeSelector.name = @"a";
        CSSSelectors* selectors2 = [[CSSSelectors alloc] init];
        [selectors2 addSelector:seq2];
        
        CSSSelectorGroup* group = [[CSSSelectorGroup alloc] init];
        [group addSelectors:selectors];
        [group addSelectors:selectors2];
        [visitor visit:group];
        
        NSString* xpath = [visitor xpathString];
        [[xpath should] equal:@"//table[contains(concat(' ', normalize-space(@class), ' '), ' red ')] | //a"];
    });
    
    context(@"render xpath for attribute", ^{
        it(@"render xpath for equal attribute", ^{
            CSSSelectorAttribute* attr = [[CSSSelectorAttribute alloc] init];
            attr.name = @"width";
            attr.value = @"30";
            attr.attributeOperator = [[CSSSelectorAttributeOperator alloc] init];
            attr.attributeOperator.attributeOperator = CSSSelectorAttributeOperatorTypeEqual;
            [visitor visit:attr];

            NSString* xpath = [visitor xpathString];
            [[xpath should] equal:@"@width = \"30\""];
        });

        it(@"render xpath for includes attribute", ^{
            CSSSelectorAttribute* attr = [[CSSSelectorAttribute alloc] init];
            attr.name = @"class";
            attr.value = @"red";
            attr.attributeOperator = [[CSSSelectorAttributeOperator alloc] init];
            attr.attributeOperator.attributeOperator = CSSSelectorAttributeOperatorTypeIncludes;
            [visitor visit:attr];

            NSString* xpath = [visitor xpathString];
            [[xpath should] equal:@"contains(concat(\" \", @class, \" \"),concat(\" \", \"red\", \" \"))"];
        });

        it(@"render xpath for equal attribute", ^{
            CSSSelectorAttribute* attr = [[CSSSelectorAttribute alloc] init];
            attr.name = @"class";
            attr.value = @"red";
            attr.attributeOperator = [[CSSSelectorAttributeOperator alloc] init];
            attr.attributeOperator.attributeOperator = CSSSelectorAttributeOperatorTypeDash;
            [visitor visit:attr];
            
            NSString* xpath = [visitor xpathString];
            [[xpath should] equal:@"@class = \"red\" or starts-with(@class, concat(\"red\", '-'))"];
        });
    });
    
    context(@"render xpath for pseudo class", ^{
        it(@"render xpath for equal attribute", ^{
            CSSSelectorAttribute* attr = [[CSSSelectorAttribute alloc] init];
            attr.name = @"width";
            attr.value = @"30";
            attr.attributeOperator = [[CSSSelectorAttributeOperator alloc] init];
            attr.attributeOperator.attributeOperator = CSSSelectorAttributeOperatorTypeEqual;
            [visitor visit:attr];
            
            NSString* xpath = [visitor xpathString];
            [[xpath should] equal:@"@width = \"30\""];
        });
    });
});

SPEC_END
