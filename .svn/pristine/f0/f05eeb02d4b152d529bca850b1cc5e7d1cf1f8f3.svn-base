//
//  OTSChachedImageView.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSChachedImageView : UIImageView
{
 @protected
    NSString*      url;
    UIImage* defaultImage;
}
@property(copy)             NSString*      url;
@property(nonatomic,retain) UIImage* defaultImage;
-(id)initWithFrame:(CGRect)aFrame url:(NSString*)aUrlString defaultImage:(UIImage*)aDefaultImage;
-(void)loadImage;
@end


@interface OTSProductImageView : OTSChachedImageView

@property(nonatomic, retain)NSNumber* prodctId;

-(id)initWithFrame:(CGRect)aFrame productId:(NSNumber*)aProductId defaultImage:(UIImage*)aDefaultImage;
@end