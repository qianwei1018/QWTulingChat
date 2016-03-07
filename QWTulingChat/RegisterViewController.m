//
//  RegisterViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/7.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;


@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *TelTextField;

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@property (strong, nonatomic) NSString *segmentStr;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupAlerts];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 正则表达式

-(void)setupAlerts{
    
    
}





#pragma mark - 点击事件
/**
 *  选择性别
 *
 *  @param sender click Index
 */
- (IBAction)segmentedChangeGender:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.segmentStr = [sender titleForSegmentAtIndex:0];
            break;
        case 1:
            self.segmentStr = [sender titleForSegmentAtIndex:1];
            break;
        case 2:
            self.segmentStr = [sender titleForSegmentAtIndex:2];
            break;
            
        default:
            break;
    }
}

/**
 *  清除所有输入
 *
 *  @param sender <#sender description#>
 */
- (IBAction)replaceChoice:(UIButton *)sender {
}

/**
 *  注册提交
 *
 *  @param sender <#sender description#>
 */
- (IBAction)confirmSubmit:(UIButton *)sender {
    NSLog(@"检查是否注册成功！");
    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *confirmPassword = self.confirmPasswordTextField.text;
    NSString *telNum = self.TelTextField.text;
    
    
    
    
    
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
