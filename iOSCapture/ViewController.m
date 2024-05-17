//
//  ViewController.m
//  iOSCapture
//
//  Created by DM on 2024/3/28.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self._arsession = [[ARSession alloc] init];
    [self._arsession setDelegate: self];
    ARConfiguration* configuration = [[ARWorldTrackingConfiguration alloc] init];
    //NSLog(@"device support ARKit ? %@",  [configuration isSupported]);
    
    [self._arsession runWithConfiguration:configuration options:nil];
    
    
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
    
    ARCamera* camera = frame.camera;
    if (camera == nil) {
        NSLog(@"Camera nil");
    }
    //CVPixelBufferRef image_buffer = frame.capturedImage;
    NSLog(@"timestamp %f, TrackingState", frame.timestamp);
    // timestamp
    // transform
    // images
    
    // intrinsic
    float fx = camera.intrinsics.columns[0][0];
    float cx = camera.intrinsics.columns[2][0];
    float fy = camera.intrinsics.columns[1][1];
    float cy = camera.intrinsics.columns[2][1];
    NSLog(@"fx=%f, fy=%f, cx=%f, cy=%f", fx, fy, cx, cy);
    /*
    This transform creates a local coordinate space for the camera that is constant with respect to device orientation. In camera space, the x-axis points to the right when the device is in UIDeviceOrientationLandscapeRight orientation—that is, the x-axis always points along the long axis of the device, from the front-facing camera toward the Home button. The y-axis points upward (with respect to UIDeviceOrientationLandscapeRight orientation), and the z-axis points away from the device on the screen side.
     */
    for(int i = 0; i < 4; i++) {
        NSLog(@"%f, %f, %f, %f",camera.transform.columns[0][i], camera.transform.columns[1][i], camera.transform.columns[2][i],camera.transform.columns[3][i]);
    }
    
    
}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    
}
- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    
}
- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera {
    
}


@end
