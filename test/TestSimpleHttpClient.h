#import <Foundation/Foundation.h>
#import "SimpleHttpClient.h"

@interface TestSimpleHttpClient : NSObject
{
    BOOL                is_loaded;

    NSMutableDictionary *_isAllLoaded;
    NSMutableDictionary *_response;
    NSMutableDictionary *_data;
    NSMutableDictionary *_error;
}

- (void)runTest;

@end
