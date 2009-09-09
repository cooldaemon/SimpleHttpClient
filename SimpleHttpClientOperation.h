#import <Foundation/Foundation.h>
#import "SimpleHttpClientFilterBase.h"

@interface SimpleHttpClientOperation : NSOperation {
    NSURLRequest               *_request;
    SimpleHttpClientFilterBase *_filter;
    void                       *_context;
    id                         _delegate;
    NSURLConnection            *_connection;
    NSMutableData              *_downloadData;
    BOOL                       _isExecuting, _isFinished;
}

@property (nonatomic, assign) void *context;
@property (nonatomic, assign, readonly) id delegate;

- (id)initWithRequest:(NSURLRequest *)request
               filter:(SimpleHttpClientFilterBase *)filter
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

- (void)simpleHttpClientOperationDidFinishLoading:(SimpleHttpClientOperation *)operation
                                     filteredData:(id)filteredData;

- (NSURLRequest *)simpleHttpClientOperation:(SimpleHttpClientOperation *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)response;

@end

