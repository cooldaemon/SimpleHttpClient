#import <Foundation/Foundation.h>

@interface SimpleHttpClientOperation : NSOperation {
    NSURLRequest    *_request;
    void            *_context;
    id              _delegate;
    NSURLConnection *_connection;
    BOOL            _isExecuting, _isFinished;
}

@property (nonatomic, assign) void *context;
@property (nonatomic, assign, readonly) id delegate;

- (id)initWithRequest:(NSURLRequest *)request
              context:(void *)context
             delegate:(id)delegate;

- (void)stop;

@end

@interface NSObject (SimpleHttpClientOperationDelegate)

- (void)simpleHttpClientOperation:(SimpleHttpClientOperation *)operation
               didReceiveResponse:(NSHTTPURLResponse *)response;

- (void)simpleHttpClientOperation:(SimpleHttpClientOperation *)operation
    didReceiveData:(NSData *)data;

- (void)simpleHttpClientOperation:(SimpleHttpClientOperation *)operation
  didFailWithError:(NSError *)error;

- (void)simpleHttpClientOperationDidFinishLoading:(SimpleHttpClientOperation *)operation;

- (NSURLRequest *)simpleHttpClientOperation:(SimpleHttpClientOperation *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)response;

@end

