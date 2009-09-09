#import "TestSimpleHttpClientFilterForXML.h"
#import "SimpleHttpClientFilterForXML.h"

@implementation TestSimpleHttpClientFilterForXML

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

    NSLog(@"start TestSimpleHttpClientFilterForXML\n");
    @try {
        SimpleHttpClientFilterBase *filter = [
            [SimpleHttpClientFilterForXML alloc] init
        ];

        NSString *xmlString =
            @"<?xml version=\"1.0\"?>\n"
            @"<menu xmlns:a=\"tap\">\n"
            @"  <salad>\n"
            @"    <name>Ceasar</name>\n"
            @"    <price>1.99</price>\n"
            @"  </salad>\n"
            @"  <pizza>\n"
            @"    <name>Supreme</name>\n"
            @"    <price>9.99</price>\n"
            @"  </pizza>\n"
            @"  <pizza>\n"
            @"    <name>Three Cheese</name>\n"
            @"    <price>7.99</price>\n"
            @"  </pizza>\n"
            @"  <a:beer delicious=\"yes\"/>\n"
            @"</menu>"
            ;

        DDXMLDocument *xmlDocument = (DDXMLDocument *)[filter
            apply:[xmlString dataUsingEncoding:NSUTF8StringEncoding]
        ];

        NSError *error;
        NSArray *salad = [xmlDocument nodesForXPath:@"/menu/salad[1]" error:&error];

        NSAssert1(error == nil, @"error is %@", error);

        NSString *value = [[
            [[salad objectAtIndex:0] elementsForName:@"name"] objectAtIndex:0
        ] stringValue];

        NSAssert1([value isEqualToString:@"Ceasar"], @"value is %@", value);
    }
    @catch (NSException *ex) {
        NSLog(@"Name  : %@\n", [ex name]);
        NSLog(@"Reason: %@\n", [ex reason]);
    }
    NSLog(@"end TestSimpleHttpClientFilterForXML\n");

    [pool release];
}

@end
