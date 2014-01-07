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
        self._tokenKindTab[@"+"] = @(CSSSELECTORPARSER_TOKEN_KIND_PLUS);
        self._tokenKindTab[@"["] = @(CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET);
        self._tokenKindTab[@"~"] = @(CSSSELECTORPARSER_TOKEN_KIND_TILDE);
        self._tokenKindTab[@"="] = @(CSSSELECTORPARSER_TOKEN_KIND_EQUALS);
        self._tokenKindTab[@"#"] = @(CSSSELECTORPARSER_TOKEN_KIND_POUND);
        self._tokenKindTab[@">"] = @(CSSSELECTORPARSER_TOKEN_KIND_GT);
        self._tokenKindTab[@"]"] = @(CSSSELECTORPARSER_TOKEN_KIND_CLOSE_BRACKET);
        self._tokenKindTab[@"."] = @(CSSSELECTORPARSER_TOKEN_KIND_DOT);

        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR] = @"*";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_PLUS] = @"+";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_TILDE] = @"~";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_EQUALS] = @"=";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_POUND] = @"#";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_GT] = @">";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self._tokenKindNameTab[CSSSELECTORPARSER_TOKEN_KIND_DOT] = @".";

    }
    return self;
}


- (void)_start {
    
    [self execute:(id)^{
    
  PKTokenizer *t = self.tokenizer;
  [t.symbolState add:@"."]; 

    }];
    [self selectorsGroup]; 
    [self matchEOF:YES]; 

}

- (void)selectorsGroup {
    
    [self selectors]; 
    while ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR, TOKEN_KIND_BUILTIN_WORD, 0]) {
        if ([self speculate:^{ [self selectors]; }]) {
            [self selectors]; 
        } else {
            break;
        }
    }

    [self fireAssemblerSelector:@selector(parser:didMatchSelectorsGroup:)];
}

- (void)selectors {
    
    [self selectorSequence]; 
    while ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_GT, CSSSELECTORPARSER_TOKEN_KIND_PLUS, CSSSELECTORPARSER_TOKEN_KIND_TILDE, 0]) {
        if ([self speculate:^{ [self combinator]; [self selectorSequence]; }]) {
            [self combinator]; 
            [self selectorSequence]; 
        } else {
            break;
        }
    }
    [self execute:(id)^{
    
  PUSH_SELECTORS();

    }];

    [self fireAssemblerSelector:@selector(parser:didMatchSelectors:)];
}

- (void)selectorSequence {
    
    if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR, TOKEN_KIND_BUILTIN_WORD, 0]) {
        if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_UNIVERSALSELECTOR, 0]) {
            [self universalSelector]; 
        } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
            [self typeSelector]; 
        } else {
            [self raise:@"No viable alternative found in rule 'selectorSequence'."];
        }
    }
    while ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_DOT, CSSSELECTORPARSER_TOKEN_KIND_POUND, 0]) {
        if ([self speculate:^{ if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_DOT, 0]) {[self classSelector]; } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_POUND, 0]) {[self idSelector]; } else {[self raise:@"No viable alternative found in rule 'selectorSequence'."];}}]) {
            if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_DOT, 0]) {
                [self classSelector]; 
            } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_POUND, 0]) {
                [self idSelector]; 
            } else {
                [self raise:@"No viable alternative found in rule 'selectorSequence'."];
            }
        } else {
            break;
        }
    }
    [self execute:(id)^{
    
  PUSH_SELECTOR_SEQUENCE();

    }];

    [self fireAssemblerSelector:@selector(parser:didMatchSelectorSequence:)];
}

- (void)combinator {
    
    if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_PLUS, 0]) {
        [self match:CSSSELECTORPARSER_TOKEN_KIND_PLUS discard:NO]; 
    } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_GT, 0]) {
        [self match:CSSSELECTORPARSER_TOKEN_KIND_GT discard:NO]; 
    } else if ([self predicts:CSSSELECTORPARSER_TOKEN_KIND_TILDE, 0]) {
        [self match:CSSSELECTORPARSER_TOKEN_KIND_TILDE discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'combinator'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchCombinator:)];
}

- (void)attributeSelector {
    
    [self match:CSSSELECTORPARSER_TOKEN_KIND_OPEN_BRACKET discard:YES]; 
    [self matchWord:NO]; 
    if ([self speculate:^{ [self match:CSSSELECTORPARSER_TOKEN_KIND_EQUALS discard:NO]; [self matchQuotedString:NO]; }]) {
        [self match:CSSSELECTORPARSER_TOKEN_KIND_EQUALS discard:NO]; 
        [self matchQuotedString:NO]; 
    }
    [self match:CSSSELECTORPARSER_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 

    [self fireAssemblerSelector:@selector(parser:didMatchAttributeSelector:)];
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

@end