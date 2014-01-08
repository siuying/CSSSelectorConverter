//
//  CSSSelectorSequence.h
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/ParseKit.h>

#define PUSH_SELECTOR_SEQUENCE() [CSSSelectorSequence pushSelectorSequence:self.assembly];

@class CSSCombinator;
@class CSSBaseSelector;

@interface CSSSelectorSequence : CSSBaseSelector

@property (nonatomic, strong) CSSCombinator* combinator;

@property (nonatomic, strong) CSSBaseSelector* universalOrTypeSelector;

@property (nonatomic, strong) NSMutableArray* otherSelectors;

-(void) addSelector:(CSSBaseSelector*)selector;

+(void) pushSelectorSequence:(PKAssembly*)assembly;

@end
