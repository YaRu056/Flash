package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel; 
	public class Intro extends MovieClip{
		
		var BGM=new BGM_head();
		var soundChannel:SoundChannel = new SoundChannel();
		var button=new buttonSound();

		public function Intro() {
			
			soundChannel = BGM.play(0,10);

			// constructor code
			insMc.visible=false;
			MovieClip(stage.getChildAt(0)).stop();
			
						
			playMc.buttonMode=true; 
			helpMc.buttonMode=true; 
			insMc.closeHelpMc.buttonMode=true;
			
			helpMc.addEventListener(MouseEvent.CLICK , showHelp);
			insMc.closeHelpMc.addEventListener(MouseEvent.CLICK , hideHelp);
			playMc.addEventListener(MouseEvent.CLICK , playGame);
		}
		
		
		private function showHelp(e:MouseEvent){
			button.play();
			insMc.visible=true;
		}
		private function hideHelp(e:MouseEvent){
			button.play();
			insMc.visible=false;
		}
		private function playGame(e:MouseEvent){
			button.play();
			soundChannel.stop();
			MovieClip(stage.getChildAt(0)).gotoAndStop('FlyingPigGame');
		}
	}
	
}
