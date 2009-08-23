#import <Foundation/Foundation.h>

@interface TestHatenaBookmark : NSObject
{
    BOOL                is_loaded;

    NSMutableDictionary *_isAllLoaded;
    NSMutableDictionary *_response;
    NSMutableDictionary *_data;
    NSMutableDictionary *_error;
}

- (void)runTest;

@end
