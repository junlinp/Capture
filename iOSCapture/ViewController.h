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
@end

