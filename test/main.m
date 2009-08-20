#import "TestSimpleHttpClientRequest.h"
#import "TestSimpleHttpClientOperation.h"
#import "TestSimpleHttpClient.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    TestSimpleHttpClientRequest *test_request
        = [[TestSimpleHttpClientRequest alloc] init];
    [test_request runTest];
    [test_request release];

    TestSimpleHttpClientOperation *test_operation
        = [[TestSimpleHttpClientOperation alloc] init];
    [test_operation runTest];
    [test_operation release];

    TestSimpleHttpClient *test_client
        = [[TestSimpleHttpClient alloc] init];
    [test_client runTest];
    [test_client release];

    [pool release];
    return 0;
}

