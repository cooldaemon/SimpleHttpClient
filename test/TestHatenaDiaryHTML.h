#import <Foundation/Foundation.h>
#import "TestBase.h"
#import "SimpleHttpClient.h"

@interface TestHatenaDiaryHTML : TestBase {
    NSHTTPURLResponse   *_response;
    NSError             *_error;
    DDXMLDocument       *_html;
}

- (void)test;

@end
