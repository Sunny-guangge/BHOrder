//
//  BHLoginViewController.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/11.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "BHLoginViewController.h"
#import "BHTools.h"
#import "AppDelegate.h"
#import "BHTabBarViewController.h"
#import "WXApi.h"

@interface BHLoginViewController ()<UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate>{
    //注册时的倒计时
    NSInteger _time;
    NSTimer *_nstimer;
    NSString *_openId;
}

- (IBAction)quitapp:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;
- (IBAction)clicksendcodebutton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *clickloginbutton;

@property (weak, nonatomic) IBOutlet UIView *textbackView;
@property (nonatomic,strong) UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *qqbutton;
- (IBAction)clickweixinloginbutton:(id)sender;
- (IBAction)clickqqloginbutton:(id)sender;
- (IBAction)clickloginbutton:(id)sender;

@end

@implementation BHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _openId = @"";
    
    self.detailLabel.text = @"由于您是首次登录order，\n请输入您的手机号码和验证码";
    self.phoneTextField.delegate = self;
    self.codeTextField.delegate = self;
    
    _time = 90;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getwxcodesuccess:) name:WXGETCODESUCCESS object:nil];
    
    [self.textbackView addSubview:self.textView];
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textbackView.mas_top).with.offset(padding.top);
        make.left.equalTo(self.textbackView.mas_left).with.offset(padding.left);
        make.bottom.equalTo(self.textbackView.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(self.textbackView.mas_right).with.offset(-padding.right);
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_nstimer invalidate];
    _nstimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXGETCODESUCCESS object:nil];
}

- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"点击登录，既表示我已阅读并同意《服务协议》"];//《基金公司直销平台用户协议》
        [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSLinkAttributeName
                                 value:@"xieyi0://"
                                 range:[[attributedString string] rangeOfString:@"《服务协议》"]];
        
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithsize:13] range:NSMakeRange(0, attributedString.length)];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentCenter;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attributedString.length)];
        _textView.linkTextAttributes = @{NSForegroundColorAttributeName: UIColorFromRGB(BHAPPMAINCOLOR)};
        _textView.attributedText = attributedString;
        _textView.delegate = self;
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.allowsEditingTextAttributes = NO;
    }
    return _textView;
}

