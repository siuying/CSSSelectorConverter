#import "CSSSelectorParser.h"
#import <ParseKit/ParseKit.h>

#define LT(i) [self LT:(i)]
#define LA(i) [self LA:(i)]
#define LS(i) [self LS:(i)]
#define LF(i) [self LF:(i)]

#define POP()       [self.assembly pop]
#define POP_STR()   [self _popString]
#define POP_TOK()   [self _popToken]
#define POP_BOOL()  [self _popBool]
#define POP_INT()   [self _popInteger]
#define POP_FLOAT() [self _popDouble]

#define PUSH(obj)     [self.assembly push:(id)(obj)]
#define PUSH_BOOL(yn) [self _pushBool:(BOOL)(yn)]
#define PUSH_INT(i)   [self _pushInteger:(NSInteger)(i)]
#define PUSH_FLOAT(f) [self _pushDouble:(double)(f)]

#define EQ(a, b) [(a) isEqual:(b)]
#define NE(a, b) (![(a) isEqual:(b)])
#define EQ_IGNORE_CASE(a, b) (NSOrderedSame == [(a) compare:(b)])

#define ABOVE(fence) [self.assembly objectsAbove:(fence)]

#define LOG(obj) do { NSLog(@"%@", (obj)); } while (0);
#define PRINT(str) do { printf("%s\n", (str)); } while (0);

@interface PKSParser ()
@property (nonatomic, retain) NSMutableDictionary *_tokenKindTab;
@property (nonatomic, retain) NSMutableArray *_tokenKindNameTab;

- (BOOL)_popBool;
- (NSInteger)_popInteger;
- (double)_popDouble;
- (PKToken *)_popToken;
- (NSString *)_popString;

- (void)_pushBool:(BOOL)yn;
- (void)_pushInteger:(NSInteger)i;
- (void)_pushDouble:(double)d;
@end

@interface CSSSelectorParser ()
@end

@implementation CSSSelectorParser

- (id)init {
    self = [super init];
    if (self) {
        self._tokenKindTab[@"*"] = @(CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR);
        self._tokenKindTab[@"|="] = @(CSSSELECTORPARSER_TOKEN_KIND_DASHMATCH);
        self._tokenKindTab[@"#"] = @(CSSSELECTORPARSER_TOKEN_KIND_POUND);
        self._tokenKindTab[@"+"] = @(CSSSELECTORPARSER_TOKEN_KIND_PLUS);
        self._tokenKindTab[@":"] = @(CSSSELECTORPARSER_TOKEN_KIND_COLON);
        self._tokenKindTab[@","] = @(CSSSELECTORPARSER_TOKEN_KIND_COMMA);
        self._tokenKindTab[@"["] = @(CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET);
        self._tokenKindTab[@"-"] = @(CSSSELECTORPARSER_TOKEN_KIND_MINUS);
        self._tokenKindTab[@"="] = @(CSSSELECTORPARSER_TOKEN_KIND_EQUAL);
        self._tokenKindTab[@"."] = @(CSSSELECTORPARSER_TOKEN_KIND_DOT);
        self._tokenKindTab[@">"] = @(CSSSELECTORPARSER_TOKEN_KIND_GT);
        self._tokenKindTab[@"]"] = @(CSSSELECTORPARSER_TOKEN_KIND_CLOSE_BRACKET);
        self._tokenKindTab[@"("] = @(CSSSELECTORPARSER_TOKEN_KIND_OPEN_PAREN);
        self._tokenKindTab[@"~="] = @(CSSSELECTORPARSER_TOKEN_KIND_INCLUDES);
        self._tokenKindTab[@")"] = @(CSSSELECTORPARSER_TOKEN_KIND_CLOSE_PAREN);

        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR] = @"*";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_DASHMATCH] = @"|=";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_POUND] = @"#";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_PLUS] = @"+";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_COLON] = @":";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_COMMA] = @",";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_MINUS] = @"-";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_EQUAL] = @"=";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_DOT] = @".";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_GT] = @">";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_OPEN_PAREN] = @"(";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_INCLUDES] = @"~=";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_CLOSE_PAREN] = @")";

    }
    return self;
}


- (void)_start {
    
    [self execute:(id)^{
    
  PKTokenizer *t = self.tokenizer;
  [t.symbolState add:@"~="];
  [t.symbolState add:@"|="];
  [t.symbolState add:@":"];

    }];
    [self selectorsGroup]; 
    [self matchEOF:YES]; 

}

