//
//  ViewController.m
//  iOSCapture
//
//  
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController ()

@end

@implementation ViewController

void savePixelBufferAsPNG(CVPixelBufferRef pixelBuffer, NSString *filePath) {
    // Create a CIImage from the pixel buffer
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];

    // Create a CIContext
    CIContext *ciContext = [CIContext contextWithOptions:nil];

    // Create a CGImage from the CIImage
    CGImageRef cgImage = [ciContext createCGImage:ciImage fromRect:ciImage.extent];

    // Create a URL for the file path
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:filePath];

    // Create an image destination
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);

    // Add the image to the destination
    CGImageDestinationAddImage(destination, cgImage, nil);

    // Finalize the image destination
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", filePath);
    }

    // Clean up
    CGImageRelease(cgImage);
    CFRelease(destination);
    //CFRelease(url);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self._arsession = [[ARSession alloc] init];
    [self._arsession setDelegate: self];
    ARConfiguration* configuration = [[ARWorldTrackingConfiguration alloc] init];
    //NSLog(@"device support ARKit ? %@",  [configuration isSupported]);
    
    //[self._arsession runWithConfiguration:configuration options:nil];
    
    // Create ARSCNView
        self.arSceneView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.arSceneView];
        
        // Set ARSession to ARSCNView
        self.arSceneView.session = self._arsession;
    
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
    
    ARCamera* camera = frame.camera;
    if (camera == nil) {
        NSLog(@"Camera nil");
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *file_name = [NSString stringWithFormat:@"/%d.png", frame.timestamp];
    
    CVPixelBufferRef pixelBuffer = frame.capturedImage;
    savePixelBufferAsPNG(pixelBuffer, [basePath stringByAppendingString:file_name]);
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
    NSString *txt_file_name = [NSString stringWithFormat:@"%@/%f.txt",basePath, frame.timestamp];
    
    NSString* row1 = [NSString stringWithFormat:@"%f %f %f %f",camera.transform.columns[0][0], camera.transform.columns[1][0], camera.transform.columns[2][0],camera.transform.columns[3][0]];
    NSString* row2 = [NSString stringWithFormat:@"%f %f %f %f",camera.transform.columns[0][1], camera.transform.columns[1][1], camera.transform.columns[2][1],camera.transform.columns[3][1]];
    NSString* row3 = [NSString stringWithFormat:@"%f %f %f %f",camera.transform.columns[0][2], camera.transform.columns[1][2], camera.transform.columns[2][2],camera.transform.columns[3][2]];
    NSString *content = [NSString stringWithFormat:@"%f %f %f %f %@ %@ %@", fx, fy, cx, cy, row1, row2, row3];
            // Write content to file
            NSError *error = nil;
            BOOL success = [content writeToFile:txt_file_name atomically:YES encoding:NSUTF8StringEncoding error:&error];
            
            // Check if writing was successful
            if (success) {
                NSLog(@"File was written successfully.");
            } else {
                NSLog(@"Error writing file: %@", error.localizedDescription);
            }
}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    
}
- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    
}
- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Create ARWorldTrackingConfiguration
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    
    // Run ARSession
    [self._arsession runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause ARSession
    [self._arsession pause];
}


@end
