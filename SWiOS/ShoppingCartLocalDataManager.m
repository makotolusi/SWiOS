//
//  ShoppingCartLocalDataManager.m
//  SWiOS
//
//  Created by 陆思 on 15/12/3.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import "ShoppingCartLocalDataManager.h"
#import "DatabaseManager.h"
#import "FMDB.h"
#import "ActivityProduct.h"
#import "OrderModel.h"
@implementation ShoppingCartLocalDataManager

+ (BOOL)creatShoppingCartTable
{
    DatabaseManager* dataBaseManager=[DatabaseManager sharedDatabaseManager];
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    return [dataBaseManager createTableWithName:@"shoppingcart" createSql:@"CREATE TABLE shoppingcart (id INTEGER PRIMARY KEY,activityId INTEGER,productCode TEXT,productName TEXT,rushPrice REAL,rushQuantity INTEGER,picUrl1 TEXT,buyCount INTEGER, mts TimeStamp NOT NULL DEFAULT CURRENT_TIMESTAMP)"];
}

+ (BOOL)creatOrderModelTable
{
    DatabaseManager* dataBaseManager=[DatabaseManager sharedDatabaseManager];
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    return [dataBaseManager createTableWithName:@"ordermodel" createSql:@"CREATE TABLE ordermodel (id INTEGER PRIMARY KEY,totalPrice REAL,totalCount INTEGER, mts TimeStamp NOT NULL DEFAULT CURRENT_TIMESTAMP)"];
}

+ (BOOL)insertShoppingCart:(ActivityProduct*)product
{
    DatabaseManager* dataBaseManager=[DatabaseManager sharedDatabaseManager];
    if (![dataBaseManager tableExists:@"shoppingcart"]) {
        if (![self creatShoppingCartTable]) {
            return NO;
        }
    }
    //打开数据库，如果没有打开，直接返回
    if(![dataBaseManager openDatabase])
        return NO;
    
    
    BOOL isExecuteSuccess = NO;
    //    va_list args;
    //    va_start(args, sql);
    FMDatabase *db=[dataBaseManager getDB];
//    double time=[[NSDate date] timeIntervalSince1970]*1000;
    if (product.id) {
        isExecuteSuccess = [db executeUpdate:@"update shoppingcart set activityId=?,productCode=?,productName=?,rushPrice=?,rushQuantity=?,picUrl1=?,buyCount=? where id = ?",product.activityId,product.productCode,product.productName,product.rushPrice,[[NSNumber alloc] initWithInt:product.rushQuantity],product.picUrl1,product.buyCount,product.id];
    }else{
    isExecuteSuccess = [db executeUpdate:@"insert into shoppingcart (activityId,productCode,productName,rushPrice,rushQuantity,picUrl1,buyCount,mts) values(?,?,?,?,?,?,?,datetime('now'))",product.activityId,product.productCode,product.productName,product.rushPrice,[[NSNumber alloc] initWithInt:product.rushQuantity],product.picUrl1,product.buyCount];
    product.id=[[NSNumber alloc] initWithInt:[db lastInsertRowId]];
    }
    [dataBaseManager closeDatabase];
    return isExecuteSuccess;
}



+ (NSMutableArray*)getAllShoppingCart
{
    DatabaseManager* dataBaseManager=[DatabaseManager sharedDatabaseManager];
    NSMutableArray *array =[dataBaseManager getAllwithName:@"shoppingcart" sql:@"SELECT * from shoppingcart ORDER BY mts asc"];
    NSMutableArray *result=[[NSMutableArray alloc] init];
    for (NSDictionary* dic in array) {
        ActivityProduct *ap = [[ActivityProduct alloc] initWithDictionary:dic error:nil];
        [result addObject:ap];
    }
    return result;
}

+ (BOOL)deleteShoppingCartById:(int)objId
{
    DatabaseManager* dataBaseManager=[DatabaseManager sharedDatabaseManager];
    return [dataBaseManager deleteWithName:@"shoppingcart" byId:objId ];
}

+ (BOOL)insertOrderModel:(OrderModel*)order
{
    DatabaseManager* dataBaseManager=[DatabaseManager sharedDatabaseManager];
    if (![dataBaseManager tableExists:@"ordermodel"]) {
        if (![self creatOrderModelTable]) {
            return NO;
        }
    }
    //打开数据库，如果没有打开，直接返回
    if(![dataBaseManager openDatabase])
        return NO;
    
    
    BOOL isExecuteSuccess = NO;
    //    va_list args;
    //    va_start(args, sql);
    FMDatabase *db=[dataBaseManager getDB];

    if (order.id) {
         isExecuteSuccess = [db executeUpdate:@"update ordermodel set totalPrice=?,totalCount=? where id= ?",order.totalPrice,[[NSNumber alloc] initWithInt:order.totalCount],[[NSNumber alloc] initWithInt:order.id.intValue]];
    }else{
        isExecuteSuccess = [db executeUpdate:@"insert into ordermodel(totalPrice,totalCount) values(?,?)",order.totalPrice,[[NSNumber alloc] initWithInt:order.totalCount]];
        order.id=[[NSNumber alloc] initWithInt:[db lastInsertRowId]];
    }
    
    
    [dataBaseManager closeDatabase];
    return isExecuteSuccess;
}

+ (OrderModel*)getAllOrderModel
{
    DatabaseManager* dataBaseManager=[DatabaseManager sharedDatabaseManager];
    NSMutableArray *array =[dataBaseManager getAllwithName:@"ordermodel" sql:@"SELECT * from ordermodel ORDER BY mts DESC"];
    if (array&&[array count]>0) {
        OrderModel *ap = [[OrderModel alloc] init];
        NSDictionary* dic=array[0];
        NSString* a=dic[@"totalCount"];
        NSString* b=dic[@"totalPrice"];
        NSString* c=dic[@"id"];
        ap.totalCount=a.intValue;
        ap.id=[[NSNumber alloc] initWithInt:c.intValue];
        ap.totalPrice=[[NSNumber alloc] initWithInt:b.intValue];
        NSLog(@"%ld %ld",ap.totalPrice.intValue,ap.totalCount);
        return ap;
    }
    else
        return nil;
}

@end
