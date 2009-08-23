#import <Foundation/Foundation.h>
#import "SimpleHttpClient.h"

@interface TestLivedoorReader : NSObject
{
    BOOL                is_loaded;
    NSString            *_apiKey;

    SimpleHttpClient    *_client;
    NSMutableData       *_data;
}

- (void)runTest;

@end
