//
//  BHHeaderIconView.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/13.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "BHHeaderIconView.h"
//宽  50  高44

@interface BHHeaderIconView()

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) NSArray *array;

@end

@implementation BHHeaderIconView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    [self addSubview:self.avatarImageView];
    [self addSubview:self.imageView];
    [self addSubview:self.button];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.button.frame = self.bounds;
    self.avatarImageView.frame = CGRectMake(0, (self.height - 25) / 2, 25, 25);
    self.imageView.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 5, (self.height - 18) / 2, 4, 18);
}

- (UIButton *)button{
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(clickbutton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)clickbutton{
    if (self.block) {
        self.block();
    }
}

- (UIImageView *)avatarImageView{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 12.5;
        if ([BHUser currentUser].avatar && ![[BHUser currentUser].avatar isBlankString]) {
            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[BHUser currentUser].avatar]];
        }else{
            [_avatarImageView addSubview:self.nameLabel];
            NSInteger val = [[BHUser currentUser].id integerValue] % 10;
            NSInteger index = val % self.array.count;
            _avatarImageView.backgroundColor = UIColorFromRGB((int)[self.array objectAtIndex:index]);
        }
    }
    return _avatarImageView;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"home_diandian"];
    }
    return _imageView;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _nameLabel.textColor = UIColorFromRGB(0xffffff);
        _nameLabel.font = [UIFont systemFontOfSize:10];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        if ([BHUser currentUser].name) {
            if ([BHUser currentUser].name.length >= 3) {
                _nameLabel.text = [[BHUser currentUser].name substringFromIndex:[BHUser currentUser].name.length- 2];
            }else{
                _nameLabel.text = [BHUser currentUser].name;
            }
        }
    }
    return _nameLabel;
}

- (NSArray *)array{
    if (_array == nil) {
        _array = @[@0xddaebe,@0x93cad0,@0xa59abd,@0xa67e5e,@0xd76a9c];
    }
    return _array;
}

@end
