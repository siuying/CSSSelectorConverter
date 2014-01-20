//
//  CSSSelectorParser+FixWhitespace.h
//  CSSSelectorConverter
//
//  Created by Francis Chong on 1/20/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSSelectorParser.h"

/**
 workaround for whitespace parsing (https://github.com/itod/parsekit/issues/29)
 */


enum {
    TOKEN_KIND_BUILTIN_S = TOKEN_KIND_BUILTIN_WHITESPACE
};

@interface CSSSelectorParser (FixWhitespace)

- (void) matchS:(BOOL)discard;
    
@end
