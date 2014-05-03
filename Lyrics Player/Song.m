//
//  Song.m
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.07..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import "Song.h"
#import "LyricLine.h"
#import "bass.h"
#import <AVFoundation/AVFoundation.h>

static Song* staticSelf = nil;

@interface Song ()

@property HSTREAM stream;
@property int currentLine;

@end

@implementation Song

-(id)initWithFile:(NSString *)filename{
    if(self = [super init]){
        
        _filename = filename;
        self.stream = BASS_StreamCreateFile(false, [filename UTF8String], 0, 0, BASS_STREAM_PRESCAN|BASS_STREAM_AUTOFREE);
        NSLog(@"BASS_StreamCreateFile: %@, %d", filename, BASS_ErrorGetCode());
        
        //extract metadata
        NSURL *url = [NSURL fileURLWithPath:filename];
        AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        NSArray *metadata = [asset commonMetadata];
        for (AVMetadataItem *item in metadata){
            if ([[item commonKey] isEqual:@"title"]) {
                _title = [item stringValue];
            } else if ([[item commonKey] isEqual:@"artist"]){
                _artist = [item stringValue];
            } else if ([[item commonKey] isEqual:@"albumName"]){
                _album = [item stringValue];
            } else if ([[item commonKey]isEqual:@"artwork"]){
                if ([[item value] isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *imageDic = (NSDictionary *)[item value];
                    
                    if ([imageDic objectForKey:@"data"] != nil)
                    {
                        NSData *imageData = [imageDic objectForKey:@"data"];
                        _cover = [UIImage imageWithData:imageData];
                    }
                }
            }
        }
    }
    staticSelf = self;
    return self;
}

-(void)fetchLyricsOnSuccess:(void(^)(NSString* lyrics))successHandler OnFailure:(void(^)(NSError* error))failureHandler{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //prepare URL
    NSString *encodedArtist = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)_artist, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    NSString *encodedTitle = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)_title, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSString *urlString = [NSString stringWithFormat:@"http://mrolcsi.orgfree.com/lrc/get.php?artist=%@&title=%@", encodedArtist, encodedTitle];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //prepare HTTP Request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1000];
    
    __weak Song *this = self;

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               
                               NSInteger statuscode = [((NSHTTPURLResponse*)response) statusCode];
                               
                               if (statuscode == 200) {
                                   NSString *responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   this.lyrics = [[Lyrics alloc] initFromLRC:responseString];
                                   
                                   successHandler(responseString);
                               } else if (statuscode == 404) {
                                   failureHandler(nil);
                               }

                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               
                           }];
}

void CALLBACK lyricReached(HSYNC handle, DWORD channel, DWORD data, void *user){
    NSArray *lines = (__bridge_transfer NSArray*)user;
    
    NSLog(@"Line %d reached.", staticSelf.currentLine);
    
//    __block NSString *previousLine = [lines objectAtIndex:0];
//    __block NSString *currentLine = [lines objectAtIndex:1];
//    __block NSString *nextLine =  [lines objectAtIndex:2];
    
    //EXC_BAD_ACCESS...
    //staticSelf.onLyricReached(lines);
    
    staticSelf.currentLine++;
}

-(void)buildCallbacks{
    //this is where the magic happens
    if (_lyrics) {
        for (int i = 0; i<[_lyrics.lyricLines count]; i++) {
            NSString *previousLine = (i>0) ? ((LyricLine*)[_lyrics.lyricLines objectAtIndex:i-1]).lyric : @"";
            NSString *currentLine = ((LyricLine*)[_lyrics.lyricLines objectAtIndex:i]).lyric;
            NSString *nextLine = (i+1<[_lyrics.lyricLines count])?((LyricLine*)[_lyrics.lyricLines objectAtIndex:i+1]).lyric : @"";
            
            NSArray* user = [[NSArray alloc]initWithObjects:previousLine, currentLine, nextLine, nil];
            
            unsigned long long bytes = BASS_ChannelSeconds2Bytes(_stream, ((LyricLine*)[_lyrics.lyricLines objectAtIndex:i]).time);
            BASS_ChannelSetSync(_stream, BASS_SYNC_POS, bytes, _onLyricReached, (__bridge_retained void *)(user));
        }
    }
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
    _stream = BASS_StreamCreateFile(false, [_filename UTF8String], 0, 0, BASS_STREAM_AUTOFREE|BASS_STREAM_PRESCAN);
    BASS_ChannelSetSync(_stream, BASS_SYNC_END, 0, _onSongEnd, NULL);
    [self buildCallbacks];
    
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
