//
//  FLViewController.h
//  FaceLift
//
//  Created by Scott Andrus on 9/20/12.
//  Copyright (c) 2012 ENGM274. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MobileCoreServices/MobileCoreServices.h>

@interface FLViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImage *currentImage;
@property (strong, nonatomic) NSDictionary *currentImageInformation;
@property (strong, nonatomic) UIPopoverController *popover;

@property (strong, nonatomic) IBOutlet UIImageView *currentImagePreviewImageView;

- (IBAction)faceRecognition:(id)sender;

@end