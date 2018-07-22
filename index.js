var spawner = require('child_process')
var StringDecoder = require('string_decoder').StringDecoder
var events = require('events');
var fs = require('fs');


var omxplayer = require('node-omxplayer')
var mplayer = require('node-omxplayer')

var ttys = {}

var players = {}

//sets up array with player and its values
function setupPlayer(encoderNum){
	var number = encoderNum
	var asset = "./assets/"+number+".mp3"

	var exists = fs.existsSync(asset);
	if ( ! exists ) {
		console.log(asset + " doesn't exist");
	}
	else {
		console.log(asset + " exists")
		var player = {
		"player": omxplayer("./assets/"+number+".mp3"),
		"volume": 0,
		"encoder":new Array(),
		"encoderBig":new Array(),
		"number":number
		}
		player["player"].on("close", function() { console.log(player["number"] + " ended playback")})
		return player
	}
	return false
}


function volumeAdjust(player, value) {
	var player = players[player] || false
	var value = value || false
	if ( ! player["player"]["open"] ) return false
	if ( value == "+" && player["volume"] < 10) {
		player["volume"]++;
		console.log(player["number"]+":volume up:"+player["volume"]);
		player["player"].volUp()
	}
	else if ( value == "-" && player["volume"] > 0) {
		player["volume"]--
		console.log(player["number"]+":volume down:"+player["volume"]);
		player["player"].volDown()
	}

}

// parses by two moves and deals with misreads
function parseEverySecondOne(encoderArray){
	var encoder = encoderArray || false;

	if (encoder.length == 3 ) {
		if(encoder[0] == encoder[2]) {
			encoder.splice(1,1)
		}
		else encoder.shift()
	}
	if (encoder.length == 2) {
		if(encoder[0] == encoder[1]) {
			return encoder[1]
			encoder.shift()
			encoder.shift()
			}
		}
	return false
}

function parseEveryTwenty(encoderArray){
	var encoder = encoderArray || false
	var counter = 0
	if (encoder.length == 10 ) {
		for( var i = 1; i < encoder.length; i++ ) {
			if (encoder[0] == encoder[i]) counter++;
		}
		if ( counter >= 8 ) {
			var value = encoder[0]
			encoder.splice(0, encoder.length)
			return value
		}
	encoder.shift()
	}
	return false
}


function cat(tty) {
	var tty = tty || false
	if ( ! tty ) return false

	tty["catstarted"] = true


	var decoder = new StringDecoder('utf8')
	var string = ""

	var stty = spawner.spawn("bash", new Array("-c", "./ttySetup.sh " + tty["tty"]))
	var cat = spawner.spawn("bash", new Array("-c", "./ttyReader.sh " + tty["tty"]))

	//periodical checking until the device respondes
	function echoReady() {
		var ready = spawner.spawn("bash", new Array("-c", "./ttyReady.sh " + tty["tty"]))
		console.log(tty["tty"] + " was sent 'ready?'")
	}
	echoReady()
	var echo = setInterval(function(){
		echoReady()
	}, 5000)

	cat.stdout.on('data', (data) => {
		string = decoder.write(data)

		string=string.split(/\r?\n/)
		for( var i = 0; i < string.length; i++) {

			if ( string[i].length > 0 && string[i].match(/^system:connected/) && ! tty["comfirmed"]) {
				tty["comfirmed"] = true
				clearInterval(echo)
				console.log(tty["tty"] + " is connected")
			}

			else if ( string[i].length > 0 && string[i].match(/^system:encoders/) && tty["comfirmed"]) {

			 	var encoders = string[i].replace(/^system:encoders:/, "")
				console.log(tty["tty"] + " number of encoders: " + encoders);
				for ( var y = 0; y < encoders; y++ ) {
					var player = setupPlayer(tty["position"] + "" + y)
					if ( player != false ) players[tty["position"] + "" + y] = player
				}
			}

			else if ( string[i].length > 0 && string[i].match(/^encoder/) && tty['comfirmed']) {
				// console.log("real value: " + string[i])
				var split = string[i].split(/:/)

				if ( split.length != 3 || typeof split != "object" ) return false

				var encoderNum = tty["position"] + "" + split[1]-1
				var encoderValue = split[2]

				//pushes the value into the array that holds two or three values
				if ( ! (encoderNum in players) ) {
					// console.log(encoderNum + " player doesn't exist")
					return false
				}
				players[encoderNum]["encoder"].push(encoderValue)

				var value = parseEverySecondOne(players[encoderNum]["encoder"])
				if (value != false) {
					players[encoderNum]["encoderBig"].push(value)
					var bigvalue = parseEveryTwenty(players[encoderNum]["encoderBig"])
					if (bigvalue != false) {
					// console.log("encoder1:" + value)
						volumeAdjust(encoderNum, bigvalue)
					}
				}
			}
		}
		// console.log(output)
	});

	cat.stderr.on('data', (data) => {

	  console.log(`stderr: ${data}`)

	});

	cat.on('close', (code) => {

		console.log(tty["tty"] + " was disconnected. killing all players on this node.")

		for (x in players) {
			if ( x => tty["position"]*10 && x > tty["position"]+1*10 )
				players[x]["player"].quit()
				players[x] = {}
		}

		delete ttys[tty["tty"]]


	});

	return cat;
}


function ls(search) {
	var search=search || false
	var com = spawner.spawn("bash", new Array("-c", "ls " + search))
	var decoder = new StringDecoder('utf-8')

	com.stdout.on('data', (data) => {
	  var string = decoder.write(data)
		string=string.split(/\r?\n/)
		for( var i = 0; i < string.length; i++) {
			if ( string[i].length > 0 && typeof ttys[string[i]] === "undefined") {
				var tty = {
					"tty":string[i],
					"comfirmed":false,
					"position":i+1,
					"catstarted":false
				}
				ttys[string[i]] = tty
			}
		}
	});

	//not final state!
	com.stderr.on('data', (data) => {
	  // console.log(`stderr: ${data}`)
	  var string = `${data}`
		string = string.replace(/(\r?\n)(\r?\n)+/, "\n")
		string = string.replace(/\r?\n$/, "")
		console.log(string+"??")
		return false
	});

	com.on('close', (code) => {
		if (code == 0) {
			for ( i in ttys ) {
				if ( ! ttys[i]["catstarted"] ) {
					console.log(ttys[i])
					cat(ttys[i])
				}
				else "nothing to cat"
			}
		}
		else {
			console.log('no ttys to be found')
		}
	});

	return com;
}

// player1['instance'] = mplayer("vienna_calling_song.mp3")
// player1['instance'].on('close', function() {
// 	console.log("close")
// });

// player2['instance'] = mplayer("Tompa-Ucta.m4a")
// player1.volDown()}, 5000)

ls("/dev/ttyUS*")

setInterval(function(){
	ls("/dev/ttyUS*")
}, 5000)

// ls("input.pipe*")
