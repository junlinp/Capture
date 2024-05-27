//
//  ViewController.h
//  iOSCapture
//
//  Created by DM on 2024/3/28.
//

#import <UIKit/UIKit.h>
#import "ARKit/ARKit.h"
@interface ViewController : UIViewController<ARSessionDelegate>

@property(strong, atomic) ARSession* _arsession;
@property (nonatomic, strong) ARSCNView *arSceneView;
@property(strong, atomic) dispatch_queue_t backgroundQueue_;
@property(strong, atomic) NSString* directoryPath;
@end

