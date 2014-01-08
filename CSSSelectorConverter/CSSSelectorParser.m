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
        self._tokenKindTab[@"~="] = @(CSSSELECTORPARSER_TOKEN_KIND_INCLUDES);
        self._tokenKindTab[@","] = @(CSSSELECTORPARSER_TOKEN_KIND_COMMA);
        self._tokenKindTab[@":"] = @(CSSSELECTORPARSER_TOKEN_KIND_COLON);
        self._tokenKindTab[@"~"] = @(CSSSELECTORPARSER_TOKEN_KIND_TILDE);
        self._tokenKindTab[@"-"] = @(CSSSELECTORPARSER_TOKEN_KIND_MINUS);
        self._tokenKindTab[@"nth"] = @(CSSSELECTORPARSER_TOKEN_KIND_NTHCONSTANT);
        self._tokenKindTab[@"."] = @(CSSSELECTORPARSER_TOKEN_KIND_DOT);
        self._tokenKindTab[@"odd"] = @(CSSSELECTORPARSER_TOKEN_KIND_ODD);
        self._tokenKindTab[@"last"] = @(CSSSELECTORPARSER_TOKEN_KIND_LAST);
        self._tokenKindTab[@"first"] = @(CSSSELECTORPARSER_TOKEN_KIND_FIRST);
        self._tokenKindTab[@"only"] = @(CSSSELECTORPARSER_TOKEN_KIND_ONLY);
        self._tokenKindTab[@"empty"] = @(CSSSELECTORPARSER_TOKEN_KIND_EMPTY);
        self._tokenKindTab[@"#"] = @(CSSSELECTORPARSER_TOKEN_KIND_POUND);
        self._tokenKindTab[@"even"] = @(CSSSELECTORPARSER_TOKEN_KIND_EVEN);
        self._tokenKindTab[@">"] = @(CSSSELECTORPARSER_TOKEN_KIND_GT);
        self._tokenKindTab[@"="] = @(CSSSELECTORPARSER_TOKEN_KIND_EQUAL);
        self._tokenKindTab[@"["] = @(CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET);
        self._tokenKindTab[@"type"] = @(CSSSELECTORPARSER_TOKEN_KIND_TYPE);
        self._tokenKindTab[@"|="] = @(CSSSELECTORPARSER_TOKEN_KIND_DASHMATCH);
        self._tokenKindTab[@"]"] = @(CSSSELECTORPARSER_TOKEN_KIND_CLOSE_BRACKET);
        self._tokenKindTab[@"("] = @(CSSSELECTORPARSER_TOKEN_KIND_OPEN_PAREN);
        self._tokenKindTab[@")"] = @(CSSSELECTORPARSER_TOKEN_KIND_CLOSE_PAREN);
        self._tokenKindTab[@"of"] = @(CSSSELECTORPARSER_TOKEN_KIND_OF);
        self._tokenKindTab[@"*"] = @(CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR);
        self._tokenKindTab[@"n"] = @(CSSSELECTORPARSER_TOKEN_KIND_NTHCHILDCONSTANT);
        self._tokenKindTab[@"+"] = @(CSSSELECTORPARSER_TOKEN_KIND_PLUS);
        self._tokenKindTab[@"child"] = @(CSSSELECTORPARSER_TOKEN_KIND_CHILD);

        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_INCLUDES] = @"~=";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_COMMA] = @",";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_COLON] = @":";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_TILDE] = @"~";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_MINUS] = @"-";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_NTHCONSTANT] = @"nth";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_DOT] = @".";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_ODD] = @"odd";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_LAST] = @"last";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_FIRST] = @"first";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_ONLY] = @"only";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_EMPTY] = @"empty";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_POUND] = @"#";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_EVEN] = @"even";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_GT] = @">";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_EQUAL] = @"=";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_TYPE] = @"type";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_DASHMATCH] = @"|=";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_OPEN_PAREN] = @"(";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_CLOSE_PAREN] = @")";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_OF] = @"of";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR] = @"*";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_NTHCHILDCONSTANT] = @"n";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_PLUS] = @"+";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_CHILD] = @"child";

    }
    return self;
}


