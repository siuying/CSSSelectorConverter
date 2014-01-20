//
//  CSSSelectorParserDelegate.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 1/20/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSSelectorParserDelegate.h"
#import "CPKeywordToken.h"

@implementation CSSSelectorParserDelegate

- (id)parser:(CPParser *)parser didProduceSyntaxTree:(CPSyntaxTree *)syntaxTree {
    return syntaxTree;
}
    
@end
