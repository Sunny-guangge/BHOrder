//
//  BHPopView.m
//  testupview
//
//  Created by 王帅广 on 2017/12/8.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "BHPopView.h"

static CGFloat cellH = 60;

@interface BHPopTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UILabel *titlelabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,copy) NSString *selectTitle;
@property (nonatomic,strong) NSArray *arr;

@end

@implementation BHPopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.image];
        [self addSubview:self.titlelabel];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)setArr:(NSArray *)arr{
    _arr = arr;
    if (![[arr objectAtIndex:0] isBlankString]) {
        self.image.image = [UIImage imageNamed:[arr objectAtIndex:0]];
    }
    if (_selectTitle && [[arr objectAtIndex:1] isEqualToString:_selectTitle]) {
        self.titlelabel.textColor = UIColorFromRGB(0x999999);
    }else{
        self.titlelabel.textColor = UIColorFromRGB(0x333333);
    }
    self.titlelabel.text = [arr objectAtIndex:1];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if ([[_arr objectAtIndex:0] isBlankString]) {
        self.titlelabel.frame = CGRectMake(18, 0, self.frame.size.width - 36, self.bounds.size.height);
    }else{
        self.image.frame = CGRectMake(30, (cellH - 18) / 2, 18, 18);
        self.titlelabel.frame = CGRectMake(CGRectGetMaxX(self.image.frame) + 35, 0, self.frame.size.width - CGRectGetMaxX(self.image.frame) - 35 - 18, self.bounds.size.height);
    }
    self.lineView.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
}

- (UIImageView *)image{
    if (_image == nil) {
        _image = [[UIImageView alloc] init];
    }
    return _image;
}

- (UILabel *)titlelabel{
    if (_titlelabel == nil) {
        _titlelabel = [[UILabel alloc] init];
        _titlelabel.textColor = [UIColor blackColor];
        _titlelabel.font = [UIFont systemFontOfSize:16];
    }
    return _titlelabel;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
        _lineView.alpha = 0.3;
    }
    return _lineView;
}

@end

static NSString *indentifier = @"BHPopTableViewCell";

@interface BHPopView()<UITableViewDelegate,UITableViewDataSource>{
    CGFloat _width;
    CGFloat _height;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation BHPopView

- (instancetype)initWithFrame:(CGRect)frame
                   TitleArray:(NSArray *)array
            textAlignmentType:(NSTextAlignment)textAlignment
       BHPopViewDirectionType:(BHPopViewDirectionType)directionType{
    self = [super initWithFrame:frame];
    if (self) {
        _array = array;
        _textAlignment = textAlignment;
        _directionType = directionType;
        _selectColor = [UIColor blueColor];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self addSubview:self.tableView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[BHPopTableViewCell class] forCellReuseIdentifier:indentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

//显示的视图上
- (void)showInView:(UIView *)view{
    [view addSubview:self];
    _width = view.frame.size.width;
    _height = view.frame.size.height;
    if (_directionType == BHPopViewDirectionUp) {
        _tableView.frame = CGRectMake(0, 0-_array.count * cellH, _width, _array.count * cellH);
    }else if (_directionType == BHPopViewDirectionDown){
        _tableView.frame = CGRectMake(0, _height, _width, _array.count * cellH);
    }
    [_tableView reloadData];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        if (_directionType == BHPopViewDirectionUp) {
            _tableView.frame = CGRectMake(0, 0, _width, _array.count * cellH);
        }else if (_directionType == BHPopViewDirectionDown){
            _tableView.frame = CGRectMake(0, _height - _array.count * cellH, _width, _array.count * cellH);
        }
    }];
}

//隐藏视图
- (void)hide{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0f;
        if (_directionType == BHPopViewDirectionUp) {
            _tableView.frame = CGRectMake(0, 0-_array.count * cellH, _width, _array.count * cellH);
        }else if (_directionType == BHPopViewDirectionDown){
            _tableView.frame = CGRectMake(0, _height, _width, _array.count * cellH);
        }
    } completion:^(BOOL finished) {
        [_tableView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewCellDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BHPopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    cell.selectTitle = _selectTitle;
    cell.arr = [_array objectAtIndex:indexPath.row];
    cell.titlelabel.textAlignment = _textAlignment;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectTitle = [_array objectAtIndex:indexPath.row];
    [_tableView reloadData];
    if (self.block) {
        self.block(indexPath.row);
    }
    [self hide];
}

- (void)dealloc{
    
}
@end
