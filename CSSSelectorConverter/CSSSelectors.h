//
//  CSSSelectors.h
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSBaseSelector.h"
#import "CPParser.h"

@interface CSSSelectors : CSSBaseSelector <CPParseResult>

@property (nonatomic, strong) NSMutableArray* selectors;

/**
 Add a CSSSelectorSequence or CSSCombinator to the selectors.

 @raise NSInvalidArgumentException if selector is not CSSSelectorSequence or CSSCombinator
 */
-(void) addSelector:(CSSBaseSelector*)selector;

@end