- (void)selectorsGroup {
    
    [self selector]; 
    while ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_COMMA, 0]) {
        if ([self speculate:^{ [self match:CSSSELECTORPARSER_TOKEN_KIND_COMMA discard:YES]; [self selector]; }]) {
            [self match:CSSSELECTORPARSER_TOKEN_KIND_COMMA discard:YES]; 
            [self selector]; 
        } else {
            break;
        }
    }
    [self execute:(id)^{
    
  PUSH_SELECTORS_GROUP();

    }];

    [self fireAssemblerSelector:@selector(parser:didMatchSelectorsGroup:)];
}

- (void)selector {
    
    [self simpleSelectorSequence]; 
    while ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_GT, CSSSELECTORPARSER_TOKEN_KIND_PLUS, CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR, TOKEN_KIND_BUILTIN_WORD, 0]) {
        if ([self speculate:^{ if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_GT, CSSSELECTORPARSER_TOKEN_KIND_PLUS, 0]) {[self combinator]; [self simpleSelectorSequence]; } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR, TOKEN_KIND_BUILTIN_WORD, 0]) {[self simpleSelectorSequence]; } else {[self raise:@"No viable alternative found in rule 'selector'."];}}]) {
            if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_GT, CSSSELECTORPARSER_TOKEN_KIND_PLUS, 0]) {
                [self combinator]; 
                [self execute:(id)^{
                
  PUSH_COMBINATOR();

                }];
                [self simpleSelectorSequence]; 
            } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR, TOKEN_KIND_BUILTIN_WORD, 0]) {
                [self simpleSelectorSequence]; 
            } else {
                [self raise:@"No viable alternative found in rule 'selector'."];
            }
        } else {
            break;
        }
    }
    [self execute:(id)^{
    
  PUSH_SELECTORS();

    }];

    [self fireAssemblerSelector:@selector(parser:didMatchSelector:)];
}

- (void)simpleSelectorSequence {
    
    if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR, TOKEN_KIND_BUILTIN_WORD, 0]) {
        if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR, 0]) {
            [self universalSelector]; 
        } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
            [self typeSelector]; 
        } else {
            [self raise:@"No viable alternative found in rule 'simpleSelectorSequence'."];
        }
    }
    while ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_COLON, CSSSELECTORPARSER_TOKEN_KIND_DOT, CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET, CSSSELECTORPARSER_TOKEN_KIND_POUND, TOKEN_KIND_BUILTIN_WORD, 0]) {
        if ([self speculate:^{ if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_DOT, 0]) {[self classSelector]; } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_POUND, 0]) {[self idSelector]; } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET, 0]) {[self attributeSelector]; } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_COLON, TOKEN_KIND_BUILTIN_WORD, 0]) {[self pseudoSelector]; } else {[self raise:@"No viable alternative found in rule 'simpleSelectorSequence'."];}}]) {
            if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_DOT, 0]) {
                [self classSelector]; 
            } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_POUND, 0]) {
                [self idSelector]; 
            } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET, 0]) {
                [self attributeSelector]; 
            } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_COLON, TOKEN_KIND_BUILTIN_WORD, 0]) {
                [self pseudoSelector]; 
            } else {
                [self raise:@"No viable alternative found in rule 'simpleSelectorSequence'."];
            }
        } else {
            break;
        }
    }
    [self execute:(id)^{
    
  PUSH_SELECTOR_SEQUENCE();

    }];

    [self fireAssemblerSelector:@selector(parser:didMatchSimpleSelectorSequence:)];
}

- (void)attributeSelector {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET discard:YES]; 
    [self matchWord:NO]; 
    if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_DASHMATCH, CSSSELECTORPARSER_TOKEN_KIND_EQUAL, CSSSELECTORPARSER_TOKEN_KIND_INCLUDES, 0]) {
        if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_EQUAL, 0]) {
            [self equal]; 
        } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_INCLUDES, 0]) {
            [self includes]; 
        } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_DASHMATCH, 0]) {
            [self dashmatch]; 
        } else {
            [self raise:@"No viable alternative found in rule 'attributeSelector'."];
        }
        [self matchQuotedString:NO]; 
    }
    [self match:CSSSELECTORPARSER_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 
    [self execute:(id)^{
    
  PUSH_ATTRIBUTE();

    }];

    [self fireAssemblerSelector:@selector(parser:didMatchAttributeSelector:)];
}

