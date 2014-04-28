//
//  OTSTableViewDelegate.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  描述：用以简化table delegate和datesource

#import <UIKit/UIKit.h>

@protocol OTSTableViewDelegate <UITableViewDelegate, UITableViewDataSource>

@required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@optional
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
