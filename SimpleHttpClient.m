#import "SimpleHttpClient.h"

#define DEFAULT_REQUEST_TIMEOUT 180.0
#define DEFAULT_USER_AGENT      @"Simple Http Client"

@implementation SimpleHttpClient

@synthesize timeout     = _timeout;
@synthesize userAgent   = _userAgent;

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (NSMutableURLRequest *)makeRequest:(NSString *)url
{
    NSMutableURLRequest* request = [NSMutableURLRequest
        requestWithURL:[NSURL URLWithString:url]
        cachePolicy:NSURLRequestUseProtocolCachePolicy
        timeoutInterval:self.timeout
    ];

    [request setHTTPShouldHandleCookies:YES];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];

    return request;
}

- (void)addOperation:(NSMutableURLRequest *)request
             context:(void *)context
            priority:(NSOperationQueuePriority)priority
            delegate:(id)delegate
{
    SimpleHttpClientOperation* operation = [[SimpleHttpClientOperation alloc]
        initWithRequest:request
                context:context
               delegate:delegate
    ];
    [operation autorelease];

    [operation
        addObserver:self
         forKeyPath:@"isFinished"
            options:NSKeyValueObservingOptionNew
            context:nil
    ];

    [operation setQueuePriority:priority];

    [_queue addOperation:operation];
}

- (NSString*)urlEncode:(NSString*)target
{
    const char* cTarget = [target UTF8String];
    NSMutableString* result = [NSMutableString string];

    for (;*cTarget; cTarget++) {
        unsigned char append = *cTarget;
        NSString* format = @"%c";

        if (' ' == append) {
            append = '+';
        } else if (!(
               '0' <= append && append <= '9'
            || 'A' <= append && append <= 'Z'
            || 'a' <= append && append <= 'z'
            || '-' == append
            || '_' == append
        )) {
            format = @"%%%02X";
        }

        [result appendFormat:format, append];
    }
        
    return result;
}

- (NSString *)makeParamString:(NSDictionary *)params
{
    NSMutableString *paramString = [NSMutableString string];
    if (!params) {
        return paramString;
    }

    NSEnumerator *paramEnum = [params keyEnumerator];
    id key;
    while (key = [paramEnum nextObject]) {
        if (![key isKindOfClass:[NSString class]]) {
            continue;
        }
        NSString *encodedKey = [self urlEncode:key];

        id value = [params objectForKey:key];

        if ([value isKindOfClass:[NSString class]]) {
            [paramString appendFormat:@"%@=%@&", encodedKey, [self urlEncode:value]];
            continue;
        }

        if (![value isKindOfClass:[NSArray class]]) {
            continue;
        }

        NSEnumerator *valueEnum = [value objectEnumerator];
        id valueElem;
        while (valueElem = [valueEnum nextObject]) {
            if (![valueElem isKindOfClass:[NSString class]]) {
                continue;
            }
            [paramString appendFormat:@"%@=%@&",
                encodedKey,
                [self urlEncode:valueElem]
            ];
        }
    }

    if (paramString.length > 0) { // delete last '&'.
        [paramString deleteCharactersInRange:NSMakeRange(paramString.length-1, 1)];
    }

    return paramString;
}

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)initWithDelegate:(id)delegate
{
    if (![super init]) {
        return nil;
    }

    _queue          = [[NSOperationQueue alloc] init];
    self.timeout    = DEFAULT_REQUEST_TIMEOUT;
    self.userAgent  = DEFAULT_USER_AGENT;
    _delegate       = delegate;
 
    return self;
}

- (id)initWithMaxConnection:(NSInteger)maxConnection delegate:(id)delegate
{
    if (![self initWithDelegate:delegate]) {
        return nil;
    }

    [_queue setMaxConcurrentOperationCount:maxConnection];

    return self;
}

- (void)dealloc
{
    [self cancel];
    [_queue release], _queue = nil;
    [self.userAgent release], self.userAgent = nil;
    _delegate = nil;
    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)cancel
{
    [_queue cancelAllOperations];
}

- (NSArray *)operations
{
    return [_queue operations];
}

- (void)get:(NSString *)url
 parameters:(NSDictionary *)params
    context:(void *)context
{
    [self
               get:url
        parameters:params
           context:context
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)get:(NSString *)url
 parameters:(NSDictionary *)params
    context:(void *)context
   priority:(NSOperationQueuePriority)priority
{
    [self
               get:url
        parameters:params
           context:context
          priority:priority
          delegate:_delegate
    ];
}

- (void)get:(NSString *)url
 parameters:(NSDictionary *)params
    context:(void *)context
   delegate:(id)delegate
{
    [self
               get:url
        parameters:params
           context:context
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)get:(NSString *)url
 parameters:(NSDictionary *)params
    context:(void *)context
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate
{
    NSString *paramString = [self makeParamString:params];

    NSMutableString *requestUrl = [NSMutableString stringWithString:url]; 
    if (paramString.length > 0) {
        [requestUrl appendString:@"?"];
        [requestUrl appendString:paramString];
    }

    [self
        addOperation:[self makeRequest:requestUrl]
             context:context
            priority:priority
            delegate:delegate
    ];
}

- (void)post:(NSString *)url
  parameters:(NSDictionary *)params
     context:(void *)context
{
    [self
              post:url
        parameters:params
           context:context
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)post:(NSString *)url
  parameters:(NSDictionary *)params
     context:(void *)context
    priority:(NSOperationQueuePriority)priority
{
    [self
              post:url
        parameters:params
           context:context
          priority:priority
          delegate:_delegate
    ];
}

- (void)post:(NSString *)url
  parameters:(NSDictionary *)params
     context:(void *)context
    delegate:(id)delegate
{
    [self
              post:url
        parameters:params
           context:context
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)post:(NSString *)url
  parameters:(NSDictionary *)params
     context:(void *)context
    priority:(NSOperationQueuePriority)priority
    delegate:(id)delegate
{
    NSMutableURLRequest* request = [self makeRequest:url];

    [request setHTTPMethod:@"POST"];

    NSData *body = [
        [self makeParamString:params] dataUsingEncoding:NSUTF8StringEncoding
    ];

    [request
                  setValue:@"application/x-www-form-urlencoded"
        forHTTPHeaderField:@"Content-Type"
    ];

    [request
                  setValue:[NSString stringWithFormat:@"%d", body.length]
        forHTTPHeaderField:@"Content-Length"
    ];
 
    [request setHTTPBody:body];

    [self
        addOperation:request
             context:context
            priority:priority
            delegate:delegate
    ];
}

//----------------------------------------------------------------------------//
#pragma mark -- Observe --
//----------------------------------------------------------------------------//

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    if ([_delegate respondsToSelector:@selector(
        simpleHttpClient:didFinishOperation:
    )]) {
        [_delegate
            simpleHttpClient:self
          didFinishOperation:(SimpleHttpClientOperation *)object
        ];
    }

    [object removeObserver:self forKeyPath:keyPath];
}

@end

