//
//  CSSSelectorSequence.h
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSSCombinator;
@class CSSBaseSelector;
@class CSSPseudoClass;
@class CSSTypeSelector;

@interface CSSSelectorSequence : CSSBaseSelector

@property (nonatomic, strong) CSSCombinator* combinator;

@property (nonatomic, strong) CSSPseudoClass* pseudoClass;

@property (nonatomic, strong) CSSTypeSelector* universalOrTypeSelector;

@property (nonatomic, strong) NSMutableArray* otherSelectors;

-(void) addSelector:(CSSBaseSelector*)selector;

@end
