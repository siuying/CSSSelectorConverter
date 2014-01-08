//
//  CSSSelectorAttributeType.h
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSNamedSelector.h"

typedef NS_ENUM(NSInteger, CSSSelectorAttributeOperatorType) {
    CSSSelectorAttributeOperatorTypeNone = 0,
    CSSSelectorAttributeOperatorTypeEqual,
    CSSSelectorAttributeOperatorTypeIncludes
};

@interface CSSSelectorAttributeOperator : CSSNamedSelector

@property (nonatomic, assign) CSSSelectorAttributeOperatorType attributeOperator;

@end
