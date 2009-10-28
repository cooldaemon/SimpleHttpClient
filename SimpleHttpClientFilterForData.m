#import "SimpleHttpClientFilterForData.h"

@implementation SimpleHttpClientFilterForData

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (id)apply:(NSData *)data
{
    return data;
}

@end