- (void)pseudoSelector {
    
    if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_COLON, 0]) {
        [self match:CSSSELECTORPARSER_TOKEN_KIND_COLON discard:YES]; 
        do {
            if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
                [self matchWord:NO]; 
            } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_MINUS, 0]) {
                [self match:CSSSELECTORPARSER_TOKEN_KIND_MINUS discard:NO]; 
            } else {
                [self raise:@"No viable alternative found in rule 'pseudoSelector'."];
            }
        } while ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_MINUS, TOKEN_KIND_BUILTIN_WORD, 0]);
        [self execute:(id)^{
        
  PUSH_PSEUDO_CLASS();

        }];
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self matchWord:NO]; 
        [self match:CSSSELECTORPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
        [self expression]; 
        [self match:CSSSELECTORPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
        [self execute:(id)^{
        
  PUSH_PSEUDO_CLASS();

        }];
    } else {
        [self raise:@"No viable alternative found in rule 'pseudoSelector'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchPseudoSelector:)];
}

- (void)expression {
    
    do {
        if ([self speculate:^{ [self match:CSSSELECTORPARSER_TOKEN_KIND_PLUS discard:NO]; }]) {
            [self match:CSSSELECTORPARSER_TOKEN_KIND_PLUS discard:NO]; 
        } else if ([self speculate:^{ [self match:CSSSELECTORPARSER_TOKEN_KIND_MINUS discard:NO]; }]) {
            [self match:CSSSELECTORPARSER_TOKEN_KIND_MINUS discard:NO]; 
        } else if ([self speculate:^{ [self dimension]; }]) {
            [self dimension]; 
        } else if ([self speculate:^{ [self matchNumber:NO]; }]) {
            [self matchNumber:NO]; 
        } else if ([self speculate:^{ [self matchWord:NO]; }]) {
            [self matchWord:NO]; 
        } else {
            [self raise:@"No viable alternative found in rule 'expression'."];
        }
    } while ([self speculate:^{ if ([self speculate:^{ [self match:CSSSELECTORPARSER_TOKEN_KIND_PLUS discard:NO]; }]) {[self match:CSSSELECTORPARSER_TOKEN_KIND_PLUS discard:NO]; } else if ([self speculate:^{ [self match:CSSSELECTORPARSER_TOKEN_KIND_MINUS discard:NO]; }]) {[self match:CSSSELECTORPARSER_TOKEN_KIND_MINUS discard:NO]; } else if ([self speculate:^{ [self dimension]; }]) {[self dimension]; } else if ([self speculate:^{ [self matchNumber:NO]; }]) {[self matchNumber:NO]; } else if ([self speculate:^{ [self matchWord:NO]; }]) {[self matchWord:NO]; } else {[self raise:@"No viable alternative found in rule 'expression'."];}}]);

    [self fireAssemblerSelector:@selector(parser:didMatchExpression:)];
}

- (void)dimension {
    
    [self matchNumber:NO]; 
    [self matchWord:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchDimension:)];
}

- (void)classSelector {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_DOT discard:YES]; 
    [self matchWord:NO]; 
    [self execute:(id)^{
    
  PUSH_CSS_CLASS(POP_STR());

    }];

    [self fireAssemblerSelector:@selector(parser:didMatchClassSelector:)];
}

- (void)idSelector {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_POUND discard:YES]; 
    [self matchWord:NO]; 
    [self execute:(id)^{
    
  PUSH_CSS_ID(POP_STR());

    }];

    [self fireAssemblerSelector:@selector(parser:didMatchIdSelector:)];
}

- (void)typeSelector {
    
    [self matchWord:NO]; 
    [self execute:(id)^{
    
  PUSH_CSS_TYPE(POP_STR());

    }];

    [self fireAssemblerSelector:@selector(parser:didMatchTypeSelector:)];
}

- (void)universalSelector {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR discard:YES]; 
    [self execute:(id)^{
    
  PUSH_CSS_UNIVERSAL();

    }];

    [self fireAssemblerSelector:@selector(parser:didMatchUniversalSelector:)];
}

- (void)combinator {
    
    if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_GT, 0]) {
        [self match:CSSSELECTORPARSER_TOKEN_KIND_GT discard:NO]; 
    } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_PLUS, 0]) {
        [self match:CSSSELECTORPARSER_TOKEN_KIND_PLUS discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'combinator'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchCombinator:)];
}

- (void)equal {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_EQUAL discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchEqual:)];
}

- (void)includes {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_INCLUDES discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchIncludes:)];
}

- (void)dashmatch {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_DASHMATCH discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchDashmatch:)];
}

@end