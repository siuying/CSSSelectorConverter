//
//  CSSSelectorAttribute.h
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSBaseSelector.h"
#import "CSSSelectorAttributeOperator.h"
#import "CPParser.h"

@interface CSSSelectorAttribute : CSSBaseSelector <CPParseResult>

@property (nonatomic, strong) CSSSelectorAttributeOperator* attributeOperator;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* value;

@end
