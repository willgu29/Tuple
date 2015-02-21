//
//  SavePhotoToServer.m
//  Tuple
//
//  Created by William Gu on 2/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "PhotoServer.h"
#import <Parse/Parse.h>
#import <AFNetworking/AFNetworking.h>
#import "CreateProfilePicture.h"

@implementation PhotoServer

+(void)fetchImageFromServerForUsername:(NSString *)username
{
    NSString *urlString = [NSString stringWithFormat:@"http://tupleapp.com/getPic/"];
    NSString *encoded = [NSString stringWithUTF8String:[urlString UTF8String]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"username": username};

    [manager GET:encoded parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //good
        NSLog(@"Reponse: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //fail
        NSLog(@"failure: %@" ,error);
    }];
}

+(void)sendImageToServer:(UIImage *)image
{
    UIImage *scaledImage= [CreateProfilePicture scaleImageDownToFourth:image];
    NSLog(@"Image size: %f %f" ,scaledImage.size.height, scaledImage.size.width);
    NSData *imageData = UIImagePNGRepresentation(scaledImage);
    
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


@end
