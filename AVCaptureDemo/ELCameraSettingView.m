//
//  ELCameraSettingView.m
//  AVCaptureDemo
//
//  Created by yin linlin on 2018/5/18.
//  Copyright © 2018年 yin linlin. All rights reserved.
//

#import "ELCameraSettingView.h"

@interface ELCameraSettingView ()



//闪光灯
@property (nonatomic, strong) UIButton *flashBtn;

@end

@implementation ELCameraSettingView
- (instancetype)init {
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.cameraBtn];
    [self addSubview:self.switchBtn];
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.equalTo(self);
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.right.bottom.equalTo(self).offset(-20);
    }];
}

- (UIButton *)cameraBtn {
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    }
    return _cameraBtn;
}
- (UIButton *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchBtn setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
    }
    return _switchBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
