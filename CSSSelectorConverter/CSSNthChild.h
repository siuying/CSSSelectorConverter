//
//  CSSNthChild.h
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSPseudoClass.h"

#define PUSH_NTH_CHILD() [CSSNthChild pushPseudoClass:self.assembly];

/**
 nth-child pseudo class.
 
 it support: nth-child(an+b), nth-child(a), nth-child(odd), nth-child(even)
 */
@interface CSSNthChild : CSSPseudoClass

// nth-child: an + b
@property (nonatomic, assign) NSInteger constantA;

// nth-child: an + b
@property (nonatomic, assign) NSInteger constantB;

@end
