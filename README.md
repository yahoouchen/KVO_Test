
使用KVO高效开发--开发中的一些小技巧

使用KVO

获取数组里的最大值、最小值、平均值、求和

 NSArray *array = [NSArray arrayWithObjects:@"6.0", @"9.3", @"3.0", @"12.0", @"11", nil];
    id sum = [array valueForKeyPath:@"@sum.floatValue"];
    id avg = [array valueForKeyPath:@"@avg.floatValue"];
    id max = [array valueForKeyPath:@"@max.floatValue"];
    id min = [array valueForKeyPath:@"@min.floatValue"];
    NSLog(@"sum=%@,avg=%@,max=%@,min=%@",sum,avg,max,min);

//输出结果：sum=41.3,avg=8.26,max=12,min=3
删除数组里面重复数据

使用distinctUnionOfObjects操作符去取集合的不重复子集

 //删除重复数据
    NSArray *groupDataArr = @[@"name", @"age", @"year", @"weight", @"age"]; //返回的是一个新的数组
    NSArray *newArray = [groupDataArr valueForKeyPath:@"@distinctUnionOfObjects.self"];
    NSLog(@"%@", newArray);
//输出结果
/*(
    name,
    age,
    year,
    weight
)
*/
还可以嵌套调用，比如，取一个数据的不重复子集，然后再输出总和，这里注意@distinctUnionOfObjects和@sum不能直接在一个keyPath中连接，所以需要两次调用valueForKeyPath：

NSArray *array = @[@1, @2, @2, @2, @2, @3];
//先取不重复的子集，然后计算总和
//注意@distinctUnionOfObjects和@sum不能直接在一个keyPath中连接，所以需要两次调用valueForKeyPath
NSLog(@"%@", [[array valueForKeyPath:@"@distinctUnionOfObjects.self"] valueForKeyPath:@"@sum.self"]);
在实际工作过程中经常会遇到在数组中有重复的数据，可是如何去掉重复数据呢？下面列举出其他去重的方法：
1、使用NSDictionary的AllKeys（AllValues）方法
NSArray *dataArray = @[@"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-03",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-04",@"2017-04-06",@"2017-04-08",
                           @"2017-04-05",@"2017-04-07",@"2017-04-09",];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];  
    for(NSString *str in dataArray)  
    {  
        [dic setValue:str forKey:str];  
    }  
    NSLog(@"%@",[dic allKeys]);
输出结果： (
"2017-04-02",
"2017-04-08",
"2017-04-01",
"2017-04-07",
"2017-04-06",
"2017-04-05",
"2017-04-04",
"2017-04-03",
"2017-04-09"
)

2、利用NSSet的AllObjects方法

NSArray *dataArray = @[@"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-03",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-04",@"2017-04-06",@"2017-04-08",
                           @"2017-04-05",@"2017-04-07",@"2017-04-09",]; 
   NSSet *set = [NSSet setWithArray:dataArray];  
   NSLog(@"%@",[set allObjects]); 
输出结果：
(
"2017-04-01",
"2017-04-02",
"2017-04-03",
"2017-04-04",
"2017-04-06",
"2017-04-08",
"2017-04-05",
"2017-04-07",
"2017-04-09"
)

3、利用数组的containsObject来去除

NSArray *dataArray = @[@"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-03",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-01",@"2017-04-02",@"2017-04-03",
                           @"2017-04-04",@"2017-04-06",@"2017-04-08",
                           @"2017-04-05",@"2017-04-07",@"2017-04-09",];  
    NSMutableArray *listAry = [[NSMutableArray alloc]init];  
    for (NSString *str in dataArray) {  
        if (![listAry containsObject:str]) {  
            [listAry addObject:str];  
        }  
    }  
    NSLog(@"%@",listAry); 
打印结果：
(
"2017-04-01",
"2017-04-02",
"2017-04-03",
"2017-04-04",
"2017-04-06",
"2017-04-08",
"2017-04-05",
"2017-04-07",
"2017-04-09"
)

好了！上面是一些关于去重的方法，我们回到KVO来，请继续观看下面👇

使用KVO来选择一个集合中的元素对应的属性。同时，KVO还有多种集合操作符可以实现对集合数据的快速分析，如下代码：

NSArray *array = @[@"mgen", @"tom", @"martin"];
//选择所有字符串的length为新的数组
NSLog(@"%@", [array valueForKeyPath:@"length"]);
//选择最大长度
NSLog(@"%@", [array valueForKeyPath:@"@max.length"]);
进行实例方法的调用

NSArray *array =  @[@"name", @"age", @"year", @"weight", @"age"]; 
NSLog(@"%@", [array valueForKeyPath:@"uppercaseString"]);
相当于数组中的每个成员执行了uppercaseString方法，然后把返回的对象组成一个新数组返回。既然可以用uppercaseString方法，那么NSString的其他方法也可以，比如[array valueForKeyPath:@"length"]。当然，其他对象的实例方法也可以以此类推来进行调用~！

KVO(key-value-observing)是一种十分有趣的回调机制，在某个对象注册监听者后，在被监听的对象发生改变时，对象会发送一个通知给监听者，以便监听者执行回调操作。

举个例子------渐变导航栏
我们为tableView添加了一个监听者controller，在我们滑动列表的时候，会计算当前列表的滚动偏移量，然后改变导航栏的背景色透明度。

//添加监听者
[self.tableView addObserver: self forKeyPath: @"contentOffset" options: 
NSKeyValueObservingOptionNew context: nil];
/**
 *  监听属性值发生改变时回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context
{
    CGFloat offset = self.tableView.contentOffset.y;
    CGFloat delta = offset / 64.f + 1.f;
    delta = MAX(0, delta);
   self.navigationController.navigationBar.alpha = MIN(1, delta);
}