- (void)_start {
    
    [self execute:(id)^{
    
  PKTokenizer *t = self.tokenizer;
  [t.symbolState add:@"~="];
  [t.symbolState add:@"|="];
  [t.symbolState add:@":"];
  [t.symbolState add:@"-"];
  [t.wordState setWordChars:NO from:'-' to:'-'];
  [t.numberState setAllowsScientificNotation:NO];
  [t.numberState setAllowsTrailingDecimalSeparator:NO];


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

}

- (void)selector {
    
    [self simpleSelectorSequence]; 
    while ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_GT, CSSSELECTORPARSER_TOKEN_KIND_PLUS, CSSSELECTORPARSER_TOKEN_KIND_TILDE, CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR, TOKEN_KIND_BUILTIN_WORD, 0]) {
        if ([self speculate:^{ if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_GT, CSSSELECTORPARSER_TOKEN_KIND_PLUS, CSSSELECTORPARSER_TOKEN_KIND_TILDE, 0]) {[self combinator]; [self simpleSelectorSequence]; } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR, TOKEN_KIND_BUILTIN_WORD, 0]) {[self simpleSelectorSequence]; } else {[self raise:@"No viable alternative found in rule 'selector'."];}}]) {
            if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_GT, CSSSELECTORPARSER_TOKEN_KIND_PLUS, CSSSELECTORPARSER_TOKEN_KIND_TILDE, 0]) {
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
    while ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_COLON, CSSSELECTORPARSER_TOKEN_KIND_DOT, CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET, CSSSELECTORPARSER_TOKEN_KIND_POUND, 0]) {
        if ([self speculate:^{ if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_DOT, 0]) {[self classSelector]; } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_POUND, 0]) {[self idSelector]; } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET, 0]) {[self attributeSelector]; } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_COLON, 0]) {[self pseudoSelector]; } else {[self raise:@"No viable alternative found in rule 'simpleSelectorSequence'."];}}]) {
            if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_DOT, 0]) {
                [self classSelector]; 
            } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_POUND, 0]) {
                [self idSelector]; 
            } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET, 0]) {
                [self attributeSelector]; 
            } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_COLON, 0]) {
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

}

- (void)pseudoSelector {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_COLON discard:YES]; 
    if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_NTHCONSTANT, 0]) {
        [self paramPseudoSelector]; 
    } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_EMPTY, CSSSELECTORPARSER_TOKEN_KIND_FIRST, CSSSELECTORPARSER_TOKEN_KIND_LAST, CSSSELECTORPARSER_TOKEN_KIND_ONLY, 0]) {
        [self pseudoSelectorName]; 
        [self execute:(id)^{
        
  PUSH_PSEUDO_CLASS();

        }];
    } else {
        [self raise:@"No viable alternative found in rule 'pseudoSelector'."];
    }

}

- (void)paramPseudoSelector {
    
    [self paramPseudoSelectorName]; 
    [self match:CSSSELECTORPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self paramPseudoSelectorParam]; 
    [self match:CSSSELECTORPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:(id)^{
    
  PUSH_NTH_CHILD();

    }];

}

- (void)paramPseudoSelectorParam {
    
    if ([self speculate:^{ if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {[self matchNumber:NO]; }[self nthChildConstant]; if ([self speculate:^{ if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_MINUS, CSSSELECTORPARSER_TOKEN_KIND_PLUS, 0]) {[self sign]; }[self matchNumber:NO]; }]) {if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_MINUS, CSSSELECTORPARSER_TOKEN_KIND_PLUS, 0]) {[self sign]; }[self matchNumber:NO]; }}]) {
        if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
            [self matchNumber:NO]; 
        }
        [self nthChildConstant]; 
        if ([self speculate:^{ if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_MINUS, CSSSELECTORPARSER_TOKEN_KIND_PLUS, 0]) {[self sign]; }[self matchNumber:NO]; }]) {
            if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_MINUS, CSSSELECTORPARSER_TOKEN_KIND_PLUS, 0]) {
                [self sign]; 
            }
            [self matchNumber:NO]; 
        }
    } else if ([self speculate:^{ [self matchNumber:NO]; }]) {
        [self matchNumber:NO]; 
    } else if ([self speculate:^{ [self even]; }]) {
        [self even]; 
    } else if ([self speculate:^{ [self odd]; }]) {
        [self odd]; 
    } else {
        [self raise:@"No viable alternative found in rule 'paramPseudoSelectorParam'."];
    }

}

- (void)dimension {
    
    [self matchNumber:NO]; 
    [self matchWord:NO]; 

}

- (void)classSelector {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_DOT discard:YES]; 
    [self matchWord:NO]; 
    [self execute:(id)^{
    
  PUSH_CSS_CLASS(POP_STR());

    }];

}

- (void)idSelector {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_POUND discard:YES]; 
    [self matchWord:NO]; 
    [self execute:(id)^{
    
  PUSH_CSS_ID(POP_STR());

    }];

}

