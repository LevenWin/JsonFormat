//
//  ViewController.m
//  JsonFormat
//
//  Created by leven on 16/10/31.
//  Copyright © 2016年 Leven. All rights reserved.
//

#import "ViewController.h"
#import <RegexKitLite.h>
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Leven Format";
    self.formatArr=[NSMutableArray array];
    self.textView.font=[NSFont userFontOfSize:16];
    self.textView.textColor = [NSColor darkGrayColor];
    self.textView.delegate = self;
}
- (IBAction)back:(id)sender {
      self.textView.string= self.formatArr.lastObject;
    [self.formatArr removeLastObject];
}
- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRanges:(NSArray<NSValue *> *)affectedRanges replacementStrings:(nullable NSArray<NSString *> *)replacementStrings{
    if (replacementStrings.count == 1 &&[replacementStrings.firstObject isEqualToString:@"\n"]) {
        [self property:nil];
    }
    return YES;
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
         self.textView.string=@"格式不正确";
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
    BOOL isFenHaoEnd = NO;
    if ([str containsString:@"\","]) {
        isFenHaoEnd = NO;
    }else if([str containsString:@"\";"]){
        isFenHaoEnd = YES;
    }else{
        self.textView.string = @"格式不正确!";
        return;
    }
    
    NSArray *regArr = [str componentsMatchedByRegex:@"\\[\\{.*?\\}\\]"];
    for (NSString *resultStr in regArr) {
        NSString *tmpStr = [resultStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:tmpStr withString:@""];
    }

    NSArray *strArr = nil;
    if (isFenHaoEnd) {
        strArr = [str componentsSeparatedByString:@";"];
    }else{
        strArr = [str componentsSeparatedByString:@","];
    }

    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray *dataArr=[NSMutableArray array];
    NSArray *filterStr=@[@"{",@"}",@"[",@"]",@"(",@")"];
    NSMutableArray *keysArr = [NSMutableArray array];
    
    for (NSString *str in strArr) {
        NSString *key =[[str componentsSeparatedByString:@":"].firstObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *value =[[str componentsSeparatedByString:@":"].lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            key=[self filterStr:key];
            
        if (key.length <= 0||[filterStr containsObject:key] || [keysArr containsObject:key]) {
            continue;
        }
        [keysArr addObject:key];
            
        if ([value containsString:@"\""]) {
            [dataArr addObject:[NSString stringWithFormat:@"@property (nonatomic, copy)     NSString *%@",key]];
        }else if([value containsString:@"{"]){
            [dataArr addObject:[NSString stringWithFormat:@"@property (nonatomic, strong)   NSDictionary *%@",key]];
        }else if([value containsString:@"["]){
            [dataArr addObject:[NSString stringWithFormat:@"@property (nonatomic, strong)   NSArray *%@",key]];
        }else{
            [dataArr addObject:[NSString stringWithFormat:@"@property (nonatomic, strong)   NSNumber *%@",key]];
                
        }
            
    }
    NSString *resultStr=[dataArr componentsJoinedByString:@";\n"];
        
    self.textView.string=[NSString stringWithFormat:@"\n%@;\n",resultStr];
}

-(NSString *)filterStr:(NSString *)str{
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return str;
}

@end
