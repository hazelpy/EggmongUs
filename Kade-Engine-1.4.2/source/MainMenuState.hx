package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.4.2" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var bg:FlxSprite;
	var logoBumpin:FlxSprite;
	var logoMenu:FlxSprite;

	var bgBump:FlxTimer;
	var textBump:FlxTimer;
	var turnTimer:FlxTimer;

	var logoTurnBool:Bool = false;
	var logoTurnAngle:Float = 10;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.05));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBGMagenta'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0;
		magenta.setGraphicSize(Std.int(bg.width * 1.05));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		add(magenta);
		// magenta.scrollFactor.set();

		bgBump = new FlxTimer().start(0.5882, function onComplete(timer:FlxTimer) {
			var scaleX = bg.scale.x;
			var scaleY = bg.scale.y;

			bg.scale.set(scaleX * 1.05, scaleY * 1.05);
			bg.updateHitbox();
			bg.screenCenter();
			magenta.screenCenter();

			magenta.scale.set(scaleX * 1.05, scaleY * 1.05);
			magenta.updateHitbox();
			
			FlxTween.tween(bg, {"scale.x": scaleX, "scale.y": scaleY}, 0.2, {
				ease: FlxEase.expoOut
			});

			FlxTween.tween(magenta, {"scale.x": scaleX, "scale.y": scaleY}, 0.2, {
				ease: FlxEase.expoOut
			});
		}, 0);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.setGraphicSize( Std.int(menuItem.height * 2.5) );
			bg.updateHitbox();
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;

			menuItem.x = -FlxG.width;
			menuItem.y = FlxG.height / 16;

			switch(optionShit[i]) {
				default:
					menuItem.y += (FlxG.height / 10) + (((FlxG.height / 9) + menuItem.height / 2) * i);

					FlxTween.tween(menuItem, {x: menuItem.width / 12}, 1, {
						ease: FlxEase.expoOut
					});
			}

			var menuItemBump = new FlxTimer().start(0.5882, function onComplete(timer:FlxTimer) {
				var scaleX = menuItem.scale.x;
				var scaleY = menuItem.scale.y;
	
				menuItem.scale.set(scaleX * 1.2, scaleY * 1.2);
				
				FlxTween.tween(menuItem, {"scale.x": scaleX, "scale.y": scaleY}, 0.2, {
					ease: FlxEase.expoOut
				});
			}, 0);
		} 

		logoBumpin = new FlxSprite((FlxG.width / 2.4), (FlxG.height * -1.4)).loadGraphic(Paths.image('logoText'));
		logoBumpin.antialiasing = true;
		logoBumpin.setGraphicSize(Std.int(logoBumpin.width/2.8));
		logoBumpin.updateHitbox();
		add(logoBumpin);

		FlxTween.tween(logoBumpin, {y: 0}, 2, {
			ease: FlxEase.expoOut
		});

		textBump = new FlxTimer().start(0.5882, function onComplete(timer:FlxTimer) {
			var scaleX = logoBumpin.scale.x;
			var scaleY = logoBumpin.scale.y;

			logoBumpin.scale.set(scaleX * 1.2, scaleY * 1.2);
			logoBumpin.updateHitbox();
			logoBumpin.x = (FlxG.width / 2.4);
			logoBumpin.y = 0;
			
			FlxTween.tween(logoBumpin, {"scale.x": scaleX, "scale.y": scaleY}, 0.2, {
				ease: FlxEase.expoOut
			});
		}, 0);

		logoMenu = new FlxSprite(( (FlxG.width / 2) - 20), FlxG.height);
		logoMenu.loadGraphic(Paths.image('util/menuIcon'));
		logoMenu.setGraphicSize(Std.int(logoBumpin.width / 1.5));
		add(logoMenu);

		FlxTween.tween(logoMenu, {y: (FlxG.height / 3.5) - 75}, 2.25, {
			ease: FlxEase.expoOut
		});

		turnTimer = new FlxTimer().start(1.4705, function onComplete(timer:FlxTimer) {
			var logoTurnDir:Float = 0;

			if(logoTurnBool) {
				logoTurnDir = logoTurnAngle;
			} else logoTurnDir = -logoTurnAngle;

			logoTurnBool = !logoTurnBool;

			FlxTween.cancelTweensOf(logoMenu);
			FlxTween.tween(logoMenu, {angle: logoTurnDir}, 1.5, {
				ease: FlxEase.expoInOut
			});
		}, 0);
		
		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{	
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					FlxG.sound.play(Paths.sound('astley'));
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					bgBump.cancel();
					textBump.cancel();
					magenta.visible = true;

					var scaleX = bg.scale.x * 0.96;
					var scaleY = bg.scale.y * 0.96;

					FlxTween.tween(logoBumpin, {alpha: 0, y: -FlxG.height}, 0.8, {
						ease: FlxEase.sineIn,
						onComplete: function(twn:FlxTween)
						{
							logoBumpin.kill();
						}
					});

					FlxTween.tween(bg, {"scale.x": scaleX, "scale.y": scaleY}, 2, {
						ease: FlxEase.expoOut
					});
		
					FlxTween.tween(magenta, {"scale.x": scaleX, "scale.y": scaleY}, 2, {
						ease: FlxEase.expoOut
					});

					turnTimer.cancel();
					FlxTween.cancelTweensOf(logoMenu);
					FlxTween.tween(logoMenu, {angle: 0}, 0.9, {
						ease: FlxEase.expoInOut
					});
					FlxTween.tween(logoMenu, {alpha: 0}, 2, {
						ease: FlxEase.expoIn,
						onComplete: function(twn:FlxTween) {
							logoMenu.kill();
						}
					});
					FlxTween.tween(logoMenu, {y: FlxG.height}, 1.5, {
						ease: FlxEase.expoIn
					});

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");

									case 'options':
										FlxG.switchState(new OptionsMenu());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.updateHitbox();
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
			}

			spr.updateHitbox();
		});
	}
}
