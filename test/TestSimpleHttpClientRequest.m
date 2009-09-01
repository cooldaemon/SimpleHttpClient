#import "TestSimpleHttpClientRequest.h"
#import "SimpleHttpClientRequest.h"

@implementation TestSimpleHttpClientRequest

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (void)putsRequest:(SimpleHttpClientRequest *)request
{
    NSLog(@"Method  : %@\n", request.request.HTTPMethod);
    NSLog(@"URL     : %@\n", request.request.URL);
    NSLog(@"Headers : %@\n", request.request.allHTTPHeaderFields);
    NSLog(@"Body    : %@\n", request.request.HTTPBody);
//    NSLog(@"Timeout : %@\n", request.request.timeoutInterval);
}

- (NSDictionary *)makeParameters
{
    NSArray *deep_objects = [NSArray
        arrayWithObjects:@"foo", @"bar", @"baz", nil
    ];

    NSArray *keys = [NSArray
        arrayWithObjects:@"key1", @"key2", @"key3", @"key4", nil
    ];

    NSArray *objects = [NSArray
        arrayWithObjects:
            @"value value",
            @"value+value",
            deep_objects,
            [NSNumber numberWithFloat:0.1],
            nil
    ];

    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

- (void)assertMethod:(NSString *)method request:(SimpleHttpClientRequest *)request
{
    NSAssert1(
        [method isEqualToString:request.request.HTTPMethod],
        @"Method is %@.", request.request.HTTPMethod
    );
}

- (void)assertUrl:(NSString *)url request:(SimpleHttpClientRequest *)request
{
    NSAssert1(
        [[NSURL URLWithString:url] isEqual:request.request.URL],
        @"URL is %@.", request.request.URL
    );
}

- (void)assertHeaderWithRequest:(SimpleHttpClientRequest *)request
{
    NSDictionary *headers;
    if (
           [@"GET" isEqualToString:request.request.HTTPMethod]
        || [@"DELETE" isEqualToString:request.request.HTTPMethod]
    ) {
        headers = [NSDictionary
            dictionaryWithObject:@"User Agent"
                          forKey:@"User-Agent"
        ];
    } else {
        NSArray *keys = [NSArray
            arrayWithObjects:@"User-Agent", @"Content-Type", @"Content-Length", nil
        ];

        NSArray *objects = [NSArray
            arrayWithObjects:@"User Agent", @"application/x-www-form-urlencoded", @"73", nil
        ];

        headers = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    }

    NSAssert1(
        [headers isEqualToDictionary:request.request.allHTTPHeaderFields],
        @"headers is %@.", request.request.allHTTPHeaderFields
    );
}

- (void)assertBodyWithRequest:(SimpleHttpClientRequest *)request
{
    NSData *body = [@"key1=value+value&key2=value%2Bvalue&key3=foo&key3=bar&key3=baz&key4=0%2E1" dataUsingEncoding:NSUTF8StringEncoding];

    NSAssert1(
        [body isEqualToData:request.request.HTTPBody],
        @"body is %@.", request.request.HTTPBody
    );
}

- (void)assertGetRequest
{
    SimpleHttpClientRequest *request = [[SimpleHttpClientRequest alloc]
        initWithMethod:SimpleHttpClientRequestMethodGET
                   url:@"http://google.com/"
            parameters:[self makeParameters]
             userAgent:@"User Agent"
                  wsse:nil
               timeout:180.0
    ];
    [request autorelease];

    [self assertMethod:@"GET" request:request];
    [self assertUrl:@"http://google.com/?key1=value+value&key2=value%2Bvalue&key3=foo&key3=bar&key3=baz&key4=0%2E1" request:request];
    [self assertHeaderWithRequest:request];

    [self putsRequest:request];
}

- (void)assertDeleteRequest
{
    SimpleHttpClientRequest *request = [[SimpleHttpClientRequest alloc]
        initWithMethod:SimpleHttpClientRequestMethodDELETE
                   url:@"http://google.com/"
            parameters:[self makeParameters]
             userAgent:@"User Agent"
                  wsse:nil
               timeout:180.0
    ];
    [request autorelease];
 
    [self assertMethod:@"DELETE" request:request];
    [self assertUrl:@"http://google.com/?key1=value+value&key2=value%2Bvalue&key3=foo&key3=bar&key3=baz&key4=0%2E1" request:request];
    [self assertHeaderWithRequest:request];
    [self putsRequest:request];
}

- (void)assertPostRequest
{
    SimpleHttpClientRequest *request = [[SimpleHttpClientRequest alloc]
        initWithMethod:SimpleHttpClientRequestMethodPOST
                   url:@"http://google.com/"
            parameters:[self makeParameters]
             userAgent:@"User Agent"
                  wsse:nil
               timeout:360
    ];
    [request autorelease];
 
    [self assertMethod:@"POST" request:request];
    [self assertUrl:@"http://google.com/" request:request];
    [self assertHeaderWithRequest:request];
    [self assertBodyWithRequest:request];
    [self putsRequest:request];
}

- (void)assertPutRequest
{
    SimpleHttpClientRequest *request = [[SimpleHttpClientRequest alloc]
        initWithMethod:SimpleHttpClientRequestMethodPUT
                   url:@"http://google.com/"
            parameters:[self makeParameters]
             userAgent:@"User Agent"
                  wsse:nil
               timeout:360
    ];
    [request autorelease];
 
    [self assertMethod:@"PUT" request:request];
    [self assertUrl:@"http://google.com/" request:request];
    [self assertHeaderWithRequest:request];
    [self assertBodyWithRequest:request];
    [self putsRequest:request];
}

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
    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)runTest
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"start TestSimpleHttpClientRequest\n");
    @try {
        [self assertGetRequest];
        [self assertDeleteRequest];
        [self assertPostRequest];
        [self assertPutRequest];
    }
    @catch (NSException *ex) {
        NSLog(@"Name  : %@\n", [ex name]);
        NSLog(@"Reason: %@\n", [ex reason]);
    }
    NSLog(@"end TestSimpleHttpClientRequest\n");

    [pool release];
}

@end
