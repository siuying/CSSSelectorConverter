//
//  CSSSelectorGroup.h
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSBaseSelector.h"
#import "CSSSelectors.h"
#import "CPParser.h"

@interface CSSSelectorGroup : CSSBaseSelector <CPParseResult>

@property (nonatomic, strong) NSMutableArray* selectors;

-(void) addSelectors:(CSSSelectors*)selectors;

@end
