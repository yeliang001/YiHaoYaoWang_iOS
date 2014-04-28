//
//  SiteTypeVO.h
//  TheStoreApp
//
//  Created by xuexiang on 12-11-30.
//
//

#import <Foundation/Foundation.h>

@interface SiteTypeVO : NSObject{
    NSNumber* serialVersionUID;
    NSNumber* nid;
	NSString* name;

}
@property(nonatomic, retain)NSNumber* nid;
@property(nonatomic, retain)NSString* name;
@property(nonatomic, retain)NSNumber* serialVersionUID;
@end
