#import "SimpleHttpClientOperation.h"

@implementation SimpleHttpClientOperation

@synthesize context  = _context;
@synthesize delegate = _delegate;

//----------------------------------------------------------------------------//
#pragma mark -- Class Method --
//----------------------------------------------------------------------------//

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if (
           [key isEqualToString:@"isExecuting"]
        || [key isEqualToString:@"isFinished"]
    ) {
        return YES;
    }

    return [super automaticallyNotifiesObserversForKey:key];
}

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (void)cancelConnection
{
    if (!_connection) {
        return;
    }

    [_connection cancel];
    _connection = nil;
}

- (void)stopOperation
{
    [self cancelConnection];

    [self setValue:[NSNumber numberWithBool:NO] forKey:@"isExecuting"];
    [self setValue:[NSNumber numberWithBool:YES] forKey:@"isFinished"];
}

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)initWithRequest:(NSURLRequest *)request
               filter:(SimpleHttpClientFilterBase *)filter
              context:(void *)context
             delegate:(id)delegate
{
    if (![super init]) {
        return nil;
    }

    _request      = [request retain];
    _filter       = filter;
    self.context  = context;
    _delegate     = delegate;
    _connection   = nil;
    _downloadData = [[NSMutableData alloc] init];
    _isExecuting  = NO;
    _isFinished   = NO;

    return self;
}

- (void)dealloc
{
    [self cancelConnection];
    [_request release], _request = nil;
    _filter = nil;
    _delegate = nil;
    [_downloadData release], _downloadData = nil;
    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- Operating --
//----------------------------------------------------------------------------//

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (BOOL)isFinished
{
    return _isFinished;
}

- (void)start
{
    if ([self isCancelled]) {
        return;
    }

    [NSThread
        detachNewThreadSelector:@selector(main)
                       toTarget:self
                     withObject:nil
    ];

    [self setValue:[NSNumber numberWithBool:YES] forKey:@"isExecuting"];
}

- (void)main
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    _connection = [NSURLConnection connectionWithRequest:_request delegate:self];

    do {
        [[NSRunLoop currentRunLoop]
               runMode:NSDefaultRunLoopMode
            beforeDate:[NSDate distantFuture]
        ];
    } while (![self isFinished]);
   
    [pool release];
}

- (void)cancel
{
    [self stopOperation];
    [super cancel];
}

//----------------------------------------------------------------------------//
#pragma mark -- NSURLConnection delegate --
//----------------------------------------------------------------------------//

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSHTTPURLResponse *)response
{
    if ([self.delegate respondsToSelector:@selector(
        simpleHttpClientOperation:didReceiveResponse:
    )]) {
        [self.delegate
            simpleHttpClientOperation:self
                   didReceiveResponse:response
        ];
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    if (_filter) {
        [_downloadData appendData:data];
        return;
    }

    if ([self.delegate respondsToSelector:@selector(
        simpleHttpClientOperation:didReceiveData:
    )]) {
        [self.delegate simpleHttpClientOperation:self didReceiveData:data];
    }
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(
        simpleHttpClientOperation:didFailWithError:
    )]) {
        [self.delegate simpleHttpClientOperation:self didFailWithError:error];
    }
    [self stopOperation];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (
           _filter
        && [self.delegate respondsToSelector:@selector(
               simpleHttpClientOperationDidFinishLoading:filteredData:
           )]
    ) {
        [self.delegate
            simpleHttpClientOperationDidFinishLoading:self
                                         filteredData:[_filter apply:_downloadData]
        ];
    } else {
        if ([self.delegate respondsToSelector:@selector(
            simpleHttpClientOperationDidFinishLoading:
        )]) {
            [self.delegate simpleHttpClientOperationDidFinishLoading:self];
        }
    }

    [self stopOperation];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)response
{
    if ([self.delegate respondsToSelector:@selector(
        simpleHttpClientOperation:willSendRequest:redirectResponse:
    )]) {
        return [self.delegate
            simpleHttpClientOperation:self
                      willSendRequest:request
                     redirectResponse:response
        ];
    }
    return request;
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)stop
{
    [self stopOperation];
}

@end
