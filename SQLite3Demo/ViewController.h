//
//  ViewController.h
//  SQLite3Demo
//
//  Created by Tomson on 15-4-16.
//  Copyright (c) 2015年 Org.CTIL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController {
    sqlite3 *db;
}

- (NSString *)filePath;

@end
