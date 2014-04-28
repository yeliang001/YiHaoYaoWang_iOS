//
//  OtsPadLoadingView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-9-6.
//
//

#import <UIKit/UIKit.h>

@interface OtsPadLoadingView : UIImageView
-(void)showInView:(UIView*)aView;
-(void)showInView:(UIView *)aView withFrame:(CGRect)frame;
-(void)hide;
@end