//
//  ChatViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/7.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "ChatViewController.h"
#import "MyTulingHeader.h"
#import "ChatTableTableViewCell.h"
#import "ChatBubbleViewController.h"
@interface ChatViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@property (strong, nonatomic) NSTimer *timer;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self ShowScrollView];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.title = @"聊天";
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changePageControl:) userInfo:nil repeats:YES];
    
    
    self.chatTableView.delegate =self;
    self.chatTableView.dataSource = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件响应
/**
 *  添加scrollView
 */
- (void)ShowScrollView {
    for (int i = 0; i < 4; i++) {
        NSString *imgName = [NSString stringWithFormat:@"advertising%d",i+1];
        UIImage *img = [UIImage imageNamed:imgName];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT/4);
        [self.scrollView addSubview:imgView];
        
    }
    // 设置scrollView的显示内容大小
    self.scrollView.contentSize = CGSizeMake(4*SCREEN_WIDTH, SCREEN_HEIGHT/4);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
}

- (void)changePageControl:(NSTimer *)sender {
    self.pageControl.currentPage = (self.pageControl.currentPage+1)%self.pageControl.numberOfPages;
    
    [self changeScorllViewOffSet];
}

- (void)changeScorllViewOffSet {
    self.scrollView.contentOffset = CGPointMake(self.pageControl.currentPage*SCREEN_WIDTH, 0);
}


- (IBAction)changePage:(UIPageControl *)sender {
    [self changeScorllViewOffSet];
}

#pragma mark - scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"scrollViewWillEndDragging");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changePageControl:) userInfo:nil repeats:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page = (self.scrollView.contentOffset.x+SCREEN_WIDTH/2)/SCREEN_WIDTH;
    self.pageControl.currentPage = page;
}


#pragma mark - table View data source
//分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
//组中元素个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size.height/1.5;
}
/**
 *  table view cell
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"chatCustomTableCell";
    [tableView registerNib:[UINib nibWithNibName:@"ChatTableTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    ChatTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatTableTableViewCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

/**
 *  点击
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"开始聊天");
    
    ChatBubbleViewController *chatBubbleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"chatBubbleViewController"];
    
    [self.navigationController pushViewController:chatBubbleVC animated:YES];
    
}


@end
