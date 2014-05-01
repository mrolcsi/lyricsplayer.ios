//
//  Song.m
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.07..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import "Song.h"
#import "bass.h"

@interface Song ()

@property HSTREAM stream;

@end

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

-(id)initWithFile:(NSString *)file{
    if(self = [super init]){
        _filename = file;
        self.stream = BASS_StreamCreateFile(false, [file UTF8String], 0, 0, BASS_STREAM_PRESCAN|BASS_STREAM_AUTOFREE);
        NSLog(@"BASS_StreamCreateFile: %@, %d",file,BASS_ErrorGetCode());
    }
    return self;
}

-(id)initWithURL:(NSURL *)fileURL{
    if(self = [super init]){
        _fileURL = fileURL;
        self.stream = BASS_StreamCreateFile(false, [fileURL fileSystemRepresentation], 0, 0, BASS_STREAM_PRESCAN|BASS_STREAM_AUTOFREE);
        NSLog(@"BASS_StreamCreateFile: %@, %d",fileURL,BASS_ErrorGetCode());
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
                               
                               this.lyrics = [[Lyrics alloc] initFromLRC:responseString];
                               
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

#pragma mark - BASS Helper

-(int)getStatus{
    return BASS_ChannelIsActive(_stream);
}

-(double) getTotalTimeSeconds {
    return BASS_ChannelBytes2Seconds(_stream, BASS_ChannelGetLength(_stream, BASS_POS_BYTE));
}

-(double) getElapsedTimeSeconds {
    return BASS_ChannelBytes2Seconds(_stream, BASS_ChannelGetPosition(_stream, BASS_POS_BYTE));
}

-(double) getRemainingTimeSeconds {
    return [self getTotalTimeSeconds] - [self getElapsedTimeSeconds];
}

-(unsigned long long) getTotalTimeBytes {
    return BASS_ChannelGetLength(_stream, BASS_POS_BYTE);
}

-(unsigned long long) getElapsedTimeBytes {
    return BASS_ChannelGetPosition(_stream, BASS_POS_BYTE);
}

-(unsigned long long) getRemainingTimeBytes {
    return [self getTotalTimeBytes] - [self getElapsedTimeBytes];
}

-(NSString*) getTotalTimeString {
    int seconds = (int) [self getTotalTimeSeconds];
    int minutes = seconds / 60;
    seconds = seconds % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
}

-(NSString*) getElapsedTimeString {
    int seconds = (int) [self getElapsedTimeSeconds];
    int minutes = seconds / 60;
    seconds = seconds % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
}

-(NSString*) getRemainingTimeString {
    int seconds = (int) [self getRemainingTimeSeconds];
    int minutes = seconds / 60;
    seconds = seconds % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
}

#pragma mark - Playback Controls

-(void)stop{
    BASS_ChannelStop(self.stream);
    BASS_SampleFree(self.stream);
}

-(void)play{
    [self stop];
    _stream = BASS_StreamCreateFile(false, (__bridge const void *)(_filename), 0, 0, BASS_STREAM_AUTOFREE|BASS_STREAM_PRESCAN);
    //BASS_ChannelSetSync(...onSongEnd...)
    //buildLyricsCallbacks
    
    BASS_ChannelPlay(_stream, true);
}

-(void)pause{
    BASS_ChannelPause(_stream);
}

-(void)resume{
    BASS_ChannelPlay(_stream, false);
}

-(void)resumeFromSeconds:(double)seconds{
    unsigned long long bytes = BASS_ChannelSeconds2Bytes(_stream, seconds);
    BASS_ChannelSetPosition(_stream, bytes, BASS_POS_BYTE);
    BASS_ChannelPlay(_stream, false);
}

-(void)seekToSeconds:(double)seconds{
    unsigned long long bytes = BASS_ChannelSeconds2Bytes(_stream, seconds);
    BASS_ChannelSetPosition(_stream, bytes, BASS_POS_BYTE);
}

-(void)seekToBytes:(unsigned long long)bytes{
    BASS_ChannelSetPosition(_stream, bytes, BASS_POS_BYTE);
}

@end
