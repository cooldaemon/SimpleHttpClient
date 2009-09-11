#import "TestLivedoorReader.h"

@implementation TestLivedoorReader

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)init
{
    if (![super init]) {
        return nil;
    }

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

    [self setFinish];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)test
{
    [self sendLoginRequest];
    [self waitFinish];
    [self assertLogin];

    [self sendFeedsRequest];
    [self waitFinish];
    [self assertFeeds];
}

@end