- (IBAction)quitapp:(id)sender {
    exit(0);
}
- (IBAction)clicksendcodebutton:(id)sender {
    NSLog(@"获取验证码");
    NSString *url = [NSString stringWithFormat:@"%@%@%@",REQUEST_URL,@"sys/send_sms_code/",self.phoneTextField.text];
    [[BHAppHttpClient sharedInstance] requestPOSTWithPath:url parameters:nil success:^(BHResponse *response) {
        if ([@"10000" isEqualToString:response.code]) {
            _nstimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
            [_nstimer fire];
            [MBProgressHUD showSuccess:@"发送成功"];
        }else{
            [MBProgressHUD showError:response.msg];
        }
    } error:^(NSError *error) {
        [MBProgressHUD showError:BHDEFAULTERROR];
    }];
}
- (IBAction)clickweixinloginbutton:(id)sender {
    NSLog(@"微信登录");
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = WXPacket_State;
        [WXApi sendReq:req];
    }
}
//获取用户的openid
- (void)getwxcodesuccess:(NSNotification *)notification{
    NSString *code = [notification.userInfo objectForKey:@"code"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", @"image/jpeg", @"image/png",@"application/octet-stream",nil];
    NSDictionary *dic = @{@"appid":WEIXINAPPID,@"secret":WEIXINSECRET,@"code":code,@"grant_type":@"authorization_code"};
    [manager POST:WXREQUESTURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _openId = responseObject[@"openid"];
        NSString *access_token = responseObject[@"access_token"];
        [self getweixinuserinfo:access_token];
        if (_openId) {
            [self weixinopenidTologin];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//获取用户的基本信息
- (void)getweixinuserinfo:(NSString *)access_token{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", @"image/jpeg", @"image/png",@"application/octet-stream",nil];
    NSDictionary *dic = @{@"access_token":access_token,@"openid":_openId};
    [manager POST:WXUSERINFOURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.topDistance.constant = 93;
        [self.view layoutIfNeeded];
        NSString *avatar = responseObject[@"headimgurl"];
        NSString *nickname = responseObject[@"nickname"];
        self.nameLabel.text = nickname;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatar]];
        self.nameLabel.hidden = NO;
        self.avatarImageView.hidden = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//微信openid登录
- (void)weixinopenidTologin{
    NSString *url = [NSString stringWithFormat:@"%@%@",REQUEST_URL,@"sys/login"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[BHAppHttpClient sharedInstance] requestPOSTWithPath:url parameters:nil header:_openId success:^(BHResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([response.code isEqualToString:@"10000"]) {//登录成功
            [self loginSuccess:response];
        }else{//登录失败
            self.detailLabel.text = @"您的微信账号未在order完成手机验证，\n请输入您的手机号码和验证码";
        }
    } error:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (IBAction)clickqqloginbutton:(id)sender {
    NSLog(@"QQ登录");
}

- (IBAction)clickloginbutton:(id)sender {
    NSLog(@"登录");
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"phone":self.phoneTextField.text,@"checkcode":self.codeTextField.text,@"model":[BHTools deviceMessage],@"openid":_openId}];
    NSString *url = [NSString stringWithFormat:@"%@%@",REQUEST_URL,@"sys/login"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[BHAppHttpClient sharedInstance] requestPOSTWithPath:url parameters:dic success:^(BHResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([@"10000" isEqualToString:response.code]) {
            [self loginSuccess:response];
        }else{
            [MBProgressHUD showError:response.msg];
        }
    } error:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:BHDEFAULTERROR];
    }];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneTextField) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 18){
            return NO;
        }
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        if ([self isMobile:text]) {
            self.codeButton.enabled = YES;
            [self.codeButton setBackgroundColor:UIColorFromRGB(BHAPPMAINCOLOR)];
        }else{
            self.codeButton.enabled = NO;
            [self.codeButton setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
        }
        return YES;
    }
    if (textField == self.codeTextField) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 18){
            return NO;
        }
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        if (text.length >= 4) {
            self.loginButton.enabled = YES;
            [self.loginButton setBackgroundColor:UIColorFromRGB(BHAPPMAINCOLOR)];
        }else{
            self.loginButton.enabled = NO;
            [self.loginButton setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
        }
        return YES;
    }
    return YES;
}

- (BOOL)isMobile:(NSString *)text{
    if (text.length == 11) {
        return YES;
    }
    return NO;
}

- (void)updateTime
{
    if (_time > 0) {
        NSString *strTime = [NSString stringWithFormat:@"%lds后可重发",(long)_time];
        [self.codeButton setTitle:strTime forState:UIControlStateDisabled];
        self.codeButton.enabled = NO;
        _time--;
    }else{
        [_nstimer invalidate];
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
        self.codeButton.enabled = YES;
        _time = 89;
        return;
    }
}

- (void)saveUserInfo:(BHUser *)user{
    [BHUser currentUser].email = user.email;
    [BHUser currentUser].sign = user.sign;
    [BHUser currentUser].profession = user.profession;
    [BHUser currentUser].isCreateUser = user.isCreateUser;
    [BHUser currentUser].isEnable = user.isEnable;
    [BHUser currentUser].id = user.id;
    [BHUser currentUser].name = user.name;
    [BHUser currentUser].phone = user.phone;
    [BHUser currentUser].avatar = user.avatar;
    [BHUser currentUser].token = user.token;
    [BHUser updateUser];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self quitLoginController];
}

- (void)loginSuccess:(BHResponse *)response{
    BHUser *user = [BHUser mj_objectWithKeyValues:[response.obj objectForKey:@"currentuser"]];
    NSString *token = [response.obj objectForKey:@"token"];
    if (token && user) {
        user.token = token;
        [self saveUserInfo:user];
        //其他设备登录的异常信息
        NSString *model = [response.obj objectForKey:@"lastLoginModel"];
        if (model && ![model isBlankString]) {//提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:model delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            [MBProgressHUD showSuccess:@"登录成功" toView:self.view];
            [self performSelector:@selector(quitLoginController) withObject:nil afterDelay:MBProgressHUDTime];
        }
    }
}

- (void)quitLoginController{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BHTabBarViewController *tabbarVC = [mainStroyBoard instantiateInitialViewController];
    delegate.window.rootViewController = tabbarVC;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"xieyi0"]) {
        
    }
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
