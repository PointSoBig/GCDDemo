//
//  ViewController.m
//  GCDDemo
//
//  Created by 景晓峰 on 2017/4/25.
//  Copyright © 2017年 景晓峰. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //异步执行
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
    });
    
    //主线程执行
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    
    //一次性执行
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
    
    //单例模式
    [ViewController shareInstance];
    
    //延时执行
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
    });
    
    //自定义串行队列
    dispatch_queue_t urls_queue = dispatch_queue_create("jingxiaofeng", NULL);
    dispatch_async(urls_queue, ^{
        
    });

    
    //线程同步解决方案
    //1.创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    //2.创建group
    dispatch_group_t group = dispatch_group_create();
    
    //3.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"我是任务一%@",[NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"我是任务二%@",[NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_group_notify(group,queue, ^{
        NSLog(@"所有任务处理完成%@",[NSThread currentThread]);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        
    });
    
    // 创建一个用户串行队列:"com.li":队列名是一个C字符串，没有特别的要求，Apple建议用倒装的标识符来表示
    dispatch_queue_t serialQueue = dispatch_queue_create("com.li", NULL);
    dispatch_async(serialQueue, ^{
        NSLog(@"串行队列异步任务一:%@",[NSThread currentThread]);
        for (int i = 0; i< 10; i++)
        {
            NSLog(@"1_%d",i);
        }
    });
    dispatch_sync(serialQueue, ^{
        NSLog(@"串行队列同步任务二:%@",[NSThread currentThread]);
        for (int i = 0; i< 10; i++)
        {
            NSLog(@"2_%d",i);
        }

    });
    //自己创建的队列,mrc情况下需要自己销毁
    //dispatch_release(serialQueue);
    
    
    // 第一个参数是选取按个全局队列，一般采用DEFAULT，默认优先级队列(DISPATCH_QUEUE_PRIORITY_HIGH,DISPATCH_QUEUE_PRIORITY_DEFAULT,DISPATCH_QUEUE_PRIORITY_LOW)
    // 第二个参数是保留标志，目前的版本没有任何用处(不代表以后版本)，直接设置为0就可以了
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        NSLog(@"并行队列异步任务一:%@",[NSThread currentThread]);
        for (int i = 0; i< 10; i++)
        {
            NSLog(@"1_%d",i);
        }
        
        dispatch_sync(globalQueue, ^{
            NSLog(@"并行队列同步任务二:%@",[NSThread currentThread]);
            for (int i = 0; i< 10; i++)
            {
                NSLog(@"2_%d",i);
            }
            
        });
    });
    
    dispatch_async(globalQueue, ^{
        NSLog(@"并行队列异步任务三:%@",[NSThread currentThread]);
        for (int i = 0; i< 10; i++)
        {
            NSLog(@"3_%d",i);
        }
        
    });
    
    
}


//创建单例
+ (instancetype)shareInstance
{
    //    dispatch_async(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
    //    dispatch_once(<#dispatch_once_t * _Nonnull predicate#>, <#^(void)block#>)
    
    //对比第一个参数创建,dispatch_once的第一个参数是断言的指针,用这个断言的指针来确定这个代码块是否执行
    //dispatch_once_t *predicate对象必须是全局或者静态对象。这一点很重要，如果不能保证这一点，也就不能保证该方法只会被执行一次。
    //这个断言的指针必须要全局化的保存，或者放在静态区内。如果使用存放在自动分配区域或者动态区域的断言，dispatch_once执行的结果是不可预知的。

    static ViewController *viewCtr = nil;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        viewCtr = [[ViewController alloc] init];
    });
    return viewCtr;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
