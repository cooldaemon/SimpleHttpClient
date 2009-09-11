#import <Foundation/Foundation.h>
#import "TestBase.h"
#import "SimpleHttpClient.h"

@interface TestLivedoorReader : TestBase
{
    NSString            *_apiKey;
    SimpleHttpClient    *_client;
    NSMutableData       *_data;
}

- (void)test;

- (void)sendLoginRequest;
- (void)assertLogin;

@end
