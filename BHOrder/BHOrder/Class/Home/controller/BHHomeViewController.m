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

static NSString *indentifier = @"BHHomeTaskTableViewCell";

@interface BHHomeViewController ()<UITableViewDelegate,UITableViewDataSource,BHHomeTaskTableViewCellDeletage>{
    NSInteger _order;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation BHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _order = 0;
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要修改此任务为已完成吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"暂不修改" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认修改" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"BHHomeTaskTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
        _tableView.tableFooterView = [UIView new];
        _tableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
            self.page = 1;
            [self loadmytasklist];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BHHomeTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    cell.task = [self.array objectAtIndex:indexPath.row];
    cell.select = NO;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



@end
