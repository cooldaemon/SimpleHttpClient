#import "TestSimpleHttpClientFilterForXML.h"
#import "SimpleHttpClientFilterForXML.h"

@implementation TestSimpleHttpClientFilterForXML

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)test
{
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

@end
