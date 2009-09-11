#import <Foundation/Foundation.h>

@interface TestBase : NSObject
{
    BOOL _isFinish;
}

- (id)init;

- (void)runTest;
- (void)test;
- (void)setFinish;
- (void)waitFinish;
- (NSString *)getInputStreamWithPrompt:(NSString *)prompt;

@end
