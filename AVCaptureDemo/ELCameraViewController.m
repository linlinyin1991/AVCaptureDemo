//
//  ELCameraViewController.m
//  AVCaptureDemo
//
//  Created by yin linlin on 2018/5/17.
//  Copyright © 2018年 yin linlin. All rights reserved.
//

#import "ELCameraViewController.h"
#import "ELCameraControlCapture.h"
#import "ELCameraSettingView.h"

@interface ELCameraViewController ()

@property (nonatomic, strong) ELCameraControlCapture *cameraCapture;

@end

@implementation ELCameraViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraCapture startSession];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.cameraCapture stopSession];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}
- (void)setUI {
    [self setVideoPreview];
    [self setCameraView];
    [self.cameraCapture startSession];
}


- (void)setVideoPreview {
    AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.cameraCapture.captureSession];
    preLayer.frame = self.view.bounds;
    preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:preLayer];
}


- (void)setCameraView {
    ELCameraSettingView *view = [[ELCameraSettingView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    [view.cameraBtn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    if (!self.cameraCapture.canSwitchCamera) {
        view.switchBtn.hidden = YES;
    } else {
        [view.switchBtn addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)takePhoto {
    __weak typeof(self) weakself = self;
    [self.cameraCapture takePhoto:^(UIImage *image, NSError *error) {
        if (error) {
            NSLog(@"拍照失败:%@",error);
            return;
        }
        if (image) {
            [weakself saveImageToPhotoAlbum:image];
        }
    }];
}

- (void)switchCamera {
    [self.cameraCapture switchCamera];
}

- (ELCameraControlCapture *)cameraCapture {
    if (!_cameraCapture) {
        _cameraCapture = [[ELCameraControlCapture alloc] init];
    }
    return _cameraCapture;
}

#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
