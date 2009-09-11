#import <Foundation/Foundation.h>
#import "TestBase.h"

@interface TestSimpleHttpClientOperation : TestBase
{
    NSOperationQueue    *_queue;

    NSHTTPURLResponse   *_response;
    NSMutableData       *_data;
    NSError             *_error;
}

- (void)test;

@end
