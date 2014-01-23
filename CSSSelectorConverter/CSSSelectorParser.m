#import "CSSSelectorParser.h"
#import "CSSSelectorGrammar.h"
#import "CSSSelectorTokeniser.h"

#import "DDLog.h"

#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF cssSelectorLogLevel
static const int cssSelectorLogLevel = LOG_LEVEL_ERROR;

NSString* const CSSSelectorParserException = @"CSSSelectorParserException";
NSString* const CSSSelectorParserErrorDomain = @"CSSSelectorParserErrorDomain";
NSString* const CSSSelectorParserErrorInputStreamKey = @"input stream";
NSString* const CSSSelectorParserErrorAcceptableTokenKey = @"acceptable token";

enum {
    CSSSelectorParserRuleQuotedString = 1
};

@interface CSSSelectorParser ()
@property (nonatomic, strong) CSSSelectorTokeniser *tokeniser;
@property (nonatomic, strong) CPParser* parser;
@end

#define CSSSelectorParserParserKey     @"p"

@implementation CSSSelectorParser

- (id)init {
    self = [super init];
    self.tokeniser = [[CSSSelectorTokeniser alloc] init];
    self.tokeniser.delegate = self;
    self.parser = [CPLALR1Parser parserWithGrammar:[[CSSSelectorGrammar alloc] init]];
    self.parser.delegate = self;
    return self;
}

- (CSSSelectorGroup*)parse:(NSString *)css error:(NSError*__autoreleasing*)error
{
    CPTokenStream *tokenStream = [self.tokeniser tokenise:css];
    CSSSelectorGroup* result = [self.parser parse:tokenStream];
    if (!result) {
        if (error) {
            *error = self.lastError;
        } else {
            DDLogError(@"CSSSelectorParser: parse error: %@", self.lastError);
        }
    }
    return result;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (nil != self)
    {
        self.parser = [aDecoder decodeObjectForKey:CSSSelectorParserParserKey];
        self.parser.delegate = self;
        
        // CSSSelectorTokeniser is not nscoder compatible!
        self.tokeniser = [[CSSSelectorTokeniser alloc] init];
        self.tokeniser.delegate = self;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.parser forKey:CSSSelectorParserParserKey];
}

#pragma mark - CPParserDelegate

- (id)parser:(CPParser *)parser didProduceSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    switch ([[syntaxTree rule] tag]) {
        case CSSSelectorParserRuleQuotedString: {
            NSArray* children = [syntaxTree children];
            if ([children count] == 1 && [children[0] isQuotedToken]) {
                return [children[0] content];
            } else {
                [NSException raise:CSSSelectorParserException
                            format:@"unexpected token: should be a quoted token, now: %@", syntaxTree];
            }
        }
            break;
            
        default:
            break;
    }
    return syntaxTree;
}

- (CPRecoveryAction *)parser:(CPParser *)parser didEncounterErrorOnInput:(CPTokenStream *)inputStream expecting:(NSSet *)acceptableTokens
{
    NSError* error = [NSError errorWithDomain:CSSSelectorParserErrorDomain
                                         code:1
                                     userInfo:@{CSSSelectorParserErrorInputStreamKey: inputStream, CSSSelectorParserErrorAcceptableTokenKey: acceptableTokens}];
    self.lastError = error;
    return [CPRecoveryAction recoveryActionStop];
}

#pragma mark - CPTokeniserDelegate

- (BOOL)tokeniser:(CPTokeniser *)tokeniser shouldConsumeToken:(CPToken *)token
{
    return YES;
}

@end