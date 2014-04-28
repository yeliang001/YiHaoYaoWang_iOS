//
//  UIColor+Common.h
//  HappyShare
//
//  Created by Lin Pan on 13-3-14.
//  Copyright (c) 2013年 Lin Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Common)


/**
 *	@brief	获取颜色对象
 *
 *	@param 	string 	颜色描述字符串，带“＃”开头
 *
 *	@return	颜色对象
 */
+ (UIColor *)colorWithString:(NSString *)string;

/**
 *	@brief	获取颜色对象
 *
 *	@param 	float R G B A
 *
 *	@return	颜色对象
 */
+ (UIColor *)colorWithR:(float)r G:(float)g B:(float)b A:(float)a;


@end
