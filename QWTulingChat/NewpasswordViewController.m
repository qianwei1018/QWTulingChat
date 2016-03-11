//
//  NewpasswordViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/9.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "NewpasswordViewController.h"

@interface NewpasswordViewController ()
/**
 *  新密码
 */
@property (weak, nonatomic) IBOutlet UITextField *newpPasswordTextField;
/**
 *  确认密码
 */
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPasswordTextField;

@end

@implementation NewpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
/**
 *  回收键盘
 *
 *  @param touches 点击
 *  @param event   回收键盘
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.newpPasswordTextField resignFirstResponder];
    [self.confirmNewPasswordTextField resignFirstResponder];
}



/**
 *  提交密码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)submitNewPassword:(UIButton *)sender {
    
    
    
}


@end
