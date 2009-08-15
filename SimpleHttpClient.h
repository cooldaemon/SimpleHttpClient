#import <Foundation/Foundation.h>
#import "SimpleHttpClientOperation.h"

@interface SimpleHttpClient : NSObject {
    NSOperationQueue    *_queue;
    NSTimeInterval      _timeout;
    NSString            *_userAgent;
    id                  _delegate;
}

@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, retain) NSString       *userAgent;

- (id)initWithDelegate:(id)delegate;
- (id)initWithMaxConnection:(NSInteger)maxConnection delegate:(id)delegate;

- (void)cancel;

- (void)get:(NSString *)url
 parameters:(NSDictionary *)params
    context:(void *)context;

- (void)get:(NSString *)url
 parameters:(NSDictionary *)params
    context:(void *)context
   priority:(NSOperationQueuePriority)priority;

- (void)get:(NSString *)url
 parameters:(NSDictionary *)params
    context:(void *)context
   delegate:(id)delegate;

- (void)get:(NSString *)url
 parameters:(NSDictionary *)params
    context:(void *)context
   priority:(NSOperationQueuePriority)priority
   delegate:(id)delegate;

- (void)post:(NSString *)url
  parameters:(NSDictionary *)params
     context:(void *)context;

- (void)post:(NSString *)url
  parameters:(NSDictionary *)params
     context:(void *)context
    priority:(NSOperationQueuePriority)priority;

- (void)post:(NSString *)url
  parameters:(NSDictionary *)params
     context:(void *)context
    delegate:(id)delegate;

- (void)post:(NSString *)url
  parameters:(NSDictionary *)params
     context:(void *)context
    priority:(NSOperationQueuePriority)priority
    delegate:(id)delegate;

@end

@interface NSObject (SimpleHttpClientDelegate)

- (void)simpleHttpClient:(SimpleHttpClient *)client
      didFinishOperation:(SimpleHttpClientOperation *)operation;

@end

