//
//  OTSAddFavTipView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-22.
//
//

#import <UIKit/UIKit.h>

@interface OTSAddFavTipView : UIView
@property (retain, nonatomic) IBOutlet UILabel *textLabel;


-(void)showAboveView:(UIView *)aView text:(NSString*)aText;
@end
