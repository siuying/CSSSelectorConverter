//
//  CSSSelectors.h
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSBaseSelector.h"
#import "CSSSelectorSequence.h"
#import <ParseKit/ParseKit.h>

#define PUSH_SELECTORS() [CSSSelectors selectorWithAssembly:self.assembly];

@interface CSSSelectors : CSSBaseSelector

@property (nonatomic, strong) NSMutableArray* sequences;

-(void) addSequence:(CSSSelectorSequence*)sequence;

+(instancetype) selectorWithAssembly:(PKSTokenAssembly*)assembly;

@end
