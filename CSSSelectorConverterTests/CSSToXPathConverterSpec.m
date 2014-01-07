//
//  NewKiwiSpec.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import "Kiwi.h"
#import "CSSToXPathConverter.h"

SPEC_BEGIN(CSSToXPathConverterSpec)
__block CSSToXPathConverter *converter;

describe(@"CSSToXPathParser", ^{
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
    
    it(@"should parse class selector", ^{
        NSError *error = nil;
        NSString* css = [converter xpathWithCSS:@".header" error:&error];
        [[css should] equal:@"//*[contains(concat(' ', normalize-space(@class), ' '), ' header ')]"];
    });
    
    it(@"should parse type with class/id selector", ^{
        NSError *error = nil;
        NSString* css = [converter xpathWithCSS:@"p.header" error:&error];
        [[css should] equal:@"//p[contains(concat(' ', normalize-space(@class), ' '), ' header ')]"];
        
        css = [converter xpathWithCSS:@"p#header" error:&error];
        [[css should] equal:@"//p[@id = 'header']"];
        
        css = [converter xpathWithCSS:@"p#header.red" error:&error];
        [[css should] equal:@"//p[@id = 'header' and contains(concat(' ', normalize-space(@class), ' '), ' red ')]"];
    });
    
    it(@"should parse selector sequence", ^{
        NSError *error = nil;
        NSString* css = [converter xpathWithCSS:@"div p" error:&error];
        [[css should] equal:@"//div//p"];
        
        css = [converter xpathWithCSS:@"div *" error:&error];
        [[css should] equal:@"//div//*"];
        
        css = [converter xpathWithCSS:@"div#main p" error:&error];
        [[css should] equal:@"//div[@id = 'main']//p"];

        css = [converter xpathWithCSS:@"div#main p > a" error:&error];
        [[css should] equal:@"//div[@id = 'main']//p/a"];
    });

});

SPEC_END
