// Does not work below ie 8. Plus, it only supports mp3(<audio>) mp4(<video>)
var/const/PLAYER_HTML5_HTML={"
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<script>
	window.onerror = function(msg, url, line, col, error){
		return true
	}
	function SetMusic(url, time = 0, volume = 25){
		var player = document.getElementById('player');
		url = url.match(/https?:\\/\\/\\S+/) || ''; //HTTPS only

		var setTime = function () {
			player.removeEventListener("canplay", setTime);  // One time only!
			player.currentTime = time;
		}
		if(url != ""){
			player.addEventListener("canplay", setTime, false);
		}
		player.src = url;
		player.volume = Math.max(0, Math.min(volume, 100));
		player.play();
	}
	</script>
</head>
<body>
	<audio id="player"></audio>
</body>
</html>
"}
