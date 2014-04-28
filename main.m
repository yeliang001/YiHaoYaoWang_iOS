
//  main.m
//  TheStoreApp
//
//  Created by tianjsh on 11-2-15.
//  Copyright 2011 vsc. All rights reserved.
//


#import <UIKit/UIKit.h>
//#import "TheStoreAppAppDelegate.h"
int main(int argc, char *argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"TheStoreAppAppDelegate");
    [pool drain];
    return retVal;
}
