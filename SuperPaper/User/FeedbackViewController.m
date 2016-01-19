//
//  FeedbackViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIImageView *FAQImageView;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: TextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([[textView.text stringByReplacingCharactersInRange:range withString:text] isEqualToString:@""]&&![text isEqualToString:@""]){
        textView.text = @"乐意聆听您对本客户端的任何意见和建议！  ";
        textView.textColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.7];
    }else
        textView.textColor = [UIColor blackColor];
    
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"乐意聆听您对本客户端的任何意见和建议！"]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@""]){
        textView.text = @"乐意聆听您对本客户端的任何意见和建议！  ";
        textView.textColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.7];
    }
}
//MARK: Helper
- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView.textContainerInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.textView.text = @"乐意聆听您对本客户端的任何意见和建议！";
    self.textView.textColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.7];
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 5;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textField.layer.borderWidth = 0.5;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, self.textField.bounds.size.height)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
