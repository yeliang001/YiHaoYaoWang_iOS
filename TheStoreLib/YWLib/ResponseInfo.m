//
//  ResponseInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-7-16.
//
//

#import "ResponseInfo.h"

@implementation ResponseInfo

- (id)initWithSuccessfulStatus:(BOOL)isSuccessful
                    statusCode:(int)code
                        userId:(NSString *)aUserId
                   description:(NSString *)desc
                          data:(id)aData
{
    self = [super init];
    if (self)
    {
        _isSuccessful = isSuccessful;
        _statusCode = code;
        self.userId = aUserId;
        self.desc = desc;
        self.data = aData;
    }
    return self;
}

- (void)dealloc
{
    [_desc release];
    [_userId release];
    [super dealloc];
}

- (NSString *)description
{
   DebugLog(@"\nisSuccessful: %d,\nstatusCode: %d,\nusedid: %@,\ndescription: %@,\ndata: %@",_isSuccessful,_statusCode,_userId, _desc,_data);
   return nil;
}
@end
