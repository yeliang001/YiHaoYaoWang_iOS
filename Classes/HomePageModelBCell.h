//
//  HomePageModelBCell.h
//  TheStoreApp
//
//  Created by yuan jun on 13-1-15.
//
//

#import <UIKit/UIKit.h>

@interface HomePageModelBCell : UITableViewCell
{
    NSString*advPicUrl;
    NSString*adText;
    UIImageView* advImg;
    UILabel* advLab;
}
@property(nonatomic,retain)NSString*advPicUrl;
@property(nonatomic,retain)NSString*adText;
-(void)reloadCell;
@end
