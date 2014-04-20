//
//  Song.m
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.07..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import "Song.h"

@implementation Song

-(id)initWithArtist:(NSString *)artist Title:(NSString *)title Album:(NSString *)album CoverImage:(UIImage *)cover DurationInMilliseconds:(NSInteger)duration{
    
    if (self = [super init]){
        _artist = artist;
        _title = title;
        _album = album;
        _cover = cover;
        _duration = duration;
    }
    return self;
}

-(NSString *)getDurationString{
    long mins = _duration / 60000;
    int seconds = (_duration /10000) % 60;
    
    return [NSString stringWithFormat:@"%ld:%d", mins, seconds];
}

-(void)fetchLyricsOnSuccess:(void(^)(NSString* lyrics))successHandler OnFailure:(void(^)(NSError* error))failureHandler{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //prepare URL
    NSString *urlString = [NSString stringWithFormat:@"http://mrolcsi.orgfree.com/lrc/get.php?artist=%@&title=%@", _artist,_title];
    NSString *escapedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    
    //prepare HTTP Request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1000];
    
    __weak Song *this = self;

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               NSString *responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                               //TODO: parse lyrics n stuff
                               
                               this.lyrics = [[Lyrics alloc] initFromHTML:responseString];
                               
                               if(successHandler)
                               {
                                   successHandler(responseString);
                               }
                               else
                               {
                                   failureHandler(error);
                               }
                               
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               
                           }];
}

@end
