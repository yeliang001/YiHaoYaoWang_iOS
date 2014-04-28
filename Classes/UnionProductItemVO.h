//
//  UnionProductItemVO.h
//  TheStoreApp
//
//  Created by yuan jun on 13-5-15.
//
//

#import <Foundation/Foundation.h>

@interface UnionProductItemVO : NSObject{
    NSNumber* productId;
    NSNumber* num;
}
@property(nonatomic,retain)    NSNumber* productId;
@property(nonatomic,retain)   NSNumber* num;
-(NSString*)toXML;
@end
