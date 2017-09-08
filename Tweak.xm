@interface SBIconListView : UIView
-(CGSize)defaultIconSize;
-(UIInterfaceOrientation)orientation;
@end

@interface SBRootIconListView : SBIconListView
@end

@interface SBDockIconListView : SBRootIconListView
@end

@interface SBWallpaperEffectView : UIView
@end

@interface SBDockView : UIView
@end

%hook SBDockView
-(void)layoutSubviews {
	%orig();

	UIImageView *_backgroundImageView = MSHookIvar<UIImageView *>(self, "_backgroundImageView");
	if (_backgroundImageView != nil) {
		_backgroundImageView.layer.cornerRadius = 10;
		_backgroundImageView.layer.masksToBounds = YES;
		
		CGRect frame = _backgroundImageView.frame;
		frame.origin.x = 10;
		frame.origin.y = 10;
		frame.size.width = self.frame.size.width - 20;
		frame.size.height = self.frame.size.height - 20;
		_backgroundImageView.frame = frame;

		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			_backgroundImageView.contentMode = UIViewContentModeScaleAspectFill; // fix for weird looking dock background in landscape mode
		}
	}

	SBWallpaperEffectView *_backgroundView = MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView");
	if (_backgroundView != nil) {
		_backgroundView.layer.cornerRadius = 10;
		_backgroundView.layer.masksToBounds = YES;

		CGRect frame = _backgroundView.frame;
		frame.origin.x = 10;
		frame.origin.y = 10;
		frame.size.width = self.frame.size.width - 20;
		frame.size.height = self.frame.size.height - 20;
		_backgroundView.frame = frame;
	}
}
%end

%hook SBDockIconListView
+(CGFloat)defaultHeight {
	return %orig() + 10;
}

-(void)layoutSubviews {
	%orig();

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && UIInterfaceOrientationIsLandscape([self orientation])) {
		CGSize iconSize = [self defaultIconSize];
		CGRect frame = self.frame;
		frame.origin.x = (iconSize.height - iconSize.width) / 2;
		self.frame = frame;
	}
}
%end