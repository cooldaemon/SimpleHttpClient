#import "TestHatenaBookmark.h"
#import "SimpleHttpClient.h"

@implementation TestHatenaBookmark

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (void)sendHttpRequest
{
    NSString *username = [self
        getInputStreamWithPrompt:@"Input Hatena Username:"
    ];
    NSString *password = [self
        getInputStreamWithPrompt:@"Input Hatena Password:"
    ];

    [_isAllLoaded setObject:@"NO" forKey:@"endpoint"];
    [_isAllLoaded setObject:@"NO" forKey:@"feed"];

    SimpleHttpClient *client = [[SimpleHttpClient alloc] initWithDelegate:self];
    [client autorelease];

    [client
        setCredentialForHost:@"b.hatena.ne.jp"
                    username:username
                    password:password
    ];

    [client
               get:@"http://b.hatena.ne.jp/atom"
        parameters:nil
           context:@"endpoint"
    ];

    [client
               get:@"http://b.hatena.ne.jp/atom/feed"
        parameters:nil
           context:@"feed"
    ];
}

- (void)assertCodeAndLengthWithContent:(NSString *)context
{
    NSLog(@"assertCodeAndLengthWithContent: %@\n", context);

    NSInteger status = [[_response objectForKey:context] statusCode];
    NSAssert1(200 == status, @"status is %d.", status);

    NSInteger length = [[_data objectForKey:context] length];
    NSAssert1(0 < length, @"%d byte.", length);

    NSLog(@"%d byte was received.\n", length);

    [[_data objectForKey:context]
        writeToFile:[NSString stringWithFormat:@"./%@.xml", context]
         atomically:YES
    ];
}

//----------------------------------------------------------------------------//
#pragma mark -- SimpleHttpClientOperation delegate --
//----------------------------------------------------------------------------//

- (void)simpleHttpClientOperation:(SimpleHttpClientOperation *)operation
didReceiveResponse:(NSHTTPURLResponse *)response
{
    [_response setObject:response forKey:operation.context];
} 

- (void)simpleHttpClientOperation:(SimpleHttpClientOperation *)operation
    didReceiveData:(NSData *)data
{
    if (![_data objectForKey:operation.context]) {
        [_data setObject:[NSMutableData data] forKey:operation.context];
    }
    [[_data objectForKey:operation.context] appendData:data];
} 

- (void)simpleHttpClientOperation:(SimpleHttpClientOperation *)operation
  didFailWithError:(NSError *)error
{
    [_error setObject:error forKey:operation.context];
} 

//----------------------------------------------------------------------------//
#pragma mark -- SimpleHttpClient delegate --
//----------------------------------------------------------------------------//

- (void)simpleHttpClient:(SimpleHttpClient *)client
      didFinishOperation:(SimpleHttpClientOperation *)operation
{
    [_isAllLoaded setObject:@"YES" forKey:operation.context];

    NSEnumerator *isAllLoadedEnum = [_isAllLoaded keyEnumerator];
    NSString *context;
    while (context = [isAllLoadedEnum nextObject]) {
        if ([[_isAllLoaded objectForKey:context] isEqualToString:@"NO"]) {
            return;
        }
    }

    [self setFinish];
}

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)init
{
    if (![super init]) {
        return nil;
    }

    _isAllLoaded = [NSMutableDictionary dictionary];
    _response    = [NSMutableDictionary dictionary];
    _data        = [NSMutableDictionary dictionary];
    _error       = [NSMutableDictionary dictionary];

    return self;
}

- (void)dealloc
{
    _isAllLoaded = nil;
    _response    = nil;
    _data        = nil;
    _error       = nil;

    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)test
{
    [self sendHttpRequest];
    [self waitFinish];

    [self assertCodeAndLengthWithContent:@"endpoint"];
    [self assertCodeAndLengthWithContent:@"feed"];
}

@end
