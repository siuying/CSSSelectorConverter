//
//  CSSSelectorAttribute.h
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSBaseSelector.h"
#import "CSSSelectorAttributeOperator.h"

#define PUSH_ATTRIBUTE() [CSSSelectorAttribute attributeWithAssembly:self.assembly];

@interface CSSSelectorAttribute : CSSBaseSelector

@property (nonatomic, strong) CSSSelectorAttributeOperator* type;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* value;

+(instancetype) attributeWithAssembly:(PKAssembly*)assembly;

@end
