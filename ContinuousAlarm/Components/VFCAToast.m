//
//  VFCAToast.m
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/17/22.
//

#import "VFCAToast.h"

@import Masonry;

@implementation VFCAToast

+ (void)showToastWithTips:(NSString *)tips completion:(dispatch_block_t)completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [self currentWindow];
        UIView *toast = [self generateToastView];
        UILabel *tipsLabel = [self generateToastLabelWithTips:tips];
        
        [self addTips:tipsLabel toToast:toast];
        [self addToast:toast toWindow:window];
        [self layoutToast:toast tips:tipsLabel basedWindow:window];
        [self startTimerWith:toast completion:completion];
    });
}

#pragma mark - Timer
+ (void)startTimerWith:(UIView *)toast completion:(dispatch_block_t)completion {
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer *timer) {
        [toast removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Components Assembler
+ (void)addTips:(UILabel *)tipsLabel toToast:(UIView *)toast {
    [toast addSubview:tipsLabel];
}

+ (void)addToast:(UIView *)toast toWindow:(UIWindow *)window {
    [window addSubview:toast];
}

+ (void)layoutToast:(UIView *)toast
               tips:(UILabel *)tipsLabel
        basedWindow:(UIWindow *)window {

    [toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(window);
    }];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toast).offset(20);
        make.right.equalTo(toast).offset(-20);
        make.top.equalTo(toast).offset(20);
        make.bottom.equalTo(toast).offset(-20);
    }];
}


#pragma mark - Components Generator
+ (UIView *)generateToastView {
    UIView *toast = [[UIView alloc] init];
    toast.backgroundColor = [UIColor blackColor];
    toast.layer.cornerRadius = 10;
    
    return toast;
}

+ (UILabel *)generateToastLabelWithTips:(NSString *)tips {
    UILabel *label = [[UILabel alloc] init];
    label.text = tips;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    
    return label;
}

+ (nullable UIWindow *)currentWindow {
    UIWindow *result = nil;
    
    NSArray *scenes = [[[UIApplication sharedApplication] connectedScenes] allObjects];
    if (scenes.count > 0) {
        UIScene *scene = [scenes objectAtIndex:0];
        if ([scene.delegate conformsToProtocol:@protocol(UIWindowSceneDelegate)]) {
            id<UIWindowSceneDelegate> delegate = (id<UIWindowSceneDelegate>)scene.delegate;
            result = delegate.window;
        }
    }
    
    return result;
}

@end
