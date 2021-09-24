package  {
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel; 
	import flash.media.SoundTransform;
	public class GameScreen extends MovieClip {
		
		var myTimer:Timer=new Timer(1000);
		var i:Number = 0;
		var bombTimer:Timer = new Timer(750,250);  //密度
		//var bombCount:Number = 0;
		var coinTimer:Timer =  new Timer(5000);
		var score:Number = 0; 
		var frame:Number = 1;
		var dx:Number=0;
		var dy:Number=0;
		var BGM=new BGM_game();
		var soundChannel:SoundChannel = new SoundChannel();
		var button=new buttonSound();
		public function GameScreen() {
			// constructor code
			soundChannel = BGM.play(0,10);
			lifeMc.gotoAndStop(1);
			//
			scoreTxt.text = String(score);
			
			gameOverMc.visible = false;
			
			pigMc.addEventListener(Event.ENTER_FRAME,updatePigPos);
			myTimer.addEventListener(TimerEvent.TIMER, updateTimer);
			myTimer.start();
			
			coinTimer.addEventListener(TimerEvent.TIMER, coinUpdate);
			coinTimer.start();
			
			bombTimer.addEventListener(TimerEvent.TIMER, BombUpdate);
			bombTimer.start();			
		}
		private function updatePigPos(e:Event){
			
			
			dx=pigMc.x-mouseX;
			dy=pigMc.y-mouseY;
			pigMc.x-=dx;
			pigMc.y-=dy;
			
			if(gameOverMc.visible ==true){
				
				pigMc.removeEventListener(Event.ENTER_FRAME,updatePigPos);
				
				pigMc.visible=false;
			}
		}
		
		private function coinUpdate(e:TimerEvent){
			addCoin()
		}
		private function addCoin(){
			var newCoin:Coin = new Coin();
			addChild(newCoin);
			
			newCoin.x = 60 + Math.random() * 500;
			newCoin.y = 70;//出現高度位置
		
			newCoin.addEventListener(Event.ENTER_FRAME,updateCoinPos);
			newCoin.addEventListener(Event.ENTER_FRAME,blastCoin);
		}
		private function updateCoinPos(e:Event){
			var removeCoin:Coin =Coin(e.target);
			
			
			removeCoin.y += 5;
			if(removeCoin.y >800){  //消失高度位置
				removeCoin.removeEventListener(Event.ENTER_FRAME,updateCoinPos);
				removeCoin.removeEventListener(Event.ENTER_FRAME,blastCoin); 
				removeChild(removeCoin);
			}
			if(gameOverMc.visible ==true){
				
				removeCoin.removeEventListener(Event.ENTER_FRAME,updateCoinPos);
				removeCoin.removeEventListener(Event.ENTER_FRAME,blastCoin); 
				removeChild(removeCoin);
				
			}
		}
		private function blastCoin(e:Event){
			var myCoin:Coin =Coin(e.target);
			var sound= new coinSound();
			if(pigMc.hitTestObject(myCoin)){
				sound.play();
				score += 3;
				scoreTxt.text = String(score);
			
				myCoin.removeEventListener(Event.ENTER_FRAME,updateCoinPos);
				myCoin.removeEventListener(Event.ENTER_FRAME,blastCoin); 
			
				removeChild(myCoin);
			}
			
		}
		private function updateTimer(e:TimerEvent){
			i++;
			
			var totalSeconds:* = i;
			var minutes:* = Math.floor(totalSeconds/60);
			var seconds:* = totalSeconds % 60;
			
			if(String(minutes).length < 2){
				minutes = "0" + minutes;
			}
			
			if(String(seconds).length < 2){
				seconds = "0"+ seconds;
			}
			
			timeTxt.text = minutes + ":" + seconds;
		}
		private function BombUpdate(e:TimerEvent){
			if((i%2)==0){
				addBomb();
			}
		}
		private function addBomb(){
			var myBomb:Bomb = new Bomb();
			addChild(myBomb);
			
			myBomb.gotoAndStop(Math.ceil(Math.random() * myBomb.totalFrames));
			
			myBomb.x = 60 + Math.random() * 500;
			myBomb.y =70;//出現高度位置
		
			myBomb.addEventListener(Event.ENTER_FRAME,updatePos);
			myBomb.addEventListener(Event.ENTER_FRAME,blast);
		}
		private function updatePos(e: Event){
			var newBomb:Bomb = Bomb(e.target);
			newBomb.y += 5;
			
			if(newBomb.y >800){  //消失高度位置
				newBomb.removeEventListener(Event.ENTER_FRAME,updatePos);
				newBomb.removeEventListener(Event.ENTER_FRAME,blast); 
				removeChild(newBomb);
			}
			else if(gameOverMc.visible ==true){
				
				newBomb.removeEventListener(Event.ENTER_FRAME,updatePos);
				newBomb.removeEventListener(Event.ENTER_FRAME,blast); 
				removeChild(newBomb);
			}
		}
		private function blast(e:Event){
			var removebomb:Bomb = Bomb(e.target);
			var trans:SoundTransform = new SoundTransform(0.6, -1); 
			
			var myBlast:Blast = new Blast()
			if(pigMc.hitTestObject(removebomb)){
				if(removebomb.currentFrame == 1){
					
					var bomb=new bombSound();
					var channel:SoundChannel = bomb.play(0, 0.6, trans);
					
					score += -2;
					frame = 1
				
				
				}else if(removebomb.currentFrame == 2){
					var poison=new poisonSound();
					poison.play();
					score += -2;
					frame = 11
				
				}else if(removebomb.currentFrame == 3){
					var monster=new monsterSound();
					var channel2:SoundChannel = monster.play(0, 0.6, trans);
					
					score += -2;
					frame = 21
					
				}
				if(lifeMc.currentFrame < 5){
					lifeMc.nextFrame();
				}
				if(lifeMc.currentFrame == 5){
					
					gameOverMc.visible = true;
					var over=new OverSound();
					over.play();
					soundChannel.stop();
					gameOverMc.scoreTxt.text = String(score);
					gameOverMc.playMc.buttonMode=true; 
					gameOverMc.playMc.addEventListener(MouseEvent.CLICK , playGame);
					myTimer.stop();
					coinTimer.stop();
					bombTimer.stop();
				}
			
				addChild(myBlast)
				myBlast.gotoAndPlay(frame);
			
				myBlast.addEventListener(Event.ENTER_FRAME, updateBlast);
			
				myBlast.x = removebomb.x;
				myBlast.y = removebomb.y;
			
				scoreTxt.text = String(score);
			
			 	removebomb.removeEventListener(Event.ENTER_FRAME,updatePos);
				removebomb.removeEventListener(Event.ENTER_FRAME,blast); 
			
				removeChild(removebomb);
			}
			

		}
		
		private function updateBlast(e:Event){
			var removeBlast:Blast = Blast(e.target)
			
			if(removeBlast.currentFrame == (frame+9)){
				removeBlast.removeEventListener(Event.ENTER_FRAME, updateBlast);
				removeChild(removeBlast);
			}
		}
		private function playGame(e:MouseEvent){
			
			button.play();
			MovieClip(parent).gotoAndPlay(1);
		}
	}
}

