package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	var deathAnim:FlxSprite;

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (daStage)
		{
			case 'school':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'schoolEvil':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			default:
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		// add(bf);

		deathAnim = new FlxSprite(x, y);
		var tex = Paths.getSparrowAtlas('eggmongus/egg_death','shared');
		deathAnim.frames = tex;
		deathAnim.animation.addByPrefix('firstDeath', "BF dies", 24, false);
		deathAnim.animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
		deathAnim.animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
		deathAnim.animation.play('firstDeath');
		add(deathAnim);

		camFollow = new FlxObject(deathAnim.getGraphicMidpoint().x, deathAnim.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.5, {
			ease: FlxEase.expoInOut
		});

		FlxG.camera.follow(camFollow, LOCKON, 0.01);

		deathAnim.animation.play('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		switch(deathAnim.animation.curAnim.name) {
			case 'firstDeath':
				deathAnim.offset.set(37, 11);
			case 'deathLoop':
				deathAnim.offset.set(37, 5);
			case 'deathConfirm':
				deathAnim.offset.set(37, 69);
		}

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (deathAnim.animation.curAnim.name == 'firstDeath' && deathAnim.animation.curAnim.curFrame == 50)
		{
			FlxTween.tween(FlxG.camera, {zoom: 1}, 0.5, {
				ease: FlxEase.expoInOut
			});
			deathAnim.animation.play('deathLoop');
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			deathAnim.animation.play('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.5, {
				ease: FlxEase.expoInOut
			});
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
