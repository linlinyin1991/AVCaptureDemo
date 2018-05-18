//
//  ELCameraBaseCapture.m
//  AVCaptureDemo
//
//  Created by yin linlin on 2018/5/17.
//  Copyright © 2018年 yin linlin. All rights reserved.
//

#import "ELCameraBaseCapture.h"

@implementation ELCameraBaseCapture

- (instancetype)init {
    if (self = [super init]) {
        [self sessionConfig];
    }
    return self;
}

- (void)sessionConfig {
    [self.captureSession beginConfiguration];
    if ([self.captureSession canAddInput:self.captureInput]) {
        [self.captureSession addInput:self.captureInput];
    }
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }
    [self.captureSession commitConfiguration];
}


- (void)startSession {
    if (![self.captureSession isRunning]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.captureSession startRunning];
        });
    }
}


- (void)stopSession {
    if ([self.captureSession isRunning]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.captureSession stopRunning];
        });
    }
}

- (void)takePhoto:(void(^)(UIImage *image, NSError *error))complete {
    AVCaptureConnection *conntion = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!conntion) {
        NSLog(@"拍照失败!");
        if (complete) {
            complete(nil,nil);
        }
        return;
    }
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:conntion completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (error || imageDataSampleBuffer == nil) {
            if (complete)
                complete(nil,error);
            return;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        if (complete)
            complete(image,nil);
    }];
}

#pragma mark - lazy load
- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        //设置session采集质量 
        _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    return _captureSession;
}

- (AVCaptureDevice *)captureDevice {
    if (!_captureDevice) {
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _captureDevice;
}

- (AVCaptureDeviceInput *)captureInput {
    if (!_captureInput) {
        NSError *error;
        _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
    }
    return _captureInput;
}

- (AVCaptureStillImageOutput *)imageOutput {
    if (!_imageOutput) {
        _imageOutput = [[AVCaptureStillImageOutput alloc] init];
        // 这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [_imageOutput setOutputSettings:outputSettings];
    }
    return _imageOutput;
}

@end
