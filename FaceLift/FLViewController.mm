//
//  FLViewController.m
//  FaceLift
//
//  Created by Scott Andrus on 9/20/12.
//  Copyright (c) 2012 ENGM274. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"

#import "opencv2/opencv.hpp"
#import "facerec.hpp"

#import "AppDelegate.h"
#import "FLViewController.h"
#import "FLLoginViewController.h"
#import "SAViewManipulator.h"
#import "FLPerson.h"
#import "UIColor+i7HexColor.h"


// Different Graph endpoints

// Returns a list of people who are attending for all events that
// the signed-in user is also attending. This is the first place
// to look for potential matches.
NSString * const AttendingOfAttending = @"me?fields=events.type(attending).fields(attending.fields(id,name,picture.type(large)))";

// Since people may not hit attend/maybe/decline but still show up anyway,
// the best way to 'expand' the pool of potential people is to look at who hasn't
// responded, since they are the next most likely group to find a match.
NSString * const NoReplyOfAttending = @"me?fields=events.type(attending).fields(noreply.fields(id,name,picture.type(large)))";

//@"me?fields=events.type(not_replied).fields(invited.fields(picture.type(large)))"

@interface FLViewController ()

@end

@implementation FLViewController
@synthesize currentImage = _currentImage;
@synthesize currentImageInformation = _currentImageInformation;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStateChanged:) name:SessionStateChangedNotification object:nil];
    
    fbData = [[NSMutableArray alloc] init];
    
    [self customizeInterface];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (FBSession.activeSession.isOpen)
    {
//        [self populateUserDetails];
    }
    else if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate openSessionWithLoginUI:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (FBSession.activeSession.isOpen
        || FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded
        || FBSession.activeSession.state == FBSessionStateCreatedOpening)
    {
        // Nothing to do.
    }
    else
    {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Facebook

- (void)fetchEventList:(NSString *)graphPath withPeople:(NSString *)listStatus
{
    if (FBSession.activeSession.isOpen)
    {
        FBRequestConnection *requester = [[FBRequestConnection alloc] init];
        FBRequest *request = [FBRequest requestForGraphPath:graphPath];
        [requester addRequest:request
            completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
         {
             if (!error)
             {
                 NSMutableArray *allPeople = [[NSMutableArray alloc] init];
                 NSArray *events = [[result objectForKey:@"events"] objectForKey:@"data"];
                 for (NSDictionary* e in events)
                 {
                     NSArray *list = [[e objectForKey:listStatus] objectForKey:@"data"];
                     for (NSDictionary* u in list)
                     {
                         FLPerson *p = [[FLPerson alloc] init];
                         [p setUid:[u objectForKey:@"id"]];
                         [p setName:[u objectForKey:@"name"]];
                         [p setPictureUrl:[NSURL URLWithString:[[[u objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]]];
                         [allPeople addObject:p];
                     }
                 }
                 
                 // Here we might send all data in the list to a queue somewhere for processing,
                 // either to download the pictures or to do facial recognition.
                 
                 for (FLPerson* p in allPeople)
                 {
                     NSURLRequest* req = [[NSURLRequest alloc] initWithURL:p.pictureUrl];
                     AFImageRequestOperation *afOp = [[AFImageRequestOperation alloc] initWithRequest:req];
                     [afOp setCompletionBlockWithSuccess:
                      ^(AFHTTPRequestOperation *operation, UIImage* responseObject)
                     {
                         [p setImage:responseObject];
                         [fbData addObject:p];
                         NSLog(@"Added image");
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
                     {
                         NSLog(@"Error!");
                     }];
                     
                     [afOp start];
                 }
             }
         }];
        
        [requester start];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification
{
    if (FBSession.activeSession.isOpen)
    {
        [self fetchEventList:AttendingOfAttending withPeople:@"attending"];
        [self fetchEventList:NoReplyOfAttending withPeople:@"noreply"];
    }
    else
    {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}



#pragma mark - IBActions

- (IBAction)takePicturePressed {
    [self startCameraControllerFromViewController:self withDelegate:self sourceType:UIImagePickerControllerSourceTypeCamera andMediaTypes:[NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil]];
}

#pragma mark - Utilities

- (void)customizeInterface {
    
    // Adds a border to the imageView
    [SAViewManipulator addBorderToView:self.currentImagePreviewImageView withWidth:1 color:[UIColor darkTextColor] andRadius:0];
    
    // Sets gradient background for main view
    [SAViewManipulator setGradientBackgroundImageForView:self.currentImagePreviewImageView.superview withTopColor:[UIColor colorWithHexString:@"858585"] andBottomColor:[UIColor colorWithHexString:@"4F4F4F"]];
}

- (void)showNoCameraAlert {
    // Show an alert that tells the user their device is not compatible.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"No Camera"
                          message:@"There is no camera available on this device. Please use a device that includes camera functionality."
                          delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)startCameraControllerFromViewController:(UIViewController *)viewController withDelegate:(id<UINavigationControllerDelegate,  UIImagePickerControllerDelegate>)delegate sourceType:(UIImagePickerControllerSourceType)sourceType andMediaTypes:(NSArray *)mediaTypes {
    // If the current device supports the camera
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        // Allocate and initialize image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set delegate to self
        imagePicker.delegate = delegate;
        
        // Set source type
        imagePicker.sourceType = sourceType;
        
        // Set media types
        imagePicker.mediaTypes = mediaTypes;
        
        // Does not allow editing
        imagePicker.allowsEditing = NO;
        
        // Set a modal transition
        imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        // Use a popover on the iPad
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && sourceType != UIImagePickerControllerSourceTypeCamera) {
            self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            [self.popover presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            [self.navigationItem.leftBarButtonItem setAction:@selector(shouldDismissPopover)];
        }
        
        // We're on the iPhone
        else {
            // Present image picker camera interface
            [viewController presentViewController:imagePicker animated:YES completion:nil];
        }
    } else {
        [self showNoCameraAlert];
    }
}

#pragma mark - Face Detection


- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image
{
    // Getting CGImage from UIImage
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Creating temporal IplImage for drawing
    IplImage *iplimage = cvCreateImage(cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 4);
    
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    // Drawing CGImage to CGContext
    CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    // Creating result IplImage
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplimage, ret, CV_RGBA2BGR);
    cvReleaseImage(&iplimage);
    
    return ret;
}

- (IBAction)faceRecognition:(id)sender {
    // load images
    vector<Mat> images;
    vector<int> labels;
    
    int numberOfSubjects = 4;
    int numberPhotosPerSubject = 3;
    
    for (int i=1; i<=numberOfSubjects; i++) {
        for (int j=1; j<=numberPhotosPerSubject; j++) {
            // create grayscale images
            Mat src = [self CreateIplImageFromUIImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d_%d.jpg", i, j]]];
            Mat dst;
            cv::cvtColor(src, dst, CV_BGR2GRAY);
            
            images.push_back(dst);
            labels.push_back(i);
        }
    }
    
    // get test instances
    Mat testSample = images[images.size() - 1];
    int testLabel = labels[labels.size() - 1];
    
    // ... and delete last element
    images.pop_back();
    labels.pop_back();
    
    // build the Fisherfaces model
    Fisherfaces model(images, labels);
    
    // test model
    int predicted = model.predict(testSample);
    cout << "predicted class = " << predicted << endl;
    cout << "actual class = " << testLabel << endl;
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Dismiss camera interface
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Grab the media type
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // If the media is an image
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        NSLog(@"Picture taken at %@", [NSDate date]);
        
        // The current image is set to be the edited image from the picker
        self.currentImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // The dictionary is kept for safekeeping
        self.currentImageInformation = info;
        
        // And the current image is placed in the imageview.
//        [self updateCurrentImageView];
        self.currentImagePreviewImageView.image = self.currentImage;
        
        // TODO: Cache image
    }
}

// Cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // Dismiss camera interface
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image finishedSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
//        [SVProgressHUD showErrorWithStatus:@"Error saving photo."];
    }
    else  // No errors
    {
        // Show message image successfully saved
//        [SVProgressHUD showSuccessWithStatus:@"Saved to Camera Roll"];
    }
}

- (void)viewDidUnload {
    [self setCurrentImagePreviewImageView:nil];
    [super viewDidUnload];
}
@end
