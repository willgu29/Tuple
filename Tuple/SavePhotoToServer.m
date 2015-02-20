//
//  SavePhotoToServer.m
//  Tuple
//
//  Created by William Gu on 2/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "SavePhotoToServer.h"
#import <Parse/Parse.h>
#import <AFNetworking/AFNetworking.h>
#import "CreateProfilePicture.h"

@implementation SavePhotoToServer

+(void)sendImageToServer:(UIImage *)image
{
    UIImage *scaledImage= [CreateProfilePicture scaleImageDownToHalf:image];
    NSLog(@"Image size: %f %f" ,scaledImage.size.height, scaledImage.size.width);
    NSData *imageData = UIImageJPEGRepresentation(scaledImage, 0.6);
    
    NSString *username = [PFUser currentUser].username;
    NSString *urlString = [NSString stringWithFormat:@"http://tupleapp.com/postPic/username=%@", username];
    NSString *encoded = [NSString stringWithUTF8String:[urlString UTF8String]];
    //URL encoding? UTF8??
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *parameters = @{@"username": username};
    [manager POST:encoded parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:imageData name:@"image"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//+(void)sendImageToServer:(UIImage *)image
//{
//    
//    UIImage *yourImage= image;
//    NSData *imageData = UIImagePNGRepresentation(yourImage);
//    NSString *postLength = [NSString stringWithFormat:@"%d", [imageData length]];
//    
//    NSString *username = [PFUser currentUser].username;
//    NSString *urlString = [NSString stringWithFormat:@"http://tupleapp.com/postPic/"];
//    NSString *encoded = [NSString stringWithUTF8String:[urlString UTF8String]];
//    // Init the URLRequest
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setHTTPMethod:@"POST"];
//    [request setURL:[NSURL URLWithString:encoded]];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPBody:imageData];
//    
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (connection) {
//        // response data of the request
//    }
//    
//}

@end
