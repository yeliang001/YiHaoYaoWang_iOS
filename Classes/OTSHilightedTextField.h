//
//  OTSHilightedTextField.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTSHilightedTextField : UITextField
{
    UIImageView* bgImageView;
}
-(id)initWithFrame:(CGRect)frame placeholder:(NSString*)aPlaceHolder;
-(void)makeFocus:(BOOL)aIsFocus;
@end
