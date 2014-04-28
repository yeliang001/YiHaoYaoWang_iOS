//
//  StartupPicVO.h
//  TheStoreApp
//
//  Created by yuan jun on 13-4-16.
//
//
/*
 public class StartupPicVO implements Serializable {
 * 启动画面图片
 private String picUrl;
 * 开始时间
 private Date startDate;
 * 结束时间
 private Date endDate;
 }
 */

#import <Foundation/Foundation.h>
@interface StartupPicVO : NSObject{
    NSString* picUrl;
//    NSDate* startDate;
//    NSDate* endDate;
}
@property(nonatomic, retain)NSString* picUrl;
//@property(nonatomic, retain)NSDate* startDate;
//@property(nonatomic, retain)NSDate* endDate;


@end
