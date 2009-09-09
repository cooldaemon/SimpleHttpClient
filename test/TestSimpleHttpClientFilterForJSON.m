#import "TestSimpleHttpClientFilterForJSON.h"
#import "SimpleHttpClientFilterForJSON.h"

@implementation TestSimpleHttpClientFilterForJSON

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)init
{
    if (![super init]) {
        return nil;
    }

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
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"start TestSimpleHttpClientFilterForJSON\n");
    @try {
        SimpleHttpClientFilterBase *filter = [
            [SimpleHttpClientFilterForJSON alloc] init
        ];

        NSData *jsonObject = [NSData
            dataWithBytes:"\n\t{\"foo\":\"bar\"}"
                   length:15
        ];

        NSDictionary *dict = (NSDictionary *)[filter apply:jsonObject];

        NSAssert1(
            [[dict objectForKey:@"foo"] isEqualToString:@"bar"],
            @"dict is %@.", dict
        );

        NSData *jsonArray = [NSData
            dataWithBytes:"\t \n[\"foo\", \"bar\"]"
                   length:17
        ];

        NSArray *array = (NSArray *)[filter apply:jsonArray];

        NSAssert1(
            [[array objectAtIndex:0] isEqualToString:@"foo"],
            @"array is %@.", array
        );
    }
    @catch (NSException *ex) {
        NSLog(@"Name  : %@\n", [ex name]);
        NSLog(@"Reason: %@\n", [ex reason]);
    }
    NSLog(@"end TestSimpleHttpClientFilterForJSON\n");

    [pool release];
}

@end
