#import "SimpleHttpClient.h"
#import "SimpleHttpClientRequest.h"

#define DEFAULT_REQUEST_TIMEOUT 180.0
#define DEFAULT_USER_AGENT      @"Simple Http Client"

@implementation SimpleHttpClient

@synthesize timeout     = _timeout;
@synthesize userAgent   = _userAgent;

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (void)addOperation:(SimpleHttpClientRequest *)request
             context:(void *)context
            priority:(NSOperationQueuePriority)priority
            delegate:(id)delegate
{
    SimpleHttpClientOperation* operation = [[SimpleHttpClientOperation alloc]
        initWithRequest:request.request
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
    SimpleHttpClientRequest *request = [[SimpleHttpClientRequest alloc]
        initWithMethod:SimpleHttpClientRequestMethodGET
                    url:url
             parameters:params
              userAgent:self.userAgent
                timeout:self.timeout
    ];
    [request autorelease];

    [self
        addOperation:request
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
    SimpleHttpClientRequest *request = [[SimpleHttpClientRequest alloc]
        initWithMethod:SimpleHttpClientRequestMethodPOST
                    url:url
             parameters:params
              userAgent:self.userAgent
                timeout:self.timeout
    ];
    [request autorelease];

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

