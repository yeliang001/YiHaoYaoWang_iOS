//
//  Sqlite3Delegate.h
//  TheStoreApp
//
//  Created by towne on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#define kDataBase @"sqlite3db.sqlite3"

@class FMDatabase;

@interface Sqlite3Handle : NSObject

@property(readonly)FMDatabase* database;

+ (Sqlite3Handle *) sharedInstance;
- (BOOL) openDB;
- (void) closeDB;
-(NSString*) dbPath;
@end
