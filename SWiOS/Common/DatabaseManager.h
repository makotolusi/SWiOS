//
//  SubscribeManager.h
//  17173_V2.0
//
//  Created by 刘 翔 on 14-4-18.
//  Copyright (c) 2014年 cyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"
#import "FMDatabase.h"
/**
 订阅管理
 */
@interface DatabaseManager : NSObject
//
/**
 返回全局公用的SubscribeManager对象
 */
+ (DatabaseManager *)sharedDatabaseManager;
- (BOOL)insertAddress:(AddressModel *)address;
- (NSArray *)getAllAddress;
- (AddressModel *)getAddressByID:(NSInteger)AddressModelID;
- (BOOL)deleteAddressByID:(NSInteger)AddressModelID;


- (BOOL)tableExists:(NSString *)tableName;

- (BOOL)createTableWithName:(NSString*)tableName createSql:(NSString*)createSql;

- (BOOL)exWithName:(NSString *)tableName sql:(NSString*)sql param:(NSArray*)param;

-(NSMutableArray *)getAllwithName:(NSString*)tableName sql:(NSString*)sql;

- (BOOL)openDatabase;

- (BOOL)closeDatabase;

- (FMDatabase*)getDB;


-(BOOL)deleteWithName:(NSString*)tableName byId:(int)objId;

- (BOOL)dropTablesWithName:(NSString*)tableName;
@end
