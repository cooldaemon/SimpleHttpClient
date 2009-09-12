#import "TestHatenaDiaryHTML.h"

@implementation TestHatenaDiaryHTML

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (void)sendHttpRequest
{
    SimpleHttpClient *client = [[SimpleHttpClient alloc] initWithDelegate:self];
    [client autorelease];

    [client
        setFilter:SimpleHttpClientFilterHTML
          forHost:@"d.hatena.ne.jp"
    ];

    [client
               get:@"http://d.hatena.ne.jp/cooldaemon/20090911/1252637257"
        parameters:nil
           context:nil
    ];
}

- (void)assertCodeAndLengthWithContent
{
    NSLog(@"assertCodeAndLengthWithContent\n");

    NSInteger status = [_response statusCode];
    NSAssert1(200 == status, @"status is %d.", status);

    NSString *htmlString = [_html description];

    NSInteger length = [htmlString length];
    NSAssert1(0 < length, @"%d byte.", length);

    NSLog(@"%d byte was received.\n", length);

    [htmlString
        writeToFile:@"./diary.html"
         atomically:YES
           encoding:NSUTF8StringEncoding
              error:nil
    ];
}

- (void)assertXPath
{
    NSLog(@"assertXPath\n");

    NSError *error = nil;
    NSArray *body = [_html
        nodesForXPath:@"id(\"days\")//div[@class=\"body\"]//h3/following-sibling::*|id(\"days\")//div[@class=\"body\" and not(.//h3)]"
                error:&error
    ];

    NSAssert1(error == nil, @"error is %@", error);

    [[body componentsJoinedByString:@""]
        writeToFile:@"./diary_body.html"
         atomically:YES
           encoding:NSUTF8StringEncoding
              error:nil
    ];
}

//----------------------------------------------------------------------------//
#pragma mark -- SimpleHttpClientOperation delegate --
//----------------------------------------------------------------------------//

- (void)simpleHttpClientOperation:(SimpleHttpClientOperation *)operation
didReceiveResponse:(NSHTTPURLResponse *)response
{
    [_response release];
    _response = [response retain];
}

- (void)simpleHttpClientOperation:(SimpleHttpClientOperation *)operation
  didFailWithError:(NSError *)error
{
    [_error release];
    _error = [error retain];
}

- (void)simpleHttpClientOperationDidFinishLoading:(SimpleHttpClientOperation *)operation
                                     filteredData:(id)data
{
    [_html release];
    _html = (DDXMLDocument *)[data retain];
} 

//----------------------------------------------------------------------------//
#pragma mark -- SimpleHttpClient delegate --
//----------------------------------------------------------------------------//

- (void)simpleHttpClient:(SimpleHttpClient *)client
      didFinishOperation:(SimpleHttpClientOperation *)operation
{
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

    _response = nil;
    _error    = nil;
    _html     = nil;

    return self;
}

- (void)dealloc
{
    [_response release]; _response = nil;
    [_error    release]; _error    = nil;
    [_html     release]; _html     = nil;

    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)test
{
    [self sendHttpRequest];
    [self waitFinish];
    [self assertCodeAndLengthWithContent];
    [self assertXPath];
}

@end
