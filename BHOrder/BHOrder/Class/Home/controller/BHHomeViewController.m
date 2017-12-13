//
//  BHHomeViewController.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/8.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "BHHomeViewController.h"
#import "BHHomeTaskTableViewCell.h"
#import "BHTask.h"
#import "BHScheduleTableViewCell.h"
#import "BHSchedule.h"
#import "BHTaskDoneViewController.h"
#import "BHPopView.h"

static NSString *indentifier = @"BHHomeTaskTableViewCell";
static NSString *schedueindentifier = @"BHScheduleTableViewCell";

static NSString *schedueHeader = @"schedueHeader";
static NSString *taskHeader = @"taskHeader";

@interface BHHomeViewController ()<UITableViewDelegate,UITableViewDataSource,BHHomeTaskTableViewCellDeletage>{
    NSInteger _order;
    UIButton *_myTaskButton;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation BHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _order = 0;
    self.title = @"首页";
    self.view.backgroundColor = UIColorFromRGB(0xfafafa);
    
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_create"] style:UIBarButtonItemStyleDone target:self action:@selector(clickaddbutton)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_search"] style:UIBarButtonItemStyleDone target:self action:@selector(clickSearchButton)];
    self.navigationItem.rightBarButtonItems = @[addItem,searchItem];
}

- (void)clickaddbutton{
    
}

- (void)clickSearchButton{
    
}

- (void)loadInternetRequest{
    [self loadMyScheduleList];
    [self loadmytasklist];
}

- (void)loadMyScheduleList{
    NSString *string = [NSString stringWithFormat:@"%@%@",REQUEST_URL,@"programme/oneDay/list"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(1) forKey:@"pageNo"];
    [dic setObject:@(100) forKey:@"pageSize"];
    [dic setObject:[NSDate timeWithDateFormatter:@"yyyy-MM-dd" date:[NSDate date]] forKey:@"date"];
    [[BHAppHttpClient sharedInstance] requestGETWithPath:string parameters:nil success:^(BHResponse *response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([BHServerSuccess isEqualToString:response.code]) {
            [self.dataArray removeAllObjects];
            NSArray *arr = [BHSchedule mj_objectArrayWithKeyValuesArray:[response.obj objectForKey:@"list"]];
            [self.dataArray addObjectsFromArray:arr];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:response.msg];
        }
    } error:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadmytasklist{
    NSString *string = [NSString stringWithFormat:@"%@%@",REQUEST_URL,@"task/toDoList/"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(self.page) forKey:@"pageNo"];
    [dic setObject:BHPageSize forKey:@"pageSize"];
    [dic setObject:@"0" forKey:@"type"];
    [dic setObject:@(_order) forKey:@"orderBy"];
    [[BHAppHttpClient sharedInstance] requestGETWithPath:string parameters:nil success:^(BHResponse *response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([BHServerSuccess isEqualToString:response.code]) {
            if (self.page == 1) {
                [self.array removeAllObjects];
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
            }
            NSArray *arr = [BHTask mj_objectArrayWithKeyValuesArray:[response.obj objectForKey:@"list"]];
            if (arr.count < 10) {
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            [self.array addObjectsFromArray:arr];
            [self.tableView reloadData];
            self.page ++;
        }else{
            [MBProgressHUD showError:response.msg];
        }
    } error:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - BHHomeTaskTableViewCellDeletage
- (void)clickSelectButtonWithTask:(BHTask *)task{
    //修改任务状态
    NSString *string = [NSString stringWithFormat:@"%@%@",REQUEST_URL,@"task/updateStatus/"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:task.id forKey:@"id"];
    [dic setObject:@"4" forKey:@"status"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要把该任务的状态改为已完成吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //修改为完成
        [[BHAppHttpClient sharedInstance] requestPOSTWithPath:string parameters:dic success:^(BHResponse *response) {
            if ([BHServerSuccess isEqualToString:response.code]) {
                [MBProgressHUD showSuccess:@"修改成功"];
                [self.tableView.mj_header beginRefreshing];
            }else{
                [MBProgressHUD showError:response.msg];
            }
        } error:^(NSError *error) {
            [MBProgressHUD showError:BHDEFAULTERROR];
        }];
    }];
    [alert addAction:actioncancle];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorFromRGB(0xfafafa);
        [_tableView registerNib:[UINib nibWithNibName:@"BHHomeTaskTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"BHScheduleTableViewCell" bundle:nil] forCellReuseIdentifier:schedueindentifier];
        _tableView.tableFooterView = [UIView new];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self loadInternetRequest];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadmytasklist];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)array{
    if (_array == nil) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.dataArray.count == 0) {
            return 1;
        }
        return self.dataArray.count;
    }else{
        if (self.array.count == 0) {
            return 1;
        }
        return self.array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BHScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:schedueindentifier];
        if (self.dataArray.count == 0) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
            cell.schedule = [self.dataArray objectAtIndex:indexPath.row];
        }
        return cell;
    }
    BHHomeTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (self.array.count == 0) {
        cell.hidden = NO;
    }else{
        cell.task = [self.array objectAtIndex:indexPath.row];
        cell.select = NO;
        cell.hidden = YES;
        cell.delegate = self;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:schedueHeader];
        if (headerView == nil) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:schedueHeader];
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 200, 40)];
            timeLabel.text = [NSDate timeWithDateFormatter:@"yyyy年MM月dd日" date:[NSDate date]];
            timeLabel.font = [UIFont systemFontOfSize:13];
            timeLabel.textColor = UIColorFromRGB(0x333333);
            [headerView addSubview:timeLabel];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(self.view.width - 110 - 18, 0, 110, 40);
            [button setTitle:@"查看全部日程" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickcheckallschedule) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"home_right"] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 104, 0, 0)];
            [headerView addSubview:button];
        }
        headerView.backgroundColor = UIColorFromRGB(0xfafafa);
        return headerView;
    }
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:taskHeader];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:taskHeader];
        _myTaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _myTaskButton.frame = CGRectMake(18, 0, 120, 40);
        _myTaskButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_myTaskButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_myTaskButton addTarget:self action:@selector(clickcheckallmytask) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:_myTaskButton];
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(self.view.width - 110 - 18, 0, 110, 40);
        [button1 setTitle:@"查看历史已办" forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:13];
        [button1 setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(clickcheckalltaskdone) forControlEvents:UIControlEventTouchUpInside];
        [button1 setImage:[UIImage imageNamed:@"home_right"] forState:UIControlStateNormal];
        [button1 setImageEdgeInsets:UIEdgeInsetsMake(0, 104, 0, 0)];
        [headerView addSubview:button1];
    }
    NSString *title = [NSString stringWithFormat:@"我的任务(%lu)",(unsigned long)self.array.count];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:13]];
    _myTaskButton.frame = CGRectMake(8, 0, size.width + 15 + 10, 40);
    [_myTaskButton setTitle:title forState:UIControlStateNormal];
    [_myTaskButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_myTaskButton setImage:[UIImage imageNamed:@"home_down"] forState:UIControlStateNormal];
    [_myTaskButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [_myTaskButton setImageEdgeInsets:UIEdgeInsetsMake(0, size.width + 5 + 10, 0, 0)];
    headerView.backgroundColor = UIColorFromRGB(0xfafafa);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//查看全部日程
- (void)clickcheckallschedule{
    
}
//查看所有已办任务
- (void)clickcheckalltaskdone{
    BHTaskDoneViewController *taskDoneVC = [[BHTaskDoneViewController alloc] init];
    [self.navigationController pushViewController:taskDoneVC animated:YES];
}
//所有任务排序
- (void)clickcheckallmytask{
    
}

@end
