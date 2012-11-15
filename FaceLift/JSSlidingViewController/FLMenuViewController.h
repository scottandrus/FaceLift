//
//  FLMenuViewController.h
//  FaceLift
//
//  Created by Scott Andrus on 11/15/12.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FLMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *fbNameLabel;

@end
