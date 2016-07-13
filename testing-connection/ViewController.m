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
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(130, 300, 150, 35);
    btn2.layer.cornerRadius = 7;
    btn2.backgroundColor = [UIColor greenColor];
    [btn2 setTitle:@"get return value" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(get_PHP_return_value) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
}

-(void)get_PHP_return_value{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *domainStr = @"http://10.209.68.42/1.php/";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    NSMutableSet *contentTypes = [[NSMutableSet alloc]initWithSet:manager.responseSerializer.acceptableContentTypes];
//    [contentTypes addObject:@"text/html"];
    
    
    [manager GET:domainStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //in order to obtain the returning value as dictionary, make sure that the php output contains only and exactly one array. (if containing more than one element will cause response object to be uncapturable)
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSString *resultant_string = [d objectForKey:@"result"];
//        NSLog(@"result is: %@", resultant_string);
        
        NSString *resultString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"---获取到的json格式的字典--%@",resultString);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"capturing return value fail: %@", error.userInfo);
    }];
    
    
}


-(void)registerUser{
    
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //服务器给的域名
    NSString *domainStr = @"http://10.209.68.42/1.php";
    
    //假如需要提交给服务器的参数是key＝1,class_id=100
    //创建一个可变字典
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    
    NSString *user = username.text;
    NSString *password = pwd.text;
    
    [parametersDic setObject:user forKey:@"user"];
    [parametersDic setObject:password forKey:@"pwd"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //these serializers have both the normal type and the json type. determine which one to use
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //do not user the requestSerializer here for the intended string is not a json string. user this if we are sending over an nsdata->json string
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //以post的形式提交，POST的参数就是上面的域名，parameters的参数是一个字典类型，将上面的字典作为它的参数
    [manager POST:domainStr parameters:parametersDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 隐藏系统风火轮
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //json解析
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *resultString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"---获取到的json格式的字典--%@",resultDict);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"this is the error msg: %@", error.userInfo);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
