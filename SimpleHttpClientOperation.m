#import "SimpleHttpClientOperation.h"

@implementation SimpleHttpClientOperation

@synthesize context  = _context;
@synthesize delegate = _delegate;

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (void)cancelConnection
{
    if (!_connection) {
        return;
    }

    [_connection cancel];
//    [_connection release];
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

- (id)initWithRequest:(NSURLRequest *)request
              context:(void *)context
             delegate:(id)delegate
{
    if (![super init]) {
        return nil;
    }

    _request     = [request retain];
    self.context = context;
    _delegate    = delegate;
    _connection  = nil;
    _isExecuting = NO;
    _isFinished  = NO;

    return self;
}

- (void)dealloc
{
    [self cancelConnection];
    [_request release], _request = nil;
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

    [self setValue:[NSNumber numberWithBool:YES] forKey:@"isExecuting"];

    _connection = [NSURLConnection connectionWithRequest:_request delegate:self];
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
    if ([self.delegate respondsToSelector:@selector(
        simpleHttpClientOperationDidFinishLoading:
    )]) {
        [self.delegate simpleHttpClientOperationDidFinishLoading:self];
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
