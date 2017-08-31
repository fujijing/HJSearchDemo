# HJSearchDemo
实现带历史记录的搜索功能，菜鸟一枚，需记录下来以便以后查阅。代码中的布局使用Masonry，另外还使用了ReactiveCocoa来处理删除某条历史记录、清空历史记录等操作的消息传递。
### 搜索框UI自定义
![A574C7A4-8948-4BC9-B033-58944A3AD32C.png](http://upload-images.jianshu.io/upload_images/1970838-fd5e50afb9c28672.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

上图是要实现的效果，下面来看看具体的实现。这里我使用的是系统的UISearchBar控件，首先要考虑的是如何实现搜索框背景颜色，光标颜色的改变，以及如何将系统放大镜等图片替换成我们想要的样子。
添加UISearchBar在VC上，运行一下，我们可以看到其效果：
```

_searchBar = [[UISearchBar alloc] init];
_searchBar.backgroundColor = [UIColor clearColor];
_searchBar.showsCancelButton = NO;
[_searchBgView addSubview:_searchBar];

```

![3C74223F-D9A6-4DE0-A1A0-F387D4C4FEC7.png](http://upload-images.jianshu.io/upload_images/1970838-55e4dc70992896c6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

发现将searchBar的背景颜色设置为clearColor并不能去掉其灰色的边框，查看文档，发现其还有两个关于颜色设置的属性，其中tintColor可以用来改变输入光标的的颜色，另外文档里说可以使用-barTintColor来调整搜索框的背景颜色。
```
/*
 The behavior of tintColor for bars has changed on iOS 7.0. It no longer affects the bar's background
 and behaves as described for the tintColor property added to UIView.
 To tint the bar's background, please use -barTintColor.
 */
@property(null_resettable, nonatomic,strong) UIColor *tintColor;
@property(nullable, nonatomic,strong) UIColor *barTintColor NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;  // default is nil
```
于是设置searchBar.barTintColor = [UIColor whiteColor];运行效果如下图所示：

![C6000359-8D0A-4315-9D81-4B8AD4861358.png](http://upload-images.jianshu.io/upload_images/1970838-c66072897ef31656.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

结果是出现上线两条线，并没有完全消除背景颜色，根据网友资料，在控制台通过命令打印出UISearchBar的视图层次结构如下：
```
<UISearchBar: 0x7fb6586b6ca0; frame = (10 30; 355 30); text = ''; tintColor = UIDeviceRGBColorSpace 1 0.5 0 1; gestureRecognizers = <NSArray: 0x7fb6586bab20>; layer = <CALayer: 0x7fb658609540>>
   | <UIView: 0x7fb6586b9e00; frame = (0 0; 355 30); clipsToBounds = YES; autoresize = W+H; layer = <CALayer: 0x7fb65869f110>>
   |    | <UISearchBarBackground: 0x7fb6586baff0; frame = (0 0; 355 30); opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x7fb6586bb4c0>>
   |    | <UISearchBarTextField: 0x7fb658525ce0; frame = (0 0; 0 0); text = ''; clipsToBounds = YES; opaque = NO; layer = <CALayer: 0x7fb658505960>>
   |    |    | <_UISearchBarSearchFieldBackgroundView: 0x7fb658419960; frame = (0 0; 0 0); opaque = NO; autoresize = W+H; userInteractionEnabled = NO; layer = <CALayer: 0x7fb658409dc0>>
```
可以移除UISearchBarBacground来移除背景颜色
```
        for (UIView *subView in _searchBar.subviews) {
            if ([subView isKindOfClass:[UIView  class]]) {
                [[subView.subviews objectAtIndex:0] removeFromSuperview];
            }
        }
```
移除了背景颜色，接下来要修改输入框的背景颜色和放大镜图片，此时UIView中就剩下一个UITextField，系统默认的放大镜图片可通过设置UITextField的leftView来设置，打印UITextField的leftView，可以看出其是一个UIImageView，具体信息如下
```
(lldb) po textField.leftView
<UIImageView: 0x7f8df3f1b870; frame = (0 0; 13 13); opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x7f8df3f13d40>>
```
具体实现代码和实现效果如下：
```
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.showsCancelButton = NO;
        _searchBar.tintColor = [UIColor orangeColor];
        _searchBar.placeholder = @"搜索感兴趣的内容";
        
        for (UIView *subView in _searchBar.subviews) {
            if ([subView isKindOfClass:[UIView  class]]) {
                [[subView.subviews objectAtIndex:0] removeFromSuperview];
                if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                    UITextField *textField = [subView.subviews objectAtIndex:0];
                    textField.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                    
                    //设置输入框边框的颜色
//                    textField.layer.borderColor = [UIColor blackColor].CGColor;
//                    textField.layer.borderWidth = 1;
                    
                    //设置输入字体颜色
//                    textField.textColor = [UIColor lightGrayColor];
                    
                    //设置默认文字颜色
                    UIColor *color = [UIColor grayColor];
                    [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"搜索感兴趣的内容"
                                                                                        attributes:@{NSForegroundColorAttributeName:color}]];
                    //修改默认的放大镜图片
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
                    imageView.backgroundColor = [UIColor clearColor];
                    imageView.image = [UIImage imageNamed:@"gww_search_ misplaces"];
                    textField.leftView = imageView;
                }
            }
        }
        
        [_searchBgView addSubview:_searchBar];
```

![4F12C076-C4B5-4D12-A980-6950BA32274C.png](http://upload-images.jianshu.io/upload_images/1970838-4dfb0a8783a45788.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

有些需求可能会要求限制输入的次数，这里限制字数20，超出及给个弹窗提示，具体实现如下：
```
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] > 20) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"字数不能超过20" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:nil completion:nil];
        [_searchBar setText:[searchText substringToIndex:20]];
    }
}
```
### 历史记录功能实现
搜索框已经按照我们想要的样式修改完毕，接下来要实现的是历史记录功能。搜索历史的弹出使用[DXPopver](https://github.com/xiekw2010/DXPopover),这里我是写了一个tableViewController放到popper中来进行历史记录的展示。首先我们需要定义一个数组来存储搜索记录，同时要将记录存储到端上，这里定义了一个单例用来存储记录：
```

#import "APPUserDefaults.h"

@implementation APPUserDefaults

+(id)instance
{
    static APPUserDefaults *_instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _instance = [[APPUserDefaults alloc] init];
    });
    return _instance;
}

-(void)setUserSearchHistory:(NSMutableArray *)array
{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"SearchRecord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)getUserSearchHistory
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchRecord"];
}
@end
```

存储好搜索记录之后，每次点击搜索框，如果之前有历史记录就要显示，如没有则不用显示
```
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // when we start to write sth, the record should display to us
    if (_historyArray.count != 0) {
        _historyViewController.historyRecords = _historyArray;
        [self showTheHistoryRecords];
        [self.searchBar becomeFirstResponder];
    }
}
- (void)showTheHistoryRecords
{
    CGPoint startPoint = CGPointMake(CGRectGetWidth(self.view.frame), 64);
    [self.popover showAtPoint:startPoint
               popoverPostion:DXPopoverPositionDown
              withContentView:self.historyViewController.view
                       inView:self.view];
    self.popover.didDismissHandler = ^{
        
    };
}

- (void)hiddenTheHistoryRecords
{
    [self.popover dismiss];
}
```
搜索的时候要记录搜索历史，在点击空格键，在点击搜索时，没有匹配的内容出现，但是搜索历史里面会留下一行“空白”的记录，点击多下空格时，同样会出现这个问题，然而我们的搜索历史并不需要存储这个空格。

![EB317CA8-DE59-48DD-8263-6B6F2CF28EF2.png](http://upload-images.jianshu.io/upload_images/1970838-02732bd094ef08a7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这里我们就要识别输入的字符是不是空格，如果是空格，就不对其进行存储，因为可能会出现多个空格的情况，就不能简单的使用
```
[_searchBar.text isEqualToString:@" "];
```

这里使用NSPredicate谓词来判断输入的字符是否为一个或者多个空格
```
NSString *regex = @"\\s*";
```
这里\s是正则表达式，匹配任何空白字符
*，匹配当期表达式一次或者多次
```
    NSString *regex = @"\\s*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![_historyArray containsObject:_searchBar.text] && ![pred evaluateWithObject:_searchBar.text]) {
        [_historyArray insertObject:_searchBar.text atIndex:0];
    }
    
```
### 本地内容及时搜索
许多 app 都支持对本地内容的及时搜索，这里简单实现了该功能，直接上代码
```
    words = [words uppercaseString];  //搜索关键字，可以是中文，也可以是拼音或者缩写
    NSMutableArray *array = [NSMutableArray array]; //用来存储搜索结果
    //self.dataArray 中存储着本地信息，逐项对比，看是不是我们所要的结果，self.cachePinyinDict 中存储着本地信息的拼音转换结果 例如 影视对应 yingshi ys
    for (NSString *name in self.dataArray) {
        NSString *pinyin = [self.cachePinyinDict objectForKey:name];
        pinyin = pinyin.uppercaseString;
        if ([name rangeOfString:words].length > 0) {
            [array addObject:name];
        }else if ([pinyin rangeOfString:words].length > 0 && [pinyin rangeOfString:words].location == 0) {
            [array addObject:name];
        }
    }

```

拼音的转化采用了第三方 PinyinHelper 工具
```
- (void)cachePinyin
{
    if (!self.dataArray.count) return;
    
    for (NSString *name in self.dataArray) {
        NSString *p = [self.cachePinyinDict objectForKey:name];
        if (p == nil) {
            p = [[PinyinHelper getPinyin:name  isXingshi:NO] join:@" "];
            self.cachePinyinDict[name] = p;
        }
    }
}
```
具体实现结果

![9FC0286E-6CEC-47EB-8678-B55E152054EC.png](http://upload-images.jianshu.io/upload_images/1970838-d4546b8da5d5c495.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

