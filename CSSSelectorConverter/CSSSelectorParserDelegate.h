//
//  CSSToXPathParserDelegate.h
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/ParseKit.h>

@class CSSSelectorParser;

@protocol CSSSelectorParserDelegate <NSObject>
@optional
-(void) parser:(CSSSelectorParser*)parser didMatchSelectorsGroup:(PKAssembly*)assembly;
-(void) parser:(CSSSelectorParser*)parser didMatchSelectors:(PKAssembly*)assembly;
-(void) parser:(CSSSelectorParser*)parser didMatchSelectorSequence:(PKAssembly*)assembly;
-(void) parser:(CSSSelectorParser*)parser didMatchCombinator:(PKAssembly*)assembly;
-(void) parser:(CSSSelectorParser*)parser didMatchAttributeSelector:(PKAssembly*)assembly;
-(void) parser:(CSSSelectorParser*)parser didMatchTypeSelector:(PKAssembly*)assembly;
-(void) parser:(CSSSelectorParser*)parser didMatchClassSelector:(PKAssembly*)assembly;
-(void) parser:(CSSSelectorParser*)parser didMatchIdSelector:(PKAssembly*)assembly;
-(void) parser:(CSSSelectorParser*)parser didMatchUniversalSelector:(PKAssembly*)assembly;
@end
