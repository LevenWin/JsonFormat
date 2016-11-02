//
//  ViewController.m
//  JsonFormat
//
//  Created by 吴狄 on 16/10/31.
//  Copyright © 2016年 Leven. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Leven Format";
    self.formatArr=[NSMutableArray array];
    self.textView.font=[NSFont userFontOfSize:21];
}
- (IBAction)back:(id)sender {
      self.textView.string= self.formatArr.lastObject;
    [self.formatArr removeLastObject];
}

- (IBAction)property:(id)sender {
    if ([self.formatArr.lastObject isEqualToString:self.textView.string]) {
        return;
    }

    [self.formatArr addObject:[NSString stringWithFormat:@"%@",self.textView.string]];
    
    NSString *str=[self.textView.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([[str substringToIndex:1 ] isEqualToString:@"{"]&&[[str substringFromIndex:str.length-1] isEqualToString:@"}"]) {
        NSLog(@"字典");
        [self dictionaryWithJsonString:str];
        
    }else if([[str substringToIndex:1 ] isEqualToString:@"["]&&[[str substringFromIndex:str.length-1] isEqualToString:@"]"]){
         NSLog(@"数组");
    }else{
         self.textView.string=@"格式错误";
    }
    
   
    
}
- (IBAction)clear:(id)sender {
    if ([self.formatArr.lastObject isEqualToString:self.textView.string]) {
        return;
    }
    
    [self.formatArr addObject:[NSString stringWithFormat:@"%@",self.textView.string]];

    self.textView.string=@"";
}
- (void)dictionaryWithJsonString:(NSString *)jsonString {
    NSString *str=[NSString stringWithFormat:@"%@",[jsonString substringWithRange:NSMakeRange(1, jsonString.length-1)]];
    NSArray *strArr=[str componentsSeparatedByString:@";"];
    
    NSMutableArray *dataArr=[NSMutableArray array];
    NSArray *filterStr=@[@"{",@"}",@"[",@"]",@"(",@")"];
    for (NSString *str in strArr) {
        NSString *key =[[str componentsSeparatedByString:@"="].firstObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *value =[[str componentsSeparatedByString:@"="].lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        key=[self filterStr:key];
        
        if (key.length<=0||[filterStr containsObject:key]) {
            continue;
        }
        
        if ([value containsString:@"\""]) {
            [dataArr addObject:[NSString stringWithFormat:@"@property (nonatomic,copy)     NSString *%@",key]];
        }else if([value containsString:@"{"]){
            [dataArr addObject:[NSString stringWithFormat:@"@property (nonatomic,retain)   NSDictionary *%@",key]];
        }else if([value containsString:@"["]){
            [dataArr addObject:[NSString stringWithFormat:@"@property (nonatomic,retain)   NSArray *%@",key]];
        }else{
            [dataArr addObject:[NSString stringWithFormat:@"@property (nonatomic,retain)   NSNumber *%@",key]];

        }
        
    }
    NSString *resultStr=[dataArr componentsJoinedByString:@";\n"];
    
    self.textView.string=[NSString stringWithFormat:@"\n%@;\n",resultStr];
    
    
    

   
}

-(NSString *)filterStr:(NSString *)str{
    [str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\"“"]];
    if ([str containsString:@"\""]) {
        str=[str substringWithRange:NSMakeRange(1, str.length-2)];
    }
    return str;
}

@end
