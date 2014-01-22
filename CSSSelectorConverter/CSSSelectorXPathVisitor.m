//
//  CSSSelectorXPathVisitor.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 1/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSSelectorXPathVisitor.h"
#import "CSSSelectorGroup.h"
#import "CSSUniversalSelector.h"
#import "CSSIDSelector.h"
#import "CSSClassSelector.h"
#import "CSSSelectorSequence.h"
#import "CSSPseudoClass.h"

@interface CSSSelectorXPathVisitor()
@property (nonatomic, strong) NSMutableString* output;
@end

@implementation CSSSelectorXPathVisitor

-(instancetype) init {
    self = [super init];
    self.output = [[NSMutableString alloc] init];
    return self;
}

#pragma mark - Public

-(void) visit:(CSSBaseSelector*)object {
    Class class = [object class];
    while (class && class != [NSObject class])
    {
        NSString *methodName = [NSString stringWithFormat:@"visit%@:", class];
        SEL selector = NSSelectorFromString(methodName);
        if ([self respondsToSelector:selector])
        {
            IMP imp = [self methodForSelector:selector];
            void (*func)(id, SEL, id) = (void *)imp;
            func(self, selector, object);
            return;
        }
        class = [class superclass];
    };
    [NSException raise:NSInvalidArgumentException format:@"Not a acceptable CSSBaseSelector subclasses"];
}


-(NSString*) xpathString
{
    return [_output copy];
}

#pragma mark - Visitors

-(void) visitCSSSelectorGroup:(CSSSelectorGroup*)node
{
    NSArray* sequence = [node.selectors copy];
    [sequence enumerateObjectsUsingBlock:^(CSSBaseSelector* selector, NSUInteger idx, BOOL *stop) {
        [self visit:selector];
        if (idx < sequence.count-1) {
            [self.output appendString:@" | "];
        }
    }];
}

-(void) visitCSSUniversalSelector:(CSSUniversalSelector*)node
{
    [self.output appendString:@"*"];
}

-(void) visitCSSTypeSelector:(CSSTypeSelector*)node
{
    [self.output appendString:[NSString stringWithFormat:@"%@", node.name]];
}

-(void) visitCSSIDSelector:(CSSIDSelector*)node
{
    [self.output appendString:[NSString stringWithFormat:@"@id = '%@'", node.name]];
}

-(void) visitCSSClassSelector:(CSSClassSelector*)node
{
    [self.output appendString:[NSString stringWithFormat:@"contains(concat(' ', normalize-space(@class), ' '), ' %@ ')", node.name]];
}

-(void) visitCSSSelectorSequence:(CSSSelectorSequence*)node
{
    if (!node.universalOrTypeSelector) {
        node.universalOrTypeSelector = [CSSUniversalSelector selector];
    }
    
    if (node.pseudoClass) {
        node.pseudoClass.parent = node.universalOrTypeSelector;
        [self visit:node.pseudoClass];
    } else {
        [self visit:node.universalOrTypeSelector];
    }
    
    if ([node.otherSelectors count] > 0) {
        [self.output appendString:@"["];
        [node.otherSelectors enumerateObjectsUsingBlock:^(CSSBaseSelector* selector, NSUInteger idx, BOOL *stop) {
            [self visit:selector];
            if (idx < node.otherSelectors.count - 1) {
                [self.output appendString:@" and "];
            }
        }];
        [self.output appendString:@"]"];
    }

}

@end
