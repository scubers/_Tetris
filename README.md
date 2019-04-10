# Tetris

[![CI Status](https://img.shields.io/travis/wangjunren/Tetris.svg?style=flat)](https://travis-ci.org/wangjunren/Tetris)
[![Version](https://img.shields.io/cocoapods/v/Tetris.svg?style=flat)](https://cocoapods.org/pods/Tetris)
[![License](https://img.shields.io/cocoapods/l/Tetris.svg?style=flat)](https://cocoapods.org/pods/Tetris)
[![Platform](https://img.shields.io/cocoapods/p/Tetris.svg?style=flat)](https://cocoapods.org/pods/Tetris)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Tetris is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Tetris'
```

## 描述

模块化开发工具，包括VC跳转方式控制，路由跳转，拦截器，依赖注入，等功能

## 使用

- [生命周期]()

  - [生命周期分发]()

  - [生命周期监听]()

- [依赖注入]()

  - [定义]()

  - [实现、注册]()

  - [调用]()

- [跳转控制]()

  - [Displayer]()

- [路由跳转]()

- [拦截器]()

#### 1、生命周期

一个**APP**管理生命周期的对象为**AppDelegate**，但是模块化开发后，壳工程的**Delegate**属于最下层应用，无法被上层业务依赖。但是模块需要依赖**app**生命周期做一些初始化或者监听代码。库提供了生命周期分发的功能

1、通过接管AppDelegate，内部调用 `trigger` 的方法进行声明周期分发。

```objectivec
// 分发生命周期，需要接管appDelegate的方法，壳工程的delegate中添加需要分发的代码
@implementation TSBaseApplicationDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    TSModuleContext *context = [TSModuleContext shared];
    context.launchOptions = launchOptions;
    [_Tetris.modular.trigger tetrisModuleInit:context];
    [_Tetris.modular.trigger tetrisModuleSetup:context];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_Tetris.modular.trigger tetrisModuleSplash:context];
    });
    [_Tetris.modular.trigger application:application willFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [_Tetris.modular.trigger application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

```

2、模块需要通过注册生命周期接收器来实现生命周期监听

Objective-C

```objectivec
@interface TSDemoModules () <TSModularComposable>
@end
  
@implementation TSDemoModules
  
TS_MODULE(TSModulePriorityHigh)// 通过注解注册生命周期监听

- (void)tetrisModuleInit:(TSModuleContext *)context {
    NSLog(@"%@, %s", self, __FUNCTION__);
}
- (void)tetrisModuleSetup:(TSModuleContext *)context {
    NSLog(@"%@, %s", self, __FUNCTION__);
}
- (void)tetrisModuleSplash:(TSModuleContext *)context {
    NSLog(@"%@, %s", self, __FUNCTION__);
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
		// do something at launch in your module
    return YES;
}
```

Swift

```swift
class SwiftModules1: NSObject, Modularable {
    required override init() {
        super.init()
    } 
	  var priority: ModulePriority = TSModulePriorityNormal
  	func applicationDidBecomeActive(_ application: UIApplication) {
  			// do something on become active      
    }
}
```



#### 2、依赖注入，IOC

模块化拆分后，存在跨模块调用的问题。上下依赖的模块能直接代码依赖，但是横向模块间理论上来说不能进行代码依赖。

所以跨模块数据访问我们提供了一个思路就是底层定义接口，上层分别实现和调用接口。

1、定义接口

```objectivec
@protocol TSServiceA
- (void)methodA;
@end
```

2、实现接口，并且注册

OC

```objectivec
// 对象实现ServiceA, 并且需要实现TSServiceable接口即可
@interface TSServiceAImpl : NSObject<TSServiceA, TSServiceable>
@end
@implementation TSServiceAImpl
TS_SERVICE(TSServiceA, YES)// 注册服务，Bool参数为是否单例
- (void)methodA {
    NSLog(@"method a execute");
}
@end
```

Swift

```swift
// 实现IServiceable, Component, TSServiceA 协议
class Services : NSObject, IServiceable, Component, TSServiceA {
    required override init() {
        super.init()
    }
    static var interface: Protocol? = TestProtocolA.self
    static var name: String?
    static var singleton: Bool = false
    func methodA() {
        print("--swift servcie---")
    }
}
```



3、获取对象，进行调用

OC

```objectivec
- (void)someMethod {
  	// 获取实现，调用方法
		[TS_GET_SERVICE(TSServiceA) methodA];
}
```

Swift

```swift
func someMethod() {
	  let service: TSServiceA? = Tetris.getService(TSServiceA.self)
  	service?.methodA()
}
```

#### 3、跳转控制

**iOS**的**VC**栈存在两种默认情况，每个VC都提供一个展示另一个VC的能力（**Present**），内置一个控制器栈（**NavigationController**）。不同的栈进入和退出的方式都不一样。如何进入，就需要对应的方式如何退出。

比如有一个公共的VC，可能有人需要push，有人需要present。那我们只能从最原始的获取VC，然后手动跳转。这会导致一个障碍，因为进入方式VC不可见，所以VC不能自我销毁，每个销毁操作都需要依赖自己的上层。

本库提供一个Intent，通过Intent描述你的跳转操作。进而通过Intent进行操作跳转，达到VC自我控制销毁操作。

能跳转的VC都需要实现 `TSIntentable` 协议

```
NS_SWIFT_NAME(Intentable)
@protocol TSIntentable <TSCreatable, TSViewControllable, NSObject>
  
@property (nonatomic, strong, nullable) TSIntent *ts_sourceIntent;

- (instancetype)initWithIntent:(TSIntent *)intent;

@optional
// 拦截器相关
+ (nullable id<TSIntercepter>)ts_selfIntercepter;

@end
```



```objectivec
- (void)func {
    TSIntent *intent = [TSIntent intentWithClass:[UIViewController class]];
    intent.displayer = [TSPushPopDisplayer new];
    [[_Tetris.router prepare:intent source:self] subscribeNext:^(TSRouteResult * _Nullable obj) {
        // 跳转成功
    } error:^(NSError * _Nonnull error) {
        // 跳转出错
    }];  
  	
  	// UIViewController 已经有分类方法提供 ts_start: 进行跳转
	//[self ts_start:intent];
}

```

###### Displayer

之前说到若我们想VC自我控制销毁操作，我们必须依赖之前的进入方式。为了将两个VC能够实现一定程度的解耦以及自我销毁的操作。这里提供一个**Displayer**接口，来实现跳转方式。

```objectivec
NS_SWIFT_NAME(IIntentDisplayer)
@protocol TSIntentDisplayerProtocol

@required

/**
 Show a viewController
 
 @param fromVC ViewController that transition from
 @param toVC ViewController where transition to
 @param animated If animated?
 @param completion Completion handler
 */
- (void)ts_displayFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

/**
 Finish display given ViewController
 
 @param vc ViewController that will be finished
 @param animated If animated
 @param completion Completion handler
 */
- (void)ts_finishDisplayViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;


/**
 Make sure the given ViewController show on the top hierarchy;
 But not work if the vc not on the view hierachy;
 
 @param vc vc that need to display
 @param animated If animated
 @param completion Completion handler
 */
- (void)ts_setNeedDisplay:(UIViewController *)vc animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END

```

可以继承自 **TSDisplayerAdapter** 后自己实现自定义的转场动画，并且可以抽离出来，达到代码共用效果。

`TSPushPopDisplayer` `TSPresentDismissDisplayer`

#### 4、路由跳转

**Intent**提供多种方式创建

```
@interface TSIntent (Creations)
- (instancetype)initWithUrl:(NSString *)urlString; // 指定Url
- (instancetype)initWithClass:(Class<TSIntentable>)aClass; // 指定class
- (instancetype)initWithDisplayer:(id<TSIntentDisplayerProtocol>)displayer; // 指定Displayer
- (instancetype)initWithFactory:(TSIntentableFactoryBlock)factory; // 指定工厂方法
@end
```

1、**URL**绑定方式

通过指定**URL**，那就有**URL**绑定到VC的操作

```objectivec
// 创建一个VC
@interface TSDemo1ViewController ()
@end

@implementation TSDemo1ViewController
// 通过注解绑定VC和路由
TS_ROUTE_MSG(@"/demo1", @"Message that descripe this vc")
@end
```

#### 5、拦截器（Intercepter）

当我们进行跳转的时候，可能有些界面会有需要前置条件，比如需要登录才能进入某个界面。若有非常多的地方需要进入，那会让我们每个入口都需要检测是否已经登录，然后调用登录界面，然后回调后进行目标界面跳转。这样会导致重复代码很多。

这里提供一个拦截器的组件，用于拦截我们通过**Intent**的所有跳转。（注意：通过工厂方法创建的intent，暂时不会被拦截：后期可能提供拦截token支持拦截）

```objectivec
NS_SWIFT_NAME(Intercepter)
@protocol TSIntercepter <TSCreatable>
// 优先级
@property (nonatomic, assign) TSIntercepterPriority priority;

/**
 Do intercepter logic;
 In intercepter life cycle, should call adjudger's doSwitch or doReject or doContinue once;
 // 在一次拦截周期内，至少调用judger.doSwitch or doReject or doContinue 其中一个一次
 @param judger The judger
 */
- (void)ts_judgeIntent:(id<TSIntercepterJudger>)judger;

@end
```

若设置了拦截器，则**Intent**的所有跳转都会经过拦截器拦截，并且拦截顺序根据拦截器的优先级执行。

注册拦截器

```objectivec
// 继承adapter，或者自己实现接口都可以
@interface RIDemo14Intercepter : TSIntercepterAdapter
@end
@implementation RIDemo14Intercepter
// 通过注解注册拦截器，指定优先级
TS_INTERCEPTER(TSIntercepterPriorityHigh)
  
- (void)ts_judgeIntent:(id<TSIntercepterJudger>)adjudgement {
    if ([self hasLogin]) {
      	// 若已经登录，则继续执行后面的拦截器
        [adjudgement doContinue];
    } else {
      	// 若未登录，则创建需要登录界面，
        TSIntent *loginIntent; //xxxxxx
        [loginIntent.onSuccess subscribeNext:^(TSResult * _Nullable obj) {、
          	// 当登录完成时，重启之前的intent
            [adjudgement restart];
        }];
      	// 切换到登录界面
        [adjudgement doSwitch:loginIntent];
    }
}
@end
```



## Author

jr-wong@qq.com

## License

Tetris is available under the MIT license. See the LICENSE file for more info.
