#import "TestEncodingBase64.h"
#import "TestEncodingSHA1.h"
#import "TestEncodingURL.h"
#import "TestSimpleHttpClientWSSE.h"
#import "TestSimpleHttpClientRequest.h"
#import "TestSimpleHttpClientOperation.h"
#import "TestSimpleHttpClient.h"
#import "TestHatenaBookmark.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    TestEncodingBase64 *test_base64 = [[TestEncodingBase64 alloc] init];
    [test_base64 runTest];
    [test_base64 release];

    TestEncodingSHA1 *test_sha1 = [[TestEncodingSHA1 alloc] init];
    [test_sha1 runTest];
    [test_sha1 release];

    TestEncodingURL *test_url = [[TestEncodingURL alloc] init];
    [test_url runTest];
    [test_url release];

    TestSimpleHttpClientWSSE *test_wsse
        = [[TestSimpleHttpClientWSSE alloc] init];
    [test_wsse runTest];
    [test_wsse release];

    TestSimpleHttpClientRequest *test_request
        = [[TestSimpleHttpClientRequest alloc] init];
    [test_request runTest];
    [test_request release];

    TestSimpleHttpClientOperation *test_operation
        = [[TestSimpleHttpClientOperation alloc] init];
    [test_operation runTest];
    [test_operation release];

    TestSimpleHttpClient *test_client = [[TestSimpleHttpClient alloc] init];
    [test_client runTest];
    [test_client release];

    TestHatenaBookmark *test_hb = [[TestHatenaBookmark alloc] init];
    [test_hb runTest];
    [test_hb release];

    [pool release];
    return 0;
}

