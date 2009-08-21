#import <Foundation/Foundation.h>

enum {
    SimpleHttpClientRequestMethodGET    = 0,
    SimpleHttpClientRequestMethodPOST   = 1,
    SimpleHttpClientRequestMethodPUT    = 2,
    SimpleHttpClientRequestMethodDELETE = 3
};
typedef NSUInteger SimpleHttpClientRequestMethod;

@interface SimpleHttpClientRequest : NSObject {
    NSMutableURLRequest *_request;
}

@property (nonatomic, assign, readonly) NSMutableURLRequest *request;

- (id)initWithMethod:(SimpleHttpClientRequestMethod)method
                 url:(NSString *)url
          parameters:(NSDictionary *)parameters
           userAgent:(NSString *)userAgent
             timeout:(NSTimeInterval)timeout;

- (id)initWithMethod:(SimpleHttpClientRequestMethod)method
                 url:(NSString *)url
             headers:(NSDictionary *)headers
                body:(NSString *)body
           userAgent:(NSString *)userAgent
             timeout:(NSTimeInterval)timeout;

@end

