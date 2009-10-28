#import "SimpleHttpClient.h"
#import "SimpleHttpClientRequest.h"

#define DEFAULT_REQUEST_TIMEOUT 180.0
#define DEFAULT_USER_AGENT      @"Simple Http Client"

@implementation SimpleHttpClient

@synthesize timeout   = _timeout;
@synthesize userAgent = _userAgent;

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (void)addOperation:(NSURLRequest *)request
             context:(void *)context
              filter:(SimpleHttpClientFilterName)filterName
            priority:(NSOperationQueuePriority)priority
            delegate:(id)delegate
{
    SimpleHttpClientFilterBase *filter
        = [_filter filterObjectForName:filterName];
    if (!filter) {
        filter = [_filter filterObjectForHost:request.URL.host];
    }

    SimpleHttpClientOperation* operation = [[SimpleHttpClientOperation alloc]
        initWithRequest:request
                 filter:filter
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

- (void)requestWithMethod:(SimpleHttpClientRequestMethod)method
                      url:(NSString *)url
               parameters:(NSDictionary *)parameters
                  context:(void *)context
                   filter:(SimpleHttpClientFilterName)filterName
                 priority:(NSOperationQueuePriority)priority
                 delegate:(id)delegate
{
    SimpleHttpClientRequest *request = [[SimpleHttpClientRequest alloc]
        initWithMethod:method
                   url:url
            parameters:parameters
             userAgent:self.userAgent
                  wsse:_wsse
               timeout:self.timeout
    ];

    [self
        addOperation:request.request
             context:context
              filter:filterName
            priority:priority
            delegate:delegate
    ];

    [request release];
}

- (void)requestWithMethod:(SimpleHttpClientRequestMethod)method
                      url:(NSString *)url
                  headers:(NSDictionary *)headers
                     body:(NSString *)body
                  context:(void *)context
                   filter:(SimpleHttpClientFilterName)filterName
                 priority:(NSOperationQueuePriority)priority
                 delegate:(id)delegate
{
    SimpleHttpClientRequest *request = [[SimpleHttpClientRequest alloc]
        initWithMethod:method
                   url:url
               headers:headers
                  body:body
             userAgent:self.userAgent
                  wsse:_wsse
               timeout:self.timeout
    ];

    [self
        addOperation:request.request
             context:context
              filter:filterName
            priority:priority
            delegate:delegate
    ];

    [request release];
}

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)initWithOperationQueue:(NSOperationQueue *)queue
                    delegate:(id)delegate
{
    if (![super init]) {
        return nil;
    }

    if (queue) {
        _queue = [queue retain];
    } else {
        _queue = [[NSOperationQueue alloc] init];
    }

    self.timeout    = DEFAULT_REQUEST_TIMEOUT;
    self.userAgent  = DEFAULT_USER_AGENT;
    _wsse           = [[SimpleHttpClientWSSE alloc] init];
    _filter         = [[SimpleHttpClientFilter alloc] init];
    _delegate       = delegate;
 
    return self;
}

- (id)initWithDelegate:(id)delegate
{
    return [self initWithOperationQueue:nil delegate:delegate];
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
    [_wsse release], _wsse = nil;
    [_filter release], _filter = nil;
    _delegate = nil;
    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)setCredentialForHost:(NSString *)host
                    username:(NSString *)username
                    password:(NSString *)password
{
    [_wsse setCredentialForHost:host username:username password:password];
}

- (void)removeCredentialForHost:(NSString *)host
{
    [_wsse removeCredentialForHost:host];
}

- (void)setFilter:(SimpleHttpClientFilterName)filterName
          forHost:(NSString *)host
{
    [_filter setFilter:filterName forHost:host];
}

- (void)removeFilterForHost:(NSString *)host
{
    [_filter removeFilterForHost:host];
}

- (void)cancel
{
    [_queue cancelAllOperations];
}

- (NSArray *)operations
{
    return [_queue operations];
}

#pragma mark -- GET methods --

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
{
    [self
               get:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
{
    [self
               get:url
        parameters:parameters
           context:context
            filter:filterName
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
   priority:(NSOperationQueuePriority)priority
{
    [self
               get:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:priority
          delegate:_delegate
    ];
}

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
   delegate:(id)delegate
{
    [self
               get:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   priority:(NSOperationQueuePriority)priority
{
    [self
               get:url
        parameters:parameters
           context:context
            filter:filterName
          priority:priority
          delegate:_delegate
    ];
}

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   delegate:(id)delegate
{
    [self
               get:url
        parameters:parameters
           context:context
            filter:filterName
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate
{
    [self
               get:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:priority
          delegate:delegate
    ];
}

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate
{
    [self
        requestWithMethod:SimpleHttpClientRequestMethodGET
                      url:url
               parameters:parameters
                  context:context
                   filter:filterName
                 priority:priority
                 delegate:delegate
    ];
}

#pragma mark -- POST methods --

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
{
    [self
              post:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
{
    [self
              post:url
        parameters:parameters
           context:context
            filter:filterName
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
    priority:(NSOperationQueuePriority)priority
{
    [self
              post:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:priority
          delegate:_delegate
    ];
}

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
    delegate:(id)delegate
{
    [self
              post:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
    priority:(NSOperationQueuePriority)priority
{
    [self
              post:url
        parameters:parameters
           context:context
            filter:filterName
          priority:priority
          delegate:_delegate
    ];
}

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
    delegate:(id)delegate
{
    [self
              post:url
        parameters:parameters
           context:context
            filter:filterName
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
    priority:(NSOperationQueuePriority)priority
    delegate:(id)delegate
{
    [self
              post:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:priority
          delegate:delegate
    ];
}

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
    priority:(NSOperationQueuePriority)priority
    delegate:(id)delegate
{
    [self
        requestWithMethod:SimpleHttpClientRequestMethodPOST
                      url:url
               parameters:parameters
                  context:context
                   filter:filterName
                 priority:priority
                 delegate:delegate
    ];
}

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
{
    [self
              post:url
           headers:headers
              body:body
           context:context
            filter:SimpleHttpClientFilterNil
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
{
    [self
              post:url
           headers:headers
              body:body
           context:context
            filter:filterName
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
    priority:(NSOperationQueuePriority)priority
{
    [self
              post:url
           headers:headers
              body:body
           context:context
            filter:SimpleHttpClientFilterNil
          priority:priority
          delegate:_delegate
    ];
}

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
    delegate:(id)delegate
{
    [self
              post:url
           headers:headers
              body:body
           context:context
            filter:SimpleHttpClientFilterNil
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
    priority:(NSOperationQueuePriority)priority
{
    [self
              post:url
           headers:headers
              body:body
           context:context
            filter:filterName
          priority:priority
          delegate:_delegate
    ];
}

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
    delegate:(id)delegate
{
    [self
              post:url
           headers:headers
              body:body
           context:context
            filter:filterName
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
    priority:(NSOperationQueuePriority)priority
    delegate:(id)delegate
{
    [self
              post:url
           headers:headers
              body:body
           context:context
            filter:SimpleHttpClientFilterNil
          priority:priority
          delegate:delegate
    ];
}

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
    priority:(NSOperationQueuePriority)priority
    delegate:(id)delegate
{
    [self
        requestWithMethod:SimpleHttpClientRequestMethodPOST
                      url:url
                  headers:headers
                     body:body
                  context:context
                   filter:filterName
                 priority:priority
                 delegate:delegate
    ];
}

#pragma mark -- PUT methods --

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
{
    [self
               put:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
{
    [self
               put:url
        parameters:parameters
           context:context
            filter:filterName
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
   priority:(NSOperationQueuePriority)priority
{
    [self
               put:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:priority
          delegate:_delegate
    ];
}

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
   delegate:(id)delegate
{
    [self
               put:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   priority:(NSOperationQueuePriority)priority
{
    [self
               put:url
        parameters:parameters
           context:context
            filter:filterName
          priority:priority
          delegate:_delegate
    ];
}

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   delegate:(id)delegate
{
    [self
               put:url
        parameters:parameters
           context:context
            filter:filterName
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate
{
    [self
               put:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:priority
          delegate:delegate
    ];
}

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate
{
    [self
        requestWithMethod:SimpleHttpClientRequestMethodPUT
                      url:url
               parameters:parameters
                  context:context
                   filter:filterName
                 priority:priority
                 delegate:delegate
    ];
}

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
{
    [self
               put:url
           headers:headers
              body:body
           context:context
            filter:SimpleHttpClientFilterNil
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
{
    [self
               put:url
           headers:headers
              body:body
           context:context
            filter:filterName
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
   priority:(NSOperationQueuePriority)priority
{
    [self
               put:url
           headers:headers
              body:body
           context:context
            filter:SimpleHttpClientFilterNil
          priority:priority
          delegate:_delegate
    ];
}

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
   delegate:(id)delegate
{
    [self
               put:url
           headers:headers
              body:body
           context:context
            filter:SimpleHttpClientFilterNil
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   priority:(NSOperationQueuePriority)priority
{
    [self
               put:url
           headers:headers
              body:body
           context:context
            filter:filterName
          priority:priority
          delegate:_delegate
    ];
}

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   delegate:(id)delegate
{
    [self
               put:url
           headers:headers
              body:body
           context:context
            filter:filterName
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate
{
    [self
               put:url
           headers:headers
              body:body
           context:context
            filter:SimpleHttpClientFilterNil
          priority:priority
          delegate:delegate
    ];
}

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate
{
    [self
        requestWithMethod:SimpleHttpClientRequestMethodPUT
                      url:url
                  headers:headers
                     body:body
                  context:context
                   filter:filterName
                 priority:priority
                 delegate:delegate
    ];
}

#pragma mark -- DELETE methods --

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
{
    [self
            delete:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
        filter:(SimpleHttpClientFilterName)filterName
{
    [self
            delete:url
        parameters:parameters
           context:context
            filter:filterName
          priority:NSOperationQueuePriorityNormal
          delegate:_delegate
    ];
}

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
      priority:(NSOperationQueuePriority)priority
{
    [self
            delete:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:priority
          delegate:_delegate
    ];
}

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
      delegate:(id)delegate
{
    [self
            delete:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
        filter:(SimpleHttpClientFilterName)filterName
      priority:(NSOperationQueuePriority)priority
{
    [self
            delete:url
        parameters:parameters
           context:context
            filter:filterName
          priority:priority
          delegate:_delegate
    ];
}

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
        filter:(SimpleHttpClientFilterName)filterName
      delegate:(id)delegate
{
    [self
            delete:url
        parameters:parameters
           context:context
            filter:filterName
          priority:NSOperationQueuePriorityNormal
          delegate:delegate
    ];
}

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
      priority:(NSOperationQueuePriority)priority
      delegate:(id)delegate
{
    [self
            delete:url
        parameters:parameters
           context:context
            filter:SimpleHttpClientFilterNil
          priority:priority
          delegate:delegate
    ];
}

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
        filter:(SimpleHttpClientFilterName)filterName
      priority:(NSOperationQueuePriority)priority
      delegate:(id)delegate
{
    [self
        requestWithMethod:SimpleHttpClientRequestMethodDELETE
                      url:url
               parameters:parameters
                  context:context
                   filter:filterName
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
    SimpleHttpClientOperation *operation = (SimpleHttpClientOperation *)object;

    if ([operation.delegate respondsToSelector:@selector(
        simpleHttpClient:didFinishOperation:
    )]) {
        [operation.delegate simpleHttpClient:self didFinishOperation:operation];
    }

    [operation removeObserver:self forKeyPath:keyPath];
}

@end

