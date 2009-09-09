#import "TestEncodingBase64.h"
#import "TestEncodingSHA1.h"
#import "TestEncodingURL.h"
#import "TestSimpleHttpClientFilterForJSON.h"
#import "TestSimpleHttpClientFilterForXML.h"
#import "TestSimpleHttpClientFilter.h"
#import "TestSimpleHttpClientWSSE.h"
#import "TestSimpleHttpClientRequest.h"
#import "TestSimpleHttpClientOperation.h"
#import "TestSimpleHttpClient.h"
#import "TestHatenaBookmark.h"
#import "TestHatenaBookmarkXML.h"
#import "TestLivedoorReader.h"
#import "TestLivedoorReaderJSON.h"

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

    TestSimpleHttpClientFilterForJSON *test_json
        = [[TestSimpleHttpClientFilterForJSON alloc] init];
    [test_json runTest];
    [test_json release];

    TestSimpleHttpClientFilterForXML *test_xml
        = [[TestSimpleHttpClientFilterForXML alloc] init];
    [test_xml runTest];
    [test_xml release];

    TestSimpleHttpClientFilter *test_filter
        = [[TestSimpleHttpClientFilter alloc] init];
    [test_filter runTest];
    [test_filter release];

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

    TestHatenaBookmarkXML *test_hb_xml = [[TestHatenaBookmarkXML alloc] init];
    [test_hb_xml runTest];
    [test_hb_xml release];

    TestLivedoorReader *test_ldr = [[TestLivedoorReader alloc] init];
    [test_ldr runTest];
    [test_ldr release];

    TestLivedoorReaderJSON *test_ldr_json
        = [[TestLivedoorReaderJSON alloc] init];
    [test_ldr_json runTest];
    [test_ldr_json release];

    [pool release];
    return 0;
}

