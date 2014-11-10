//
//  NewKiwiSpec.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import "Kiwi.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "CSSSelectorConverter.h"
#import "NUIParse.h"

SPEC_BEGIN(CSSToXPathConverterSpec)
__block CSSSelectorToXPathConverter *converter;

describe(@"CSSToXPathParser", ^{
    beforeAll(^{
        DDTTYLogger* ttyLogger = [DDTTYLogger sharedInstance];
        [DDLog addLogger:ttyLogger];
    });

    afterAll(^{
        [DDLog flushLog];
    });

    beforeEach(^{
        converter = [[CSSSelectorToXPathConverter alloc] init];
    });
    
    it(@"should parse universal selector", ^{
        NSString* css = [converter xpathWithCSS:@"*" error:nil];
        [[css should] equal:@"//*"];
    });

    it(@"should parse type selector", ^{
        NSString* css = [converter xpathWithCSS:@"p" error:nil];
        [[css should] equal:@"//p"];
    });
    
    it(@"should parse multiple type selector", ^{
        NSString* css = [converter xpathWithCSS:@"h3 strong a, #fbPhotoPageAuthorName, title" error:nil];
        [[css should] equal:@"//h3//strong//a | //*[@id = 'fbPhotoPageAuthorName'] | //title"];
    });

    it(@"should parse id selector", ^{
        NSString* css = [converter xpathWithCSS:@"#header" error:nil];
        [[css should] equal:@"//*[@id = 'header']"];
    });

    it(@"should parse class selector", ^{
        NSString* css = [converter xpathWithCSS:@".header" error:nil];
        [[css should] equal:@"//*[contains(concat(' ', normalize-space(@class), ' '), ' header ')]"];
    });
    
    it(@"should parse type with mixed class and id selector", ^{
        NSString* css = [converter xpathWithCSS:@"p#header.red" error:nil];
        [[css should] equal:@"//p[@id = 'header' and contains(concat(' ', normalize-space(@class), ' '), ' red ')]"];
    });

    it(@"should parse simple selector sequence", ^{
        NSString* css = [converter xpathWithCSS:@"div p" error:nil];
        [[css should] equal:@"//div//p"];
        
        css = [converter xpathWithCSS:@"div *" error:nil];
        [[css should] equal:@"//div//*"];
        
        css = [converter xpathWithCSS:@"div#main p" error:nil];
        [[css should] equal:@"//div[@id = 'main']//p"];
    });
    
    it(@"should parse descendant selector sequence", ^{
        NSString* descendantCss = [converter xpathWithCSS:@"div#main p > a" error:nil];
        [[descendantCss should] equal:@"//div[@id = 'main']//p/a"];
        
        descendantCss = [converter xpathWithCSS:@"div#main p > a p > div" error:nil];
        [[descendantCss shouldNot] beNil];
        [[descendantCss should] equal:@"//div[@id = 'main']//p/a//p/div"];
    });
    
    it(@"should parse adjacent selector sequence", ^{
        NSString* adjacentCss = [converter xpathWithCSS:@"h1 ~ p" error:nil];
        [[adjacentCss should] equal:@"//h1/following-sibling::p"];
    });
    
    it(@"should parse selector group", ^{
        NSString* css = [converter xpathWithCSS:@"div, p" error:nil];
        [[css should] equal:@"//div | //p"];
    });

    it(@"should parse attribute", ^{
        NSString* css = [converter xpathWithCSS:@"div[foo]" error:nil];
        [[css should] equal:@"//div[@foo]"];

        NSString* cssWithValue = [converter xpathWithCSS:@"div[width=\"100\"]" error:nil];
        [[cssWithValue should] equal:@"//div[@width = \"100\"]"];
        
        NSString* cssWithIncludesValue = [converter xpathWithCSS:@"div[class~=\"100\"]" error:nil];
        [[cssWithIncludesValue should] equal:@"//div[contains(concat(\" \", @class, \" \"),concat(\" \", \"100\", \" \"))]"];

        NSString* cssWithDashValue = [converter xpathWithCSS:@"div[att|=\"val\"]" error:nil];
        [[cssWithDashValue should] equal:@"//div[@att = \"val\" or starts-with(@att, concat(\"val\", '-'))]"];
    });

    it(@"should parse pseudo class", ^{
        NSString* firstChild = [converter xpathWithCSS:@"div > p:first-child" error:nil];
        [[firstChild should] equal:@"//div/*[position() = 1 and self::p]"];
        
        NSString* lastChild = [converter xpathWithCSS:@"ol > li:last-child" error:nil];
        [[lastChild should] equal:@"//ol/*[position() = last() and self::li]"];
        
        NSString* firstOfType = [converter xpathWithCSS:@"dl dt:first-of-type" error:nil];
        [[firstOfType should] equal:@"//dl//dt[position() = 1]"];
        
        NSString* lastOfType = [converter xpathWithCSS:@"tr > td:last-of-type" error:nil];
        [[lastOfType should] equal:@"//tr/td[position() = last()]"];
        
        NSString* onlyChild = [converter xpathWithCSS:@"p:only-child" error:nil];
        [[onlyChild should] equal:@"//*[last() = 1 and self::p]"];
        
        NSString* onlyOfType = [converter xpathWithCSS:@"p:only-of-type" error:nil];
        [[onlyOfType should] equal:@"//p[last() = 1]"];

        NSString* empty = [converter xpathWithCSS:@"div:empty" error:nil];
        [[empty should] equal:@"//div[not(node())]"];
    });

    // disabled until we properly implement pseudo class with params
//    it(@"should parse function pseudo class nth-child()", ^{
//        NSError *error = nil;
//        NSString* nthChild = [converter xpathWithCSS:@"tr:nth-child(2n+1)" error:&error];
//        [[nthChild should] equal:@"//tr[(position() >= 1) and (((position()-1) mod 2) = 0)]"];
//        
//        nthChild = [converter xpathWithCSS:@"tr:nth-child(2n+0)" error:&error];
//        [[nthChild should] equal:@"//tr[(position() mod 2) = 0]"];
//        
//        nthChild = [converter xpathWithCSS:@"tr:nth-child(odd)" error:&error];
//        [[nthChild should] equal:@"//tr[(position() >= 1) and (((position()-1) mod 2) = 0)]"];
//        
//        nthChild = [converter xpathWithCSS:@"tr:nth-child(even)" error:&error];
//        [[nthChild should] equal:@"//tr[(position() mod 2) = 0]"];
//        
//        nthChild = [converter xpathWithCSS:@"tr:nth-child(odd)" error:&error];
//        [[nthChild should] equal:@"//tr[(position() >= 1) and (((position()-1) mod 2) = 0)]"];
//
//        nthChild = [converter xpathWithCSS:@"tr:nth-child(10n+9)" error:&error];
//        [[nthChild should] equal:@"//tr[(position() >= 9) and (((position()-9) mod 10) = 0)]"];
//
//        nthChild = [converter xpathWithCSS:@"tr:nth-child(10n-1)" error:&error];
//        [[nthChild should] equal:@"//tr[(position() >= 9) and (((position()-9) mod 10) = 0)]"];
//        
//        nthChild = [converter xpathWithCSS:@"tr:nth-child(n-2)" error:&error];
//        [[nthChild should] equal:@"//*[position() = n-2 and self::tr]"];
//    });
//
//    it(@"should parse function pseudo class nth-last-child()", ^{
//        NSError *error = nil;
//        NSString* nthChild = [converter xpathWithCSS:@"tr:nth-last-child(n-2)" error:&error];
//        [[nthChild should] equal:@"//tr[((last()-position()+1) >= 1) and ((((last()-position()+1)-1) mod 2) = 0)]"];
//    });
});

SPEC_END
