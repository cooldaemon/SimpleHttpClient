#import <objc/runtime.h>
#import "TestBase.h"

@implementation TestBase

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)init
{
    if (![super init]) {
        return nil;
    }

    _isFinish = NO;

    return self;
}

- (void)dealloc
{
    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)runTest
{
    Class myClass = [self class];
    const char *className = class_getName(myClass);

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"start %s\n", className);
    @try {
        [self test];
    }
    @catch (NSException *ex) {
        NSLog(@"Name  : %@\n", [ex name]);
        NSLog(@"Reason: %@\n", [ex reason]);
    }
    NSLog(@"end %s\n", className);

    [pool release];
}

- (void)test
{
}

- (void)setFinish
{
    _isFinish = YES;
}

- (void)waitFinish
{
    BOOL isRunning;
    do {
        isRunning = [[NSRunLoop currentRunLoop]
            runMode:NSDefaultRunLoopMode
            beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]
        ];
    } while (isRunning && !_isFinish);

    _isFinish = NO;
}

- (NSString *)getInputStreamWithPrompt:(NSString *)prompt
{
    NSFileHandle *output = [NSFileHandle fileHandleWithStandardOutput];
    NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];

    [output writeData:[NSData
        dataWithBytes:[prompt UTF8String]
               length:[prompt length]
    ]];

    NSMutableData *line = [NSMutableData dataWithData:[input availableData]];
    char *p = [line mutableBytes];
    p[[line length] - 1] = '\0';

    return [NSString stringWithUTF8String:[line bytes]];
}

@end
