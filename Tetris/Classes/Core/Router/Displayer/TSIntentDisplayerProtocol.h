//
//  TSIntentDisplayerProtocol.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/30.
//

#ifndef TSIntentDisplayerProtocol_h
#define TSIntentDisplayerProtocol_h



@class UIViewController;

NS_ASSUME_NONNULL_BEGIN

/**
 ViewIntent Displayer Protocol
 */
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

#endif /* TSIntentDisplayerProtocol_h */
