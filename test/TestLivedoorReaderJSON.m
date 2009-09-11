#import "TestLivedoorReaderJSON.h"
#import "SimpleHttpClient.h"

@implementation TestLivedoorReaderJSON

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)init
{
    if (![super init]) {
        return nil;
    }

    return self;
}

- (void)dealloc
{
    [_subs release], _subs = nil;
    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (void)sendFeedsRequest
{
    [_client
        setFilter:SimpleHttpClientFilterJSON
          forHost:@"reader.livedoor.com"
    ];

    [_client
              post:@"http://reader.livedoor.com/api/subs"
        parameters:[NSDictionary dictionaryWithObjectsAndKeys:
            @"0", @"unread",
            _apiKey, @"ApiKey", nil
        ]
           context:@"subs"
    ];
}

- (void)assertFeeds
{
    NSUInteger count = [_subs count];
    NSAssert1(0 < count, @"count is %d.", count);

    [[_subs description]
        writeToFile:@"./subs_json.json"
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
    if ([@"subs" isEqualToString:operation.context]) {
        _subs = (NSArray *)[data retain];
    }
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
