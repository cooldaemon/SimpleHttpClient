#import <Foundation/Foundation.h>
#import "TestLivedoorReader.h"
#import "SimpleHttpClient.h"

@interface TestLivedoorReaderJSON : TestLivedoorReader
{
    NSArray *_subs;
}

- (void)runTest;

@end
