#import <Foundation/Foundation.h>
#import "TestBase.h"

@interface TestHatenaBookmark : TestBase
{
    NSMutableDictionary *_isAllLoaded;
    NSMutableDictionary *_response;
    NSMutableDictionary *_data;
    NSMutableDictionary *_error;
}

- (void)test;

@end
