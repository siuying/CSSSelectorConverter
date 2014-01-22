//
//  CSSSelectorXPathVisitor.h
//  CSSSelectorConverter
//
//  Created by Francis Chong on 1/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSSBaseSelector;

@interface CSSSelectorXPathVisitor : NSObject

-(void) visit:(CSSBaseSelector*)node;

-(NSString*) xpathString;

@end
