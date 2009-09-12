#import <Foundation/Foundation.h>
#import "TestBase.h"
#import "TestEncodingBase64.h"
#import "TestEncodingSHA1.h"
#import "TestEncodingURL.h"
#import "TestSimpleHttpClientFilterForJSON.h"
#import "TestSimpleHttpClientFilterForXML.h"
#import "TestSimpleHttpClientFilterForHTML.h"
#import "TestSimpleHttpClientFilter.h"
#import "TestSimpleHttpClientWSSE.h"
#import "TestSimpleHttpClientRequest.h"
#import "TestSimpleHttpClientOperation.h"
#import "TestSimpleHttpClient.h"
#import "TestHatenaBookmark.h"
#import "TestHatenaBookmarkXML.h"
#import "TestLivedoorReader.h"
#import "TestLivedoorReaderJSON.h"
#import "TestHatenaDiaryHTML.h"

void runTest(NSString *className) {
    Class TestClass = NSClassFromString([@"Test"
        stringByAppendingString:className
    ]);

    TestBase *test = [[TestClass alloc] init];
    [test runTest];
    [test release];
}

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSArray *classNames = [NSArray arrayWithObjects:
        @"EncodingBase64",
        @"EncodingSHA1",
        @"EncodingURL",

        @"SimpleHttpClientFilterForJSON",
        @"SimpleHttpClientFilterForXML",
        @"SimpleHttpClientFilterForHTML",
        @"SimpleHttpClientFilter",

        @"SimpleHttpClientWSSE",

        @"SimpleHttpClientRequest",
        @"SimpleHttpClientOperation",
        @"SimpleHttpClient",

        @"HatenaBookmark",
        @"HatenaBookmarkXML",

        @"LivedoorReader",
        @"LivedoorReaderJSON",

        @"HatenaDiaryHTML",

        nil
    ];

    NSEnumerator *classNameEnum = [classNames objectEnumerator];
    NSString *className;
    while (className = [classNameEnum nextObject]) {
        runTest(className);
    }

    [pool release];
    return 0;
}

