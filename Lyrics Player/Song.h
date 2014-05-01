//
//  Song.h
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.07..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lyrics.h"

@interface Song : NSObject

@property (strong, nonatomic) NSString *filename;
@property (strong, nonatomic) NSURL *fileURL;

@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *album;
@property (strong, nonatomic) UIImage *cover;
@property (nonatomic) NSInteger duration;
@property (strong, nonatomic) NSString* rawLyrics;
@property (strong, nonatomic) Lyrics* lyrics;

-(id)initWithArtist:(NSString *)artist Title:(NSString *)title Album:(NSString *)album CoverImage:(UIImage *)cover DurationInMilliseconds:(NSInteger)duration;
-(id)initWithFile:(NSString *)file;
-(id)initWithURL:(NSURL*)fileURL;

-(void)fetchLyricsOnSuccess:(void(^)(NSString* lyrics))successHandler OnFailure:(void(^)(NSError* error))failureHandler;

-(int)getStatus;
-(double) getTotalTimeSeconds;
-(double) getElapsedTimeSeconds;
-(double) getRemainingTimeSeconds;
-(unsigned long long) getTotalTimeBytes;
-(unsigned long long) getElapsedTimeBytes;
-(unsigned long long) getRemainingTimeBytes;
-(NSString*) getTotalTimeString;
-(NSString*) getElapsedTimeString;
-(NSString*) getRemainingTimeString;

-(void)stop;
-(void)play;
-(void)pause;
-(void)resume;
-(void)resumeFromSeconds:(double)seconds;
-(void)seekToSeconds:(double)seconds;
-(void)seekToBytes:(unsigned long long)bytes;

@end