- (void)typeSelector {
    
    [self matchWord:NO]; 
    [self execute:(id)^{
    
  PUSH_CSS_TYPE(POP_STR());

    }];

}

- (void)universalSelector {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR discard:YES]; 
    [self execute:(id)^{
    
  PUSH_CSS_UNIVERSAL();

    }];

}

- (void)paramPseudoSelectorName {
    
    if ([self speculate:^{ [self nthConstant]; [self minus]; [self last]; [self minus]; [self child]; }]) {
        [self nthConstant]; 
        [self minus]; 
        [self last]; 
        [self minus]; 
        [self child]; 
    } else if ([self speculate:^{ [self nthConstant]; [self minus]; [self last]; [self minus]; [self of]; [self minus]; [self type]; }]) {
        [self nthConstant]; 
        [self minus]; 
        [self last]; 
        [self minus]; 
        [self of]; 
        [self minus]; 
        [self type]; 
    } else if ([self speculate:^{ [self nthConstant]; [self minus]; [self of]; [self minus]; [self type]; }]) {
        [self nthConstant]; 
        [self minus]; 
        [self of]; 
        [self minus]; 
        [self type]; 
    } else if ([self speculate:^{ [self nthConstant]; [self minus]; [self child]; }]) {
        [self nthConstant]; 
        [self minus]; 
        [self child]; 
    } else {
        [self raise:@"No viable alternative found in rule 'paramPseudoSelectorName'."];
    }

}

- (void)pseudoSelectorName {
    
    if ([self speculate:^{ [self first]; [self minus]; [self child]; }]) {
        [self first]; 
        [self minus]; 
        [self child]; 
    } else if ([self speculate:^{ [self last]; [self minus]; [self child]; }]) {
        [self last]; 
        [self minus]; 
        [self child]; 
    } else if ([self speculate:^{ [self first]; [self minus]; [self of]; [self minus]; [self type]; }]) {
        [self first]; 
        [self minus]; 
        [self of]; 
        [self minus]; 
        [self type]; 
    } else if ([self speculate:^{ [self last]; [self minus]; [self of]; [self minus]; [self type]; }]) {
        [self last]; 
        [self minus]; 
        [self of]; 
        [self minus]; 
        [self type]; 
    } else if ([self speculate:^{ [self only]; [self minus]; [self child]; }]) {
        [self only]; 
        [self minus]; 
        [self child]; 
    } else if ([self speculate:^{ [self only]; [self minus]; [self of]; [self minus]; [self type]; }]) {
        [self only]; 
        [self minus]; 
        [self of]; 
        [self minus]; 
        [self type]; 
    } else if ([self speculate:^{ [self empty]; }]) {
        [self empty]; 
    } else {
        [self raise:@"No viable alternative found in rule 'pseudoSelectorName'."];
    }

}

- (void)nthChildConstant {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_NTHCHILDCONSTANT discard:NO]; 

}

- (void)first {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_FIRST discard:NO]; 

}

- (void)last {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_LAST discard:NO]; 

}

- (void)child {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_CHILD discard:NO]; 

}

- (void)type {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_TYPE discard:NO]; 

}

- (void)of {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_OF discard:NO]; 

}

- (void)only {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_ONLY discard:NO]; 

}

- (void)empty {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_EMPTY discard:NO]; 

}

- (void)nthConstant {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_NTHCONSTANT discard:NO]; 

}

- (void)odd {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_ODD discard:NO]; 

}

- (void)even {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_EVEN discard:NO]; 

}

- (void)combinator {
    
    if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_GT, 0]) {
        [self match:CSSSELECTORPARSER_TOKEN_KIND_GT discard:NO]; 
    } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_TILDE, 0]) {
        [self match:CSSSELECTORPARSER_TOKEN_KIND_TILDE discard:NO]; 
    } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_PLUS, 0]) {
        [self plus]; 
    } else {
        [self raise:@"No viable alternative found in rule 'combinator'."];
    }

}

- (void)sign {
    
    if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_MINUS, 0]) {
        [self minus]; 
    } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_PLUS, 0]) {
        [self plus]; 
    } else {
        [self raise:@"No viable alternative found in rule 'sign'."];
    }

}

- (void)plus {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_PLUS discard:NO]; 

}

- (void)minus {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_MINUS discard:NO]; 

}

- (void)equal {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_EQUAL discard:NO]; 

}

- (void)includes {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_INCLUDES discard:NO]; 

}

- (void)dashmatch {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_DASHMATCH discard:NO]; 

}

@end