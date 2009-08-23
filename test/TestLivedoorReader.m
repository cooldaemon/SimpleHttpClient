#import "TestLivedoorReader.h"
#import "SimpleHttpClient.h"

@implementation TestLivedoorReader

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)init
{
    if (![super init]) {
        return nil;
    }

    is_loaded = NO;

    _apiKey   = nil;
    _client   = [[SimpleHttpClient alloc] initWithDelegate:self];
    _data     = [NSMutableData data];

    return self;
}

- (void)dealloc
{
    _apiKey = nil;
    [_client release], _client = nil;
    _data = nil;

    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (NSString *)getInputStreamWithPrompt:(NSString *)prompt
{
    NSFileHandle *output = [NSFileHandle fileHandleWithStandardOutput];
    NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];

    [output writeData:[NSData
        dataWithBytes:[prompt UTF8String]
               length:[prompt length]
    ]];

    NSMutableData *line = [NSMutableData dataWithData:[input availableData]];
    char *p = [line mutableBytes];
    p[[line length] - 1] = (char)NULL;

    return [NSString stringWithUTF8String:[line bytes]];
}

- (void)cleanCookie
{
    NSHTTPCookieStorage *cookieStotage = [NSHTTPCookieStorage
        sharedHTTPCookieStorage
    ];
    [cookieStotage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    NSArray *cookies = [cookieStotage
        cookiesForURL:[NSURL URLWithString:@"http://reader.livedoor.com/"]
    ];

    for (NSHTTPCookie *cookie in cookies) {
        [cookieStotage deleteCookie:cookie];
    }
}

- (void)getApiKeyFromCookie
{
    NSHTTPCookieStorage *cookieStotage = [NSHTTPCookieStorage
        sharedHTTPCookieStorage
    ];

    NSArray *cookies = [cookieStotage
        cookiesForURL:[NSURL URLWithString:@"http://reader.livedoor.com/"]
    ];

    for (NSHTTPCookie *cookie in cookies) {
        if ([@"reader_sid" isEqualToString:cookie.name]) {
            _apiKey = cookie.value;
            return;
        }
    }
}

- (void)sendLoginRequest
{
    [self cleanCookie];

    NSString *username = [self
        getInputStreamWithPrompt:@"Input Livedoor Username:"
    ];
    NSString *password = [self
        getInputStreamWithPrompt:@"Input Livedoor Password:"
    ];

    [_client
              post:@"https://member.livedoor.com/login/index"
        parameters:[NSDictionary dictionaryWithObjectsAndKeys:
            @"http://reader.livedoor.com/reader/", @".next",
            @"reader", @".sv",
            username, @"livedoor_id",
            password, @"password", nil
        ]
           context:@"login"
    ];
}

- (void)sendFeedsRequest
{
    [_client
              post:@"http://reader.livedoor.com/api/subs"
        parameters:[NSDictionary dictionaryWithObjectsAndKeys:
            @"0", @"unread",
            _apiKey, @"ApiKey", nil
        ]
           context:@"subs"
    ];
}

- (void)waitHttpResponse
{
    BOOL is_running;
    do {
        is_running = [[NSRunLoop currentRunLoop]
            runMode:NSDefaultRunLoopMode
            beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]
        ];
    } while (is_running && !is_loaded);

    is_loaded = NO;
}

- (void)assertLogin
{
    NSAssert(nil != _apiKey, @"API Key is null.");
}

- (void)assertFeeds
{
    NSInteger length = [_data length];
    NSAssert1(0 < length, @"%d byte.", length);

    [_data writeToFile:@"./subs.json" atomically:YES];
}

//----------------------------------------------------------------------------//
#pragma mark -- SimpleHttpClientOperation delegate --
//----------------------------------------------------------------------------//

- (void)simpleHttpClientOperation:(SimpleHttpClientOperation *)operation
didReceiveResponse:(NSHTTPURLResponse *)response
{
    NSLog(
        @"%@ status code is %d.",
        operation.context,
        [response statusCode]
    );
} 

- (void)simpleHttpClientOperation:(SimpleHttpClientOperation *)operation
    didReceiveData:(NSData *)data
{
    if ([@"subs" isEqualToString:operation.context]) {
        [_data appendData:data];
    }
} 

- (void)simpleHttpClientOperation:(SimpleHttpClientOperation *)operation
  didFailWithError:(NSError *)error
{
    NSLog(@"%@ error is %@.", operation.context, error);
} 

//----------------------------------------------------------------------------//
#pragma mark -- SimpleHttpClient delegate --
//----------------------------------------------------------------------------//

- (void)simpleHttpClient:(SimpleHttpClient *)client
      didFinishOperation:(SimpleHttpClientOperation *)operation
{
    if ([@"login" isEqualToString:operation.context]) {
        [self getApiKeyFromCookie];
    }

    is_loaded = YES;
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)runTest
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"start TestLivedoorReader\n");
    @try {
        [self sendLoginRequest];
        [self waitHttpResponse];
        [self assertLogin];

        [self sendFeedsRequest];
        [self waitHttpResponse];
        [self assertFeeds];
    }
    @catch (NSException *ex) {
        NSLog(@"Name  : %@\n", [ex name]);
        NSLog(@"Reason: %@\n", [ex reason]);
    }
    NSLog(@"end TestLivedoorReader\n");

    [pool release];
}

@end
