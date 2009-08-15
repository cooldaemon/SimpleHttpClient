#import <Foundation/Foundation.h>
#import "SimpleHttpClientOperation.h"

@interface TestSimpleHttpClientOperation : NSObject
{
    BOOL                is_loaded;
    NSOperationQueue    *_queue;

    NSHTTPURLResponse   *_response;
    NSMutableData       *_data;
    NSError             *_error;
}

- (void)runTest;

@end
