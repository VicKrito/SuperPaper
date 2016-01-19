//
//  MyMessageViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/15.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MyMessageTableViewCell.h"

@interface MyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

static NSString *const MessageTableViewCellIdentifier = @"Message";
@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setTableFooterView:[UIView new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: TableViewDatasource,delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageTableViewCellIdentifier];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    cell.timeLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:arc4random()%(3600 * 24 * 365 * 50)]];
    NSInteger i =  arc4random()%(0x9fa5-0x4e00 + 1) + 0x4e00;
    NSString * unicodeStr = [NSString stringWithFormat:@"\"\\U%lx\"", i];
    NSData *tempData = [unicodeStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString* randomStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    cell.titleLabel.text = randomStr;
    cell.detailsLabel.text = [self getNameUseUTF8WithLen:25];
    return cell;
}

//MARK:Helper
-(unsigned short)changeShortLittleToBig:(unsigned short)number
{
    
    return (number & 0x00ff)<< 8 | (number &0xff00)>>8;
}

-(unsigned int)changeIntLittleToBig:(unsigned int)number
{
    return (number & 0x000000ff )<< 24 | (number & 0x0000ff00) << 8 | (number & 0x00ff0000)>>8 | (number & 0xff000000)>>24;
}

-(NSString *) gb2312toutf8:(NSData *) data{
    
    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    
    return retStr;
}

-(NSString *)getNameUseUTF8WithLen:(short)len
{
    NSString *name = @"";
    unsigned short low    = 0x4e00;
    unsigned short hight  = 0x9fa5;
    
    for (int i=0; i<len; i++) {
        unsigned short byte = arc4random_uniform(hight-low)+low;
        //小端 转大端
        byte = ((byte & 0xff00) >> 8) | ((0xff & byte )<<8);
        NSData *nameData = [NSData dataWithBytes:&byte length:sizeof(unsigned short)];
        NSString *byteStr = [[NSString alloc]initWithData:nameData encoding:NSUnicodeStringEncoding];
        name = [NSString stringWithFormat:@"%@%@",name,byteStr];
        //name = ;
    }
    return name;
}
//- (NSString *)getGB2312String
//{
//    NSMutableArray *list = [NSMutableArray array];
//    for (int qu = 16; qu <= 55; qu ++) {
//        int wei2 = (qu == 55)? 89 : 94;
//        for (int wei = 1 ; wei <= wei2 ; wei ++) {
//            [list addObject:@(qu + 0xa0)];
//            [list addObject:@(wei + 0xa0)];
//        }
//    }
//    return
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
