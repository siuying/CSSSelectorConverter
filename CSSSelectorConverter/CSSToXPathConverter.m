//
//  CSSToXPathConverter.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSToXPathConverter.h"
#import <ParseKit/ParseKit.h>
#import "CSSBaseSelector.h"

@implementation CSSToXPathConverter

-(id) initWithParser:(CSSSelectorParser*)parser {
    self = [super init];
    self.parser = parser;
    return self;
}

-(id) init {
    return [self initWithParser:[[CSSSelectorParser alloc] init]];
}

-(NSString*)xpathWithCSS:(NSString*)css error:(NSError**)error{
    PKAssembly* assembly = [self.parser parseString:css assembler:self error:error];
    
    NSMutableString* output = [[NSMutableString alloc] init];
    [assembly.stack enumerateObjectsUsingBlock:^(CSSBaseSelector* selector, NSUInteger idx, BOOL *stop) {
        [output appendString:selector.toXPath];
    }];
    return [output copy];
}

#pragma mark - CSSSelectorParserDelegate

-(void) parser:(CSSSelectorParser*)parser didMatchSelectorsGroup:(PKAssembly*)assembly {
    NSLog(@"SELECTORS GROUP = %@", assembly);
}

-(void) parser:(CSSSelectorParser*)parser didMatchSelector:(PKAssembly*)assembly {
    NSLog(@"SELECTORS = %@", assembly);
}

-(void) parser:(CSSSelectorParser*)parser didMatchSimpleSelectorSequence:(PKAssembly*)assembly {
    NSLog(@"SEQ = %@", assembly);
}

-(void) parser:(CSSSelectorParser*)parser didMatchCombinator:(PKAssembly*)assembly {
    NSLog(@"COMB = %@", assembly);
}

-(void) parser:(CSSSelectorParser*)parser didMatchAttributeSelector:(PKAssembly*)assembly {
     NSLog(@"ATTR = %@", assembly);
}

-(void) parser:(CSSSelectorParser*)parser didMatchTypeSelector:(PKAssembly*)assembly {
    NSLog(@"TYPE = %@", assembly);
}

-(void) parser:(CSSSelectorParser*)parser didMatchClassSelector:(PKAssembly*)assembly {
    NSLog(@"CLASS = %@", assembly);
}

-(void) parser:(CSSSelectorParser*)parser didMatchIdSelector:(PKAssembly*)assembly {
    NSLog(@"ID = %@", assembly);
}

-(void) parser:(CSSSelectorParser*)parser didMatchUniversalSelector:(PKAssembly*)assembly {
    NSLog(@"UNIV = %@", assembly);    
}

@end
