//
//  PlayerViewController.m
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.20..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import "PlayerViewController.h"
#import "Song.h"

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
    
    self.lblTitle.text = _currentSong.title;
    self.lblArtistAlbum.text = [NSString stringWithFormat:@"%@ - %@",_currentSong.artist, _currentSong.album];
    self.imgCover.image = _currentSong.cover;
    self.lblRemainingTime.text = [NSString stringWithFormat:@"-%@",[_currentSong getDurationString]];
    
    __weak PlayerViewController *this = self;
    [self.currentSong fetchLyricsOnSuccess:^(NSString *lyrics) {
        this.lblLyrics.text=lyrics;
    } OnFailure:^(NSError *error) {
        this.lblLyrics.text=@"No lyrics found.";
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
