//
//  CSSPseudoClass.h
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSNamedSelector.h"

#define PUSH_PSEUDO_CLASS() [CSSPseudoClass pushPseudoClass:self.assembly];

@interface CSSPseudoClass : CSSNamedSelector

@property (nonatomic, weak) CSSNamedSelector* parent;

+(void) pushPseudoClass:(PKAssembly*)assembly;

+(NSArray*) supportedPseudoClass;

@end
