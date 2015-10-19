//
//  SubscribeManager.m
//  17173_V2.0
//
//  Created by 刘 翔 on 14-4-18.
//  Copyright (c) 2014年 cyou. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDB.h"
#import "AddressModel.h"
@interface DatabaseManager ()
{
    FMDatabase *_db;
}

@end

@implementation DatabaseManager

+ (DatabaseManager*)sharedDatabaseManager
{
	static DatabaseManager *shareInstance = nil;
	static dispatch_once_t onceToken;
    
	dispatch_once(&onceToken, ^{
		shareInstance=[[DatabaseManager alloc] init];
	});
	return shareInstance;
}

//- (BOOL)setAddress:(AddressModel *)address
//{
//    //插入的数据为空，直接返回失败
//    if(!address)
//        return NO;
//    
//    //打开数据库，如果没有打开，直接返回
//    if(![self openDatabase])
//        return NO;
//    
//    //无表则先创建表
//    if(![_db tableExists:@"address"])
//    {
//        if(![self creatSubscribeTable])
//            return NO;
//    }
//    
//    //已订阅的攻略才可置顶，只需更新订阅表
//    BOOL isExecuteSuccess = [_db executeUpdate:@"update subscribe set topState = ? , topDate = ? where strategyID = ?", [NSNumber numberWithBool:isTop], (isTop ? _S(@"%f",[[NSDate date] timeIntervalSince1970]) : @"0"), [NSString stringWithFormat:@"%i",strategy.ID]];
//    
//    [self closeDatabase];
//    
//    return isExecuteSuccess;
//}


- (NSString *)databaseFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [filePath objectAtIndex:0];
    NSLog(@"%@",filePath);
    NSString *dbFilePath = [cachePath stringByAppendingPathComponent:@"db.sqlite"];
    return dbFilePath;
}

- (void)creatDatabase
{
    _db = [[FMDatabase alloc] initWithPath:[self databaseFilePath]];
    
//    //为数据库设置缓存，提高查询效率
//    [_db setShouldCacheStatements:YES];
}

- (BOOL)openDatabase
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!_db)
    {
        [self creatDatabase];
    }
    
    BOOL isOpenSuccess = [_db open];
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (!isOpenSuccess)
    {
        NSLog(@"数据库打开失败");
    }
    
    return isOpenSuccess;
}

//- (void)closeDatabase
//{
////    [_db closeOpenResultSets];
//}

- (BOOL)closeDatabase
{
    [_db closeOpenResultSets];

    BOOL isCloseSuccess = [_db close];
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (!isCloseSuccess)
    {
        NSLog(@"数据库关闭失败");
    }
    
    return isCloseSuccess;
}

- (BOOL)creatAddressTable
{
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![_db tableExists:@"address"])
    {
        BOOL creatSuccess = [_db executeUpdate:@"CREATE TABLE address (id INTEGER PRIMARY KEY,name TEXT,phone TEXT,code TEXT,city TEXT,address TEXT,mts TIMESTAMP)"];
        
        if(!creatSuccess)
        {
            NSLog(@"表完成");
        }
        return creatSuccess;
    }
    
    //已存在此表
    return YES;
}

#pragma mark - Subscribe Strategy

- (BOOL)insertAddress:(AddressModel *)address
{
    //插入的数据为空，直接返回失败
    if(!address)
        return NO;
    
    //打开数据库，如果没有打开，直接返回
    if(![self openDatabase])
        return NO;
    
    //无表则先创建表
    if(![_db tableExists:@"address"])
    {
        if(![self creatAddressTable])
            return NO;
    }
    
//    //先在表中查询有没有相同的元素，如果有，做修改操作
//    FMResultSet *rs = [_db executeQuery:@"select * from address where id = ?", [NSString stringWithFormat:@"%i",strategy.ID]];
    
    BOOL isExecuteSuccess = NO;
    
    //(id INTEGER PRIMARY KEY, name TEXT, gamecode INTEGER, isRecommend BOOLEAN, actualSub INTEGER, externalSub INTEGER, sort TEXT, type INTEGER, alias TEXT, liveUrl TEXT, menuStyle TEXT, bgIconUrl TEXT, iconUrl TEXT, channel TEXT, introduce TEXT, mts TIMESTAMP)
    
//    if([rs next])
//    {
//        isExecuteSuccess = [self updateStrategyInfo:strategy];
//    }
    //向数据库中插入一条数据
//    else
//    {
        isExecuteSuccess = [_db executeUpdate:@"INSERT INTO address (name,phone,code,city,address,mts) VALUES (?,?,?,?,?,?)", address.name, address.phone, address.code,address.city,address.address,[NSString stringWithFormat:@"%f",address.mts]];
//    }
    
    [self closeDatabase];
    
    return isExecuteSuccess;
}


#pragma mark -

- (NSArray *)getAllAddress
{
    //打开数据库，如果没有打开，直接返回
    if(![self openDatabase])
        return nil;
    
    if(![_db tableExists:@"address"] || ![_db tableExists:@"address"])
    {
        return nil;
    }
    
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *strategyArray = [NSMutableArray array];
    //定义一个结果集，存放查询的数据
    FMResultSet *rs = [_db executeQuery:@"SELECT * from address ORDER BY mts DESC"];
    
    //@"SELECT * from subscribe inner join strategy on subscribe.strategyID=strategy.id WHERE subscribe.subscribeState = 1 ORDER BY subscribe.topState DESC, subscribe.topDate DESC,subscribe.subscribeDate ASC"
    
    //判断结果集中是否有数据，如果有则取出数据
    while ([rs next])
    {
        AddressModel *address = [[AddressModel alloc] setValuesForKeysWithDictionary:[rs resultDictionary]];
    
        //将查询到的数据放入数组中。 
        [strategyArray addObject:address];
//        RELEASE_SAFE(strategy);
    }
    
    [self closeDatabase];
    
    return strategyArray;
}



@end
