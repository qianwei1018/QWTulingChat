//
//  PersonalCenterViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/15.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "MainViewController.h"

@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource,myValuesDelegate>

@property (weak, nonatomic) IBOutlet UITableView *personalTableView;

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) NSMutableArray *dataArray1;
@property (strong, nonatomic) NSMutableArray *dataArray2;
@property (strong, nonatomic) NSMutableArray *pictureArray1;
@property (strong, nonatomic) NSMutableArray *pictureArray2;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.personalTableView.delegate = self;
    self.personalTableView.dataSource = self;
    
    self.pictureImageView.layer.cornerRadius = 30;
    self.pictureImageView.layer.masksToBounds = YES;
    
    _nameLabel.text = _userName;
    
    [self initView];
    [self initData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) initData {
    
    _dataArray1 = [NSMutableArray arrayWithCapacity:10];
    _pictureArray1 = [NSMutableArray arrayWithCapacity:10];
    _dataArray1 = [NSMutableArray arrayWithObjects:@"夜间模式",@"通用设置", nil];
    _pictureArray1 = [NSMutableArray arrayWithObjects:@"iconfont-yejianmoshi",@"iconfont-tubiao01",nil];
    _dataArray2 = [NSMutableArray arrayWithCapacity:10];
    _dataArray2 = [NSMutableArray arrayWithObjects:@"分享APP",@"意见反馈",@"给APP评分", nil];
    _pictureArray2 = [NSMutableArray arrayWithObjects:@"iconfont-fenxiang",@"iconfont-yijianfankui",@"iconfont-iconfont97", nil];
    
}

-(void) initView {
    
}

#pragma mark - 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _dataArray1.count;
    } else {
        return _dataArray2.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.frame = CGRectMake(0, 0, 10, 10);
    if (indexPath.section == 0) {
        cell.textLabel.text = _dataArray1[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_pictureArray1[indexPath.row]];
    } else {
        cell.textLabel.text = _dataArray2[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_pictureArray2[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"你好");
    
}





@end
