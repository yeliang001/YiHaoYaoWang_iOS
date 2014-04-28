//
//  main.m
//  iPadTarget
//
//  Created by Yim Daniel on 12-9-4.
//
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

//int main(int argc, char *argv[])
//{
//    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//    }
//}

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    int retVal = 0;
    
    @try
    {
        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    @catch(NSException* e)
    {
        NSLog(@"捕获到一个异常！");
        NSLog(@"名称: %@", [e name]);
        NSLog(@"原因: %@", [e reason]);
        NSLog(@"用户信息: %@", [e userInfo]);
        NSLog(@"调用栈: %@", [e callStackSymbols]);
        NSLog(@"程序即将关闭...");
        @throw;
    }
    
    
    [pool drain];
    return retVal;
}
