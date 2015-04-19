//
//  ViewController.m
//  SQLite3Demo
//
//  Created by Tomson on 15-4-16.
//  Copyright (c) 2015年 Org.CTIL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [paths objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:@"Contacts.sqlite"];
}

- (void)insertRecordIntoTableName:(NSString *)tableName withField1:(NSString *)field1 field1Value:(NSString *)field1Value andField2:(NSString *)field2 field2Value:(NSString *)field2Value andField3:(NSString *)field3 field3Value:(NSString *)field3Value {
    //方法1：经典方法
    NSString *sql_classic = [NSString stringWithFormat:@"insert into '%@'('%@','%@','%@') values('%@','%@','%@')", tableName, field1, field2, field3, field1Value, field2Value, field3Value];
    char *err;
    if (sqlite3_exec(db, [sql_classic UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"插入数据错误！");
    }
    
    //方法2：变量的绑定方法
    NSString *sql_bind = [NSString stringWithFormat:@"insert into '%@'('%@', '%@', '%@') values (? ,?, ?)", tableName, field1,field2, field3];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sql_bind UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [field1Value UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 2, [field1Value UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 3, [field1Value UTF8String], -1, NULL);
    }
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSAssert(0, @"插入数据失败！");
        sqlite3_finalize(statement);
    }
}

- (void)getAllContacts {
    NSString *sql = @"select * from members";
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char *)sqlite3_column_text(statement, 1);
            NSString *nameStr = [[NSString alloc] initWithUTF8String: name];
            
            char *email = (char *)sqlite3_column_text(statement, 2);
            NSString *emailStr = [[NSString alloc] initWithUTF8String: email];
            
            char *birthday = (char *)sqlite3_column_text(statement, 3);
            NSString *birthdayStr = [[NSString alloc] initWithUTF8String: birthday];
            
            NSString *info = [[NSString alloc] initWithFormat:@"%@ - %@ - %@" , nameStr, emailStr, birthdayStr];
            
            NSLog(info);
        }
        sqlite3_finalize(statement);
    }
}

- (void)openDB{
    
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"数据库库打开失败");
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self openDB];
    
    [self insertRecordIntoTableName:@"members" withField1:@"name" field1Value:@"韩1" andField2:@"email" field2Value:@"hankuikuide@163.com" andField3:@"birthday" field3Value:@"2011-1-1"];
    
    [self insertRecordIntoTableName:@"members" withField1:@"name" field1Value:@"韩2" andField2:@"email" field2Value:@"hankuikuide@163.com" andField3:@"birthday" field3Value:@"2011-1-1"];
    
    [self insertRecordIntoTableName:@"members" withField1:@"name" field1Value:@"韩3" andField2:@"email" field2Value:@"hankuikuide@163.com" andField3:@"birthday" field3Value:@"2011-1-1"];
    
    [self getAllContacts];
    
    sqlite3_close(db);
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
