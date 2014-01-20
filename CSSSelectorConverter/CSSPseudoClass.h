//
//  CSSPseudoClass.h
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSNamedSelector.h"

@interface CSSPseudoClass : CSSNamedSelector

@property (nonatomic, weak) CSSNamedSelector* parent;

+(NSArray*) supportedPseudoClass;

@end
