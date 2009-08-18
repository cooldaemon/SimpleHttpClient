#import "TestSimpleHttpClient.h"

@implementation TestSimpleHttpClient

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)init
{
    if (![super init]) {
        return nil;
    }

    is_loaded   = NO;

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
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (void)sendHttpRequest
{
    [_isAllLoaded setObject:@"NO" forKey:@"objc"];
    [_isAllLoaded setObject:@"NO" forKey:@"iphone"];
    [_isAllLoaded setObject:@"NO" forKey:@"hello"];

    SimpleHttpClient *client = [[SimpleHttpClient alloc] initWithDelegate:self];
    [client autorelease];

    // GET http://google.com/search?q=objc
    [client
               get:@"http://google.com/search"
        parameters:[NSDictionary dictionaryWithObject:@"objc" forKey:@"q"]
           context:@"objc"
    ];

    // GET http://google.com/search?q=iphone&q=osx&lr=lang_en
    NSMutableDictionary *params = [NSMutableDictionary
        dictionaryWithObject:[NSArray arrayWithObjects:@"iphone", @"osx", nil]
                      forKey:@"q"
    ];
    [params setObject:@"lang_en" forKey:@"lr"];
    [client
               get:@"http://google.com/search"
        parameters:params
           context:@"iphone"
    ];

    // POST http://www.excite.co.jp/world/english/?before=hello
    [client
               post:@"http://www.excite.co.jp/world/english/"
        parameters:[NSDictionary dictionaryWithObject:@"hello" forKey:@"before"]
           context:@"hello"
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
}

- (void)assertCodeAndLengthWithContent:(NSString *)context
{
    NSLog(@"assertCodeAndLengthWithContent: %@\n", context);

    int status = [[_response objectForKey:context] statusCode];
    NSAssert1(200 == status, @"status is %d.", status);

    int length = [[_data objectForKey:context] length];
    NSAssert1(0 < length, @"%d byte.", length);

    NSLog(@"%d byte was received.\n", length);

    [[_data objectForKey:context]
        writeToFile:[[@"./" stringByAppendingString:context] stringByAppendingString:@".html"]
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

    is_loaded = YES;
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)runTest
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"start TestSimpleHttpClient\n");
    @try {
        [self sendHttpRequest];
        [self waitHttpResponse];

        [self assertCodeAndLengthWithContent:@"objc"];
        [self assertCodeAndLengthWithContent:@"iphone"];
        [self assertCodeAndLengthWithContent:@"hello"];
    }
    @catch (NSException *ex) {
        NSLog(@"Name  : %@\n", [ex name]);
        NSLog(@"Reason: %@\n", [ex reason]);
    }
    NSLog(@"end TestSimpleHttpClient\n");

    [pool release];
}

@end
