//
//  CSSToXPathConverter.h
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSSelectorParser.h"
#import "CSSSelectorParserDelegate.h"

@interface CSSToXPathConverter : NSObject <CSSSelectorParserDelegate>

@property CSSSelectorParser* parser;

-(id) init;

-(id) initWithParser:(CSSSelectorParser*)parser;

-(NSString*)xpathWithCSS:(NSString*)css error:(NSError**)error;

@end
