//
//  ViewController.h
//  JsonFormat
//
//  Created by 吴狄 on 16/10/31.
//  Copyright © 2016年 Leven. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (nonatomic,retain)NSMutableArray *formatArr;
@property (strong) IBOutlet NSTextView *textView;

@property (strong) IBOutlet NSButton *pretty;
@property (strong) IBOutlet NSButton *property;
@property (strong) IBOutlet NSButton *clear;

@end

