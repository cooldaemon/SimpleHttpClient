#import <Foundation/Foundation.h>
#import "SimpleHttpClientOperation.h"
#import "SimpleHttpClientWSSE.h"
#import "SimpleHttpClientFilter.h"

@interface SimpleHttpClient : NSObject {
    NSOperationQueue       *_queue;
    NSTimeInterval         _timeout;
    NSString               *_userAgent;
    SimpleHttpClientWSSE   *_wsse;
    SimpleHttpClientFilter *_filter;
    id                     _delegate;
}

@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, retain) NSString       *userAgent;

- (id)initWithOperationQueue:(NSOperationQueue *)queue delegate:(id)delegate;
- (id)initWithDelegate:(id)delegate;
- (id)initWithMaxConnection:(NSInteger)maxConnection delegate:(id)delegate;

- (void)setCredentialForHost:(NSString *)host
                    username:(NSString *)username
                    password:(NSString *)password;
- (void)removeCredentialForHost:(NSString *)host;

- (void)setFilter:(SimpleHttpClientFilterName)filterName
          forHost:(NSString *)host;
- (void)removeFilterForHost:(NSString *)host;

- (void)cancel;
- (NSArray *)operations;

#pragma mark -- GET methods --

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context;

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName;

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
   priority:(NSOperationQueuePriority)priority;

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
   delegate:(id)delegate;

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   priority:(NSOperationQueuePriority)priority;

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   delegate:(id)delegate;

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate;

- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate;

#pragma mark -- POST methods --

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context;

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName;

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
    priority:(NSOperationQueuePriority)priority;

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
    delegate:(id)delegate;

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
    priority:(NSOperationQueuePriority)priority;

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
    delegate:(id)delegate;

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
    priority:(NSOperationQueuePriority)priority
    delegate:(id)delegate;

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
    priority:(NSOperationQueuePriority)priority
    delegate:(id)delegate;

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context;

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName;

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
    priority:(NSOperationQueuePriority)priority;

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
    delegate:(id)delegate;

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
    priority:(NSOperationQueuePriority)priority;

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
    delegate:(id)delegate;

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
    priority:(NSOperationQueuePriority)priority
    delegate:(id)delegate;

- (void)post:(NSString *)url
     headers:(NSDictionary *)headers
        body:(NSString *)body
     context:(void *)context
      filter:(SimpleHttpClientFilterName)filterName
    priority:(NSOperationQueuePriority)priority
    delegate:(id)delegate;

#pragma mark -- PUT methods --

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context;

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName;

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
   priority:(NSOperationQueuePriority)priority;

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
   delegate:(id)delegate;

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   priority:(NSOperationQueuePriority)priority;

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   delegate:(id)delegate;

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate;

- (void)put:(NSString *)url
 parameters:(NSDictionary *)parameters
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate;

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context;

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName;

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
   priority:(NSOperationQueuePriority)priority;

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
   delegate:(id)delegate;

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   priority:(NSOperationQueuePriority)priority;

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   delegate:(id)delegate;

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate;

- (void)put:(NSString *)url
    headers:(NSDictionary *)headers
       body:(NSString *)body
    context:(void *)context
     filter:(SimpleHttpClientFilterName)filterName
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate;

#pragma mark -- DELETE methods --

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context;

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
        filter:(SimpleHttpClientFilterName)filterName;

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
      priority:(NSOperationQueuePriority)priority;

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
      delegate:(id)delegate;

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
        filter:(SimpleHttpClientFilterName)filterName
      priority:(NSOperationQueuePriority)priority;

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
        filter:(SimpleHttpClientFilterName)filterName
      delegate:(id)delegate;

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
      priority:(NSOperationQueuePriority)priority
      delegate:(id)delegate;

- (void)delete:(NSString *)url
    parameters:(NSDictionary *)parameters
       context:(void *)context
        filter:(SimpleHttpClientFilterName)filterName
      priority:(NSOperationQueuePriority)priority
      delegate:(id)delegate;

@end

@interface NSObject (SimpleHttpClientDelegate)

- (void)simpleHttpClient:(SimpleHttpClient *)client
      didFinishOperation:(SimpleHttpClientOperation *)operation;

@end

