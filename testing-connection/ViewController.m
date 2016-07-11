//
//  ViewController.m
//  testing-connection
//
//  Created by Qi Hu on 8/7/16.
//  Copyright © 2016 Qi Hu. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController{
    UITextField *username;
    UITextField *pwd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    username = [[UITextField alloc]init];
    username.frame = CGRectMake(65, 110, 250, 35);
    username.placeholder = @"enter your user name";
    username.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:username];
    
    pwd = [[UITextField alloc]init];
    pwd.frame = CGRectMake(65, 160, 250, 35);
    pwd.placeholder = @"enter your password";
    pwd.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:pwd];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(130, 220, 120, 35);
    btn.layer.cornerRadius = 7;
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"register" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}


-(void)registerUser{
    
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //服务器给的域名
    NSString *domainStr = @"http://10.209.68.42/1.php/";
    
    //假如需要提交给服务器的参数是key＝1,class_id=100
    //创建一个可变字典
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    
    [parametersDic setObject:@"testing" forKey:@"name"];
    [parametersDic setObject:@"000000" forKey:@"pwd"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //以post的形式提交，POST的参数就是上面的域名，parameters的参数是一个字典类型，将上面的字典作为它的参数
    [manager POST:domainStr parameters:parametersDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 隐藏系统风火轮
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //json解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"---获取到的json格式的字典--%@",resultDic);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"this is the error msg: %@", error.userInfo);
    }];

    
//    NSLog(@"registering yo");
//    NSString *str = [NSString stringWithFormat:@"http://10.209.68.42/1.php?user=%@&pwd=%@", username.text, pwd.text];
//    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:str];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//    
//    [connect start];
    
    
//    NSURL *url = [NSURL URLWithString:@"http://10.209.68.42/1.php"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    NSString *str = [NSString stringWithFormat:@"user=%@&pwd=%@", username.text, pwd.text];
//    
//    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    // 由于要先对request先行处理,我们通过request初始化task3
//    NSURLSessionTask *task = [session dataTaskWithRequest:request
//                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]); }];
//    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
