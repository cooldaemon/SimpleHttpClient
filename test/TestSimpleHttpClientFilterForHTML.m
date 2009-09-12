#import "TestSimpleHttpClientFilterForHTML.h"
#import "SimpleHttpClientFilterForHTML.h"

@implementation TestSimpleHttpClientFilterForHTML

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)test
{
    SimpleHttpClientFilterBase *filter = [
        [SimpleHttpClientFilterForHTML alloc] init
    ];

    NSString *htmlString =
        @"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"\n"
        @"\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"
        @"<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"ja\" lang=\"ja\">\n"
        @"<body>\n"
        @"<ul id=\"menu\">\n"
        @"  <li>salad</li>\n"
        @"  <li>pizza</li>\n"
        @"  <li>beer</li>\n"
        @"</ul>\n"
        @"</body>\n"
        @"</html>\n"
        ;

    DDXMLDocument *htmlDocument = (DDXMLDocument *)[filter
        apply:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
    ];

    NSError *error;
    NSArray *menu = [htmlDocument nodesForXPath:@"id(\"menu\")/li" error:&error];

    NSAssert1(error == nil, @"error is %@", error);

    NSString *value = [[menu objectAtIndex:0] stringValue];
    NSAssert1([value isEqualToString:@"salad"], @"value is %@", value);
}

@end
