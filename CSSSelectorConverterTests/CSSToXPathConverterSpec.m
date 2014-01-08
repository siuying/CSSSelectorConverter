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

SPEC_BEGIN(CSSToXPathConverterSpec)
__block CSSToXPathConverter *converter;

describe(@"CSSToXPathParser", ^{
    beforeAll(^{
        DDTTYLogger* ttyLogger = [DDTTYLogger sharedInstance];
        [DDLog addLogger:ttyLogger];
    });

    afterAll(^{
        [DDLog flushLog];
    });

    beforeEach(^{
        converter = [[CSSToXPathConverter alloc] init];
    });
    
    it(@"should parse universal selector", ^{
        NSError *error = nil;
        NSString* css = [converter xpathWithCSS:@"*" error:&error];
        [[css should] equal:@"//*"];
    });

    it(@"should parse type selector", ^{
        NSError *error = nil;
        NSString* css = [converter xpathWithCSS:@"p" error:&error];
        [[css should] equal:@"//p"];
    });

    it(@"should parse id selector", ^{
        NSError *error = nil;
        NSString* css = [converter xpathWithCSS:@"#header" error:&error];
        [[css should] equal:@"//*[@id = 'header']"];
    });

    it(@"should parse class selector", ^{
        NSError *error = nil;
        NSString* css = [converter xpathWithCSS:@".header" error:&error];
        [[css should] equal:@"//*[contains(concat(' ', normalize-space(@class), ' '), ' header ')]"];
    });
    
    it(@"should parse type with mixed class and id selector", ^{
        NSError *error = nil;
        NSString* css = [converter xpathWithCSS:@"p#header.red" error:&error];
        [[css should] equal:@"//p[@id = 'header' and contains(concat(' ', normalize-space(@class), ' '), ' red ')]"];
    });

    it(@"should parse simple selector sequence", ^{
        NSError *error = nil;
        NSString* css = [converter xpathWithCSS:@"div p" error:&error];
        [[css should] equal:@"//div//p"];
        
        css = [converter xpathWithCSS:@"div *" error:&error];
        [[css should] equal:@"//div//*"];
        
        css = [converter xpathWithCSS:@"div#main p" error:&error];
        [[css should] equal:@"//div[@id = 'main']//p"];
    });
    
    it(@"should parse descendant selector sequence", ^{
        NSError *error = nil;
        
        NSString* descendantCss = [converter xpathWithCSS:@"div#main p > a" error:&error];
        [[descendantCss should] equal:@"//div[@id = 'main']//p/a"];
        
        descendantCss = [converter xpathWithCSS:@"div#main p > a p > div" error:&error];
        [[descendantCss should] equal:@"//div[@id = 'main']//p/a//p/div"];
    });
    
    it(@"should parse selector group", ^{
        NSError *error = nil;
        NSString* css = [converter xpathWithCSS:@"div, p" error:&error];
        [[css should] equal:@"//div | //p"];
    });

    it(@"should parse attribute", ^{
        NSError *error = nil;
        NSString* css = [converter xpathWithCSS:@"div[foo]" error:&error];
        [[css should] equal:@"//div[@foo]"];

        NSString* cssWithValue = [converter xpathWithCSS:@"div[width=\"100\"]" error:&error];
        [[cssWithValue should] equal:@"//div[@width = \"100\"]"];
        
        NSString* cssWithIncludesValue = [converter xpathWithCSS:@"div[class~=\"100\"]" error:&error];
        [[cssWithIncludesValue should] equal:@"//div[contains(concat(\" \", @class, \" \"),concat(\" \", \"100\", \" \"))]"];

        NSString* cssWithDashValue = [converter xpathWithCSS:@"div[att|=\"val\"]" error:&error];
        [[cssWithDashValue should] equal:@"//div[@att = \"val\" or starts-with(@att, concat(\"val\", '-'))]"];
    });

});

SPEC_END
