#import "TestHatenaBookmarkXML.h"
#import "SimpleHttpClient.h"

@implementation TestHatenaBookmarkXML

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
        setFilter:SimpleHttpClientFilterXML
          forHost:@"b.hatena.ne.jp"
    ];

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

    NSString *xmlString = [[_xml objectForKey:context] description];

    NSInteger length = [xmlString length];
    NSAssert1(0 < length, @"%d byte.", length);

    NSLog(@"%d byte was received.\n", length);

    [xmlString
        writeToFile:[NSString stringWithFormat:@"./%@_xml.xml", context]
         atomically:YES
           encoding:NSUTF8StringEncoding
              error:nil
    ];
}

//----------------------------------------------------------------------------//
#pragma mark -- SimpleHttpClientOperation delegate --
//----------------------------------------------------------------------------//

- (void)simpleHttpClientOperationDidFinishLoading:(SimpleHttpClientOperation *)operation
                                     filteredData:(id)data
{
    [_xml setObject:(DDXMLDocument *)data forKey:operation.context];
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
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)init
{
    if (![super init]) {
        return nil;
    }

    _xml = [NSMutableDictionary dictionary];

    return self;
}

- (void)dealloc
{
    _xml = nil;
    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)runTest
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"start TestHatenaBookmarkXML\n");
    @try {
        [self sendHttpRequest];
        [self waitHttpResponse];

        [self assertCodeAndLengthWithContent:@"endpoint"];
        [self assertCodeAndLengthWithContent:@"feed"];
    }
    @catch (NSException *ex) {
        NSLog(@"Name  : %@\n", [ex name]);
        NSLog(@"Reason: %@\n", [ex reason]);
    }
    NSLog(@"end TestHatenaBookmarkXML\n");

    [pool release];
}

@end
