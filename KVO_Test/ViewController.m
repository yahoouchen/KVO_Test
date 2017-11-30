//
//  ViewController.m
//  KVO_Test
//
//  Created by UCS on 2017/11/30.
//  Copyright © 2017年 UCS. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self KVOTest];
    [self removeDuplicateData];//其他一些去重的方法
    
    [self.tableview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

//KVO
- (void) KVOTest{
    NSArray *priceArray = @[@"1",@"2",@"3",@"4",@"5"];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < priceArray.count; ++i) {
        Person *testModel = [[Person alloc] init];
        testModel.price = [priceArray[i] doubleValue];
        [dataArray addObject:testModel];
        
    }
    
    id count1 = [dataArray valueForKeyPath:@"@count"];     // 5
    id count2 = [dataArray valueForKeyPath:@"@sum.price"]; // 15
    id count3 = [dataArray valueForKeyPath:@"@avg.price"]; // 3
    id count4 = [dataArray valueForKeyPath:@"@max.price"]; // 5
    id count5 = [dataArray valueForKeyPath:@"@min.price"]; // 1
    NSLog(@"count1=%@,count2=%@,count3=%@,count4=%@,count5=%@",count1,count2,count3,count4,count5);
    
    NSArray *array = [NSArray arrayWithObjects:@"6.0", @"9.3", @"3.0", @"12.0", @"11", nil];
    id sum = [array valueForKeyPath:@"@sum.floatValue"];
    id avg = [array valueForKeyPath:@"@avg.floatValue"];
    id max = [array valueForKeyPath:@"@max.floatValue"];
    id min = [array valueForKeyPath:@"@min.floatValue"];
    NSLog(@"sum=%@,avg=%@,max=%@,min=%@",sum,avg,max,min);
    
    //删除重复数据
    NSArray *groupDataArr = @[@"name", @"age", @"year", @"weight", @"age"]; //返回的是一个新的数组
    NSArray *newArray = [groupDataArr valueForKeyPath:@"@distinctUnionOfObjects.self"];
    NSLog(@"%@", newArray);
    
    //进行实例方法的调用
    NSArray *slArray = @[@"name", @"w", @"aa", @"ZXPing"];
    NSLog(@"slArray==%@", [slArray valueForKeyPath:@"length"]);
   
}


//去重的方法
- (void) removeDuplicateData{
    
  NSArray *dataArray = @[@"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-03",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-04",@"2017-04-06",@"2017-04-08",
                           @"2017-04-05",@"2017-04-07",@"2017-04-09",];
    
    //1、使用NSDictionary的AllKeys（AllValues）方法
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    for(NSString *str in dataArray)
    {
        [dic setValue:str forKey:str];
    }
    NSLog(@"%@",[dic allKeys]);
    
    
    //2、利用NSSet的AllObjects方法
    NSSet *set = [NSSet setWithArray:dataArray];
    NSLog(@"%@",[set allObjects]);
    
    
    //3、利用数组的containsObject来去除
    NSMutableArray *listAry = [[NSMutableArray alloc]init];
    for (NSString *str in dataArray) {
        if (![listAry containsObject:str]) {
            [listAry addObject:str];
        }
    }
    NSLog(@"%@",listAry);
    
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGFloat offset = self.tableview.contentOffset.y;
    CGFloat delta = offset / 64.f + 1.f;
    delta = MAX(0, delta);
    self.navigationController.navigationBar.alpha = MIN(1, delta);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
