//
//  PlayerViewController.m
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.20..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import "PlayerViewController.h"
#import "Song.h"
#import "bass.h"

static id staticSelf = nil;

@interface PlayerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblLyrics;
@property (weak, nonatomic) IBOutlet UIImageView *imgCover;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblArtistAlbum;
@property (weak, nonatomic) IBOutlet UILabel *lblElapsedTime;
@property (weak, nonatomic) IBOutlet UILabel *lblRemainingTime;
@property (weak, nonatomic) IBOutlet UIButton *btnPrev;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayPause;
@property (weak, nonatomic) IBOutlet UISlider *sldSeekBar;

@property (weak, nonatomic) NSTimer *progressTimer;

@end

@implementation PlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    staticSelf = self;
    
    _lblTitle.text = _currentSong.title;
    _lblArtistAlbum.text = [NSString stringWithFormat:@"%@ - %@",_currentSong.artist, _currentSong.album];
    _imgCover.image = _currentSong.cover;
    _lblRemainingTime.text = [_currentSong getTotalTimeString];
    [_sldSeekBar setMaximumValue:[_currentSong getTotalTimeSeconds]];
    
    __weak PlayerViewController *this = self;
    [_currentSong fetchLyricsOnSuccess:^(NSString *lyrics) {
        this.lblLyrics.text=lyrics;
    } OnFailure:^(NSError *error) {
        this.lblLyrics.text=@"No lyrics found.";
    }];
    
    _currentSong.onSongEnd = onSongEndCallback;
    _currentSong.onLyricReached = ^(NSString* previousLine, NSString* currentLine, NSString* nextLine){
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            this.lblLyrics.text = [NSString stringWithFormat:@"%@\r%@\r%@", previousLine, currentLine,nextLine];
        }];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onProgressUpdate{
    _lblElapsedTime.text = [_currentSong getElapsedTimeString];
    _lblRemainingTime.text = [_currentSong getRemainingTimeString];
    [_sldSeekBar setValue:[_currentSong getElapsedTimeSeconds]];
}

void onSongEndCallback(HSYNC handle, DWORD channel, DWORD data, void *user){
    [staticSelf onSongEndImplementation];
}

-(void)onSongEndImplementation{
    NSLog(@"OnSongEnd");
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        //run on ui thread
        [_progressTimer invalidate];
        
        [_btnPlayPause setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [_sldSeekBar setValue:0];
        _lblElapsedTime.text=@"00:00";
        _lblRemainingTime.text=[_currentSong getTotalTimeString];
    }];
}

#pragma mark - Buttons

- (IBAction)btnPlayPause_Pressed:(id)sender {
    if ([_currentSong getStatus] == BASS_ACTIVE_PLAYING) {
        [_progressTimer invalidate];
        [_currentSong pause];
        
        [_btnPlayPause setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    } else if ([_currentSong getStatus] == BASS_ACTIVE_STOPPED) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onProgressUpdate) userInfo:nil repeats:YES];
        [_currentSong play];
        [_btnPlayPause setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    } else if ([_currentSong getStatus] == BASS_ACTIVE_PAUSED) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onProgressUpdate) userInfo:nil repeats:YES];
        [_currentSong resumeFromSeconds:_sldSeekBar.value];
        [_btnPlayPause setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)sbProgress_Changed:(id)sender {
    if ([_currentSong getStatus] == BASS_ACTIVE_PLAYING) {
        [_currentSong seekToSeconds:_sldSeekBar.value];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
