//
//  CSSSelectorGrammar.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 1/20/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSSelectorGrammar.h"
#import "CSSTypeSelector.h"
#import "CSSUniversalSelector.h"

@implementation CSSSelectorGrammar

-(instancetype) init
{
    NSString* path = [[NSBundle bundleForClass:[self class]] pathForResource:@"CSSSelectorGrammar" ofType:@"txt"];
    return [self initWithPath:path];
}

-(instancetype) initWithPath:(NSString*)path
{
    NSError* error;
    NSString* grammar = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!grammar) {
        if (error) {
            [NSException raise:NSInvalidArgumentException format:@"missing grammar file %@, error: %@", path, error];
        } else {
            [NSException raise:NSInvalidArgumentException format:@"missing grammar file %@", path];
        }
    }
    self = [super initWithStart:@"CSSSelectorGroup" backusNaurForm:grammar error:&error];
    if (!self) {
        if (error) {
            NSLog(@"error compile language = %@", error);
        }
    }
    return self;
}

@end
