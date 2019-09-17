//
//  TSViewModelFactory.m
//  Tetris
//
//  Created by Junren Wong on 2019/2/11.
//

#import "TSViewModelFactory.h"
#import "TSCreator.h"
#import "TSStream.h"
#import <objc/runtime.h>

@interface TSViewModelSubject : NSObject

@property (nonatomic, weak) id<TSViewModelLifeController> lifeController;

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<TSViewModelable>> *viewModels;

@end

@implementation TSViewModelSubject

- (id<TSViewModelable>)getViewModelWithType:(Class<TSViewModelable>)aType {
    return self.viewModels[NSStringFromClass(aType)];
}

- (void)setViewModel:(id<TSViewModelable>)viewModel withType:(Class<TSViewModelable>)aType {
    self.viewModels[NSStringFromClass(aType)] = viewModel;
}

- (NSMutableDictionary<NSString *,id<TSViewModelable>> *)viewModels {
    if (!_viewModels) {
        _viewModels = [[NSMutableDictionary<NSString *,id<TSViewModelable>> alloc] init];
    }
    return _viewModels;
}
@end

#pragma mark - TSViewModelFactory

@interface TSViewModelFactory () {
    NSOperationQueue *_viewModelFactoryQueue;
//    NSMutableArray<TSViewModelSubject *> *_subjects;
    NSMutableDictionary<NSString *, TSViewModelSubject *> *_subjects;
}
@end

@implementation TSViewModelFactory

static TSViewModelFactory *_sharedFactory;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFactory = [[TSViewModelFactory alloc] init];
    });
    return _sharedFactory;
}

- (instancetype)init {
    if (self = [super init]) {
        _subjects = [NSMutableDictionary dictionary];
        _viewModelFactoryQueue = [[NSOperationQueue alloc] init];
        _viewModelFactoryQueue.name = [NSString stringWithFormat:@"com.tetris.viewModelFactory.queue.%@", self];
    }
    return self;
}

- (id<TSViewModelable>)createViewModel:(Class<TSViewModelable>)aType lifeController:(id<TSViewModelLifeController>)lifeController {
    __block id<TSViewModelable> obj = nil;
    [self queueExecute:^{
        
        NSString *identifier = [lifeController lifeIdentifier];
        TSViewModelSubject *subject = _subjects[identifier];
        // if subject doesn't exists, create
        if (!subject) {
            subject = [TSViewModelSubject new];
            // this is a weak reference
            subject.lifeController = lifeController;
            // store
            _subjects[identifier] = subject;
            
            [lifeController onLifeEnding:^{
                // remove subject
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self queueExecute:^{
                        [_subjects removeObjectForKey:identifier];
                    }];
                });
            }];
        }
        
        id<TSViewModelable> viewModel = [subject getViewModelWithType:aType];
        // if viewmodel doesn't exists, create
        if (!viewModel) {
            viewModel = [[TSCreator shared] createByClass:aType];
            [subject setViewModel:viewModel withType:aType];
        }
        
        obj = viewModel;
        
    }];
    
    return obj;
}

- (void)queueExecute:(void (^)(void))action {
    [_viewModelFactoryQueue addOperations:@[[NSBlockOperation blockOperationWithBlock:action]] waitUntilFinished:YES];
}

@end


#pragma mark - UIViewController

@interface _TSHanger : NSObject
@property (nonatomic, strong) TSDrivenStream *stream;
@end
@implementation _TSHanger
- (instancetype)init {
    if (self = [super init]) {
        _stream = [TSDrivenStream new];
    }
    return self;
}
- (void)dealloc {
    [_stream post:self];
    [_stream close];
    _stream = nil;
}
@end

@implementation NSObject (TSViewModelLifeController)

- (NSString *)lifeIdentifier {
    return [NSString stringWithFormat:@"%@<%p>", NSStringFromClass(self.class), self];
}

- (void)onLifeEnding:(void (^)(void))ending {
    [[[self _getTSHanger] stream] subscribeNext:^(id  _Nullable obj) {
       !ending ?: ending();
    }];
}

- (void)onDestroy:(void (^)(void))onDestroy {
    [[[self _getTSHanger] stream] subscribeNext:^(id  _Nullable obj) {
        !onDestroy ?: onDestroy();
    }];
}

- (_TSHanger *)_getTSHanger {
    _TSHanger *hanger = objc_getAssociatedObject(self, _cmd);
    if (!hanger) {
        hanger = [_TSHanger new];
        objc_setAssociatedObject(self, _cmd, hanger, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return hanger;
}

@end
