/// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
/// !!!!!!!!!!HEY LISTEN!!!!!!!!!!!!!!!!!!!!!!!!
/// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

// If you modify this file you ALSO need to modify code/modules/goonchat/browserAssets/browserOutput.css
// BUT you have to use PX font sizes with are on a x8 scale of these font sizes
// Sample font-size: DM: 8 CSS: 64px


/client/script = {"<style>
body					{font-family: Verdana, sans-serif;}

h1, h2, h3, h4, h5, h6	{color: #0000ff;	font-family: Georgia, Verdana, sans-serif;}

em						{font-style: normal;	font-weight: bold;}

.motd					{color: #638500;	font-family: Verdana, sans-serif;}
.motd h1, .motd h2, .motd h3, .motd h4, .motd h5, .motd h6
	{color: #638500;	text-decoration: underline;}
.motd a, .motd a:link, .motd a:visited, .motd a:active, .motd a:hover
	{color: #638500;}

/* log_message compatability. */
.log_message			{color: #386AFF;	font-weight: bold;}

.italics				{					font-style: italic;}

.bold					{					font-weight: bold;}

.prefix					{					font-weight: bold;}

.ooc					{color: #002eb8;	font-weight: bold;}

/* general ooc compatability. Removed elevated ooc's. Go set your custom color */
.ooc img.text_tag		{width: 32px; 		height: 10px;}

.looc					{color: #6699CC;	font-weight: bold;}
.ooc .aooc				{color: #b8002e;	font-weight: bold;}

.adminobserverooc		{color: #0099cc;	font-weight: bold;}
.adminooc				{color: #700038;	font-weight: bold;}

/* asay compatability, assuming this is that one above */
.adminsay				{color:	#FF4500;	font-weight: bold;}

.adminobserver			{color: #996600;	font-weight: bold;}
.admin					{color: #386aff;	font-weight: bold;}

/* BWOINK compatability */
.pm  .howto				{color: #ff0000;	font-weight: bold;		font-size: 200%;}
.pm  .in				{color: #ff0000;}
.pm  .out				{color: #ff0000;}
.pm  .other				{color: #0000ff;}

/* Admin: Channels */
.mod_channel			{color: #735638;	font-weight: bold;}
.mod_channel .admin		{color: #b82e00;	font-weight: bold;}
.admin_channel			{color: #700038;	font-weight: bold;} //9611D4
.event_channel			{color: #cc3399;	font-weight: bold;}

.name					{					font-weight: bold;}

/* Radio compatability */
.expradio				{color: #555555;}

.say					{}
.deadsay				{color: #5c00e6;}
.binarysay    			{color: #20c20e; background-color: #000000; display: block;}
.binarysay a  			{color: #00ff00;}
.binarysay a:active, .binarysay a:visited {color: #88ff88;}
.radio					{color: #008000;}
.sciradio				{color: #993399;}
.comradio				{color: #948f02;}
.secradio				{color: #a30000;}
.medradio				{color: #337296;}
.engradio				{color: #fb5613;}
.suppradio				{color: #a8732b;}
.servradio				{color: #6eaa2c;}
.syndradio				{color: #6d3f40;}
.centcomradio			{color: #686868;}
.aiprivradio			{color: #ff00ff;}
.redteamradio           {color: #ff0000;}
.blueteamradio          {color: #0000ff;}

.yell					{					font-weight: bold;}

.alert					{color: #ff0000;}
h1.alert, h2.alert		{color: #000000;}

.emote					{					font-style: italic;}
.selecteddna			{color: #ffffff; 	background-color: #001B1B}

.attack					{color: #ff0000;}
.moderate				{color: #CC0000;} /* moderate compatability */
.disarm					{color: #990000;}
.passive				{color: #660000;}

.critical				{color: #ff0000; font-weight: bold; font-size: 150%;} /* critical comatability */

.userdanger				{color: #ff0000;	font-weight: bold; font-size: 3;}
.danger					{color: #ff0000;}
.warning				{color: #ff0000;	font-style: italic;}
.alertwarning			{color: #FF0000;    font-weight: bold}
.boldwarning			{color: #ff0000;	font-style: italic;	font-weight: bold}
.announce 				{color: #228b22;	font-weight: bold;}
.boldannounce			{color: #ff0000;	font-weight: bold;}
.greenannounce			{color: #00ff00;	font-weight: bold;}
.rose					{color: #ff5050;}
.info					{color: #0000CC;}
.notice					{color: #000099;}
.boldnotice				{color: #000099;	font-weight: bold;}
.adminnotice			{color: #0000ff;}
.adminhelp              {color: #ff0000;    font-weight: bold;}
.unconscious			{color: #0000ff;	font-weight: bold;}
.suicide				{color: #ff5050;	font-style: italic;}
.green					{color: #03ff39;}
.red					{color: #FF0000;}
.pink					{color: #FF69Bf;}
.blue					{color: #0000FF;}
.nicegreen				{color: #14a833;}
.userlove				{color: #FF1493;	font-style: italic; font-weight: bold;	text-shadow: 0 0 6px #ff6dbc;}
.love					{color: #ff006a;	font-style: italic;	text-shadow: 0 0 6px #ff6d6d;}
.shadowling				{color: #3b2769;}
.cult					{color: #960000;}

.cultitalic				{color: #960000;	font-style: italic;}
.cultbold				{color: #960000; font-style: italic; font-weight: bold;}
.cultboldtalic			{color: #960000; font-weight: bold; font-size: 185%;}

.cultlarge				{color: #960000; font-weight: bold; font-size: 185%;}
.narsie					{color: #960000; font-weight: bold; font-size: 925%;}
.narsiesmall			{color: #960000; font-weight: bold; font-size: 370%;}
.colossus				{color: #7F282A; font-size: 310%;}
.hierophant				{color: #660099; font-weight: bold; font-style: italic;}
.hierophant_warning		{color: #660099; font-style: italic;}
.purple					{color: #5e2d79;}
.holoparasite			{color: #35333a;}

.revennotice			{color: #1d2953;}
.revenboldnotice		{color: #1d2953;	font-weight: bold;}
.revenbignotice			{color: #1d2953;	font-weight: bold; font-size: 185%;}
.revenminor				{color: #823abb}
.revenwarning			{color: #760fbb;	font-style: italic;}
.revendanger			{color: #760fbb;	font-weight: bold; font-size: 185%;}
.umbra					{color: #5000A0;}
.umbra_emphasis			{color: #5000A0;	font-weight: bold;	font-style: italic;}
.umbra_large			{color: #5000A0; font-size: 185%; font-weight: bold; font-style: italic;}

.deconversion_message	{color: #5000A0; font-size: 185%; font-style: italic;}

.alium					{color: #00ff00;}						/* alium compatability */
.reflex_shoot			{color: #000099; font-style: italic;} 	/* reflex_shoot compatability */

.brass					{color: #BE8700;}
.heavy_brass			{color: #BE8700; font-weight: bold; font-style: italic;}
.large_brass			{color: #BE8700; font-size: 185%;}
.big_brass				{color: #BE8700; font-size: 185%; font-weight: bold; font-style: italic;}
.ratvar					{color: #BE8700; font-size: 370%; font-weight: bold; font-style: italic;}
.alloy					{color: #42474D;}
.heavy_alloy			{color: #42474D; font-weight: bold; font-style: italic;}
.nezbere_large			{color: #42474D; font-size: 185%; font-weight: bold; font-style: italic;}
.nezbere				{color: #42474D; font-weight: bold; font-style: italic;}
.nezbere_small			{color: #42474D;}
.sevtug_large			{color: #AF0AAF; font-size: 185%; font-weight: bold; font-style: italic;}
.sevtug					{color: #AF0AAF; font-weight: bold; font-style: italic;}
.sevtug_small			{color: #AF0AAF;}
.inathneq_large			{color: #1E8CE1; font-size: 185%; font-weight: bold; font-style: italic;}
.inathneq				{color: #1E8CE1; font-weight: bold; font-style: italic;}
.inathneq_small			{color: #1E8CE1;}
.nzcrentr_large			{color: #DAAA18; font-size: 185%; font-weight: bold; font-style: italic;}
.nzcrentr				{color: #DAAA18; font-weight: bold; font-style: italic;}
.nzcrentr_small			{color: #DAAA18;}
.neovgre_large			{color: #6E001A; font-size: 185%; font-weight: bold; font-style: italic;}
.neovgre				{color: #6E001A; font-weight: bold; font-style: italic;}
.neovgre_small			{color: #6E001A;}

.newscaster				{color: #800000;}
.ghostalert				{color: #5c00e6;	font-style: italic; font-weight: bold;}

.alien					{color: #543354;}
.noticealien			{color: #00c000;}
.alertalien				{color: #00c000;	font-weight: bold;}
.changeling				{color: #800080;	font-style: italic;}

.spider					{color: #4d004d; font-weight: bold; font-size: 185%;}
/* language compatability */
.tajaran				{color: #803B56;}
.tajaran_signlang		{color: #941C1C;}
.akhani					{color: #AC398C;}
.skrell					{color: #00B0B3;}
.skrellfar				{color: #70FCFF;}
.soghun					{color: #228B22;}
.solcom					{color: #22228B;}
.sergal					{color: #0077FF;}
.birdsongc				{color: #CC9900;}
.vulpkanin				{color: #B97A57;}
.enochian				{color: #848A33; letter-spacing:-1pt; word-spacing:4pt; font-family: "Lucida Sans Unicode", "Lucida Grande", sans-serif;}
.daemon					{color: #5E339E; letter-spacing:-1pt; word-spacing:0pt; font-family: "Courier New", Courier, monospace;}
.bug                    {color: #9e9e39;}
.vox					{color: #AA00AA;}
.zaddat					{color: #941C1C;}
.rough					{font-family: "Trebuchet MS", cursive, sans-serif;}
.say_quote				{font-family: Georgia, Verdana, sans-serif;}
.terminus				{font-family: "Times New Roman", Times, serif, sans-serif}

BIG IMG.icon 			{width: 32px; height: 32px;} /* Compatability */
.interface				{color: #330033;}

.sans					{font-family: "Comic Sans MS", cursive, sans-serif;}
.papyrus				{font-family: "Papyrus", cursive, sans-serif;}
.robot					{font-family: "Courier New", cursive, sans-serif;}

.command_headset		{font-weight: bold; font-size: 160%;}
.small					{font-size: 60%;}
.big					{font-size: 185%;}
.reallybig				{font-size: 245%;}
.extremelybig			{font-size: 310%;}
.greentext				{color: #00FF00;	font-size: 185%;}
.redtext				{color: #FF0000;	font-size: 185%;}
.yellowtext				{color: #FFCC00;	font-size: 3;} /* COMPATABILITY SHIT*/
.clown					{color: #FF69Bf;	font-size: 160%; font-family: "Comic Sans MS", cursive, sans-serif; font-weight: bold;}
.his_grace				{color: #15D512;	font-family: "Courier New", cursive, sans-serif; font-style: italic;}
.spooky					{color: #FF6100;}
.velvet					{color: #660015; 	font-weight: bold; animation: velvet 5000ms infinite;}

.lethal					{color: #bf3d3d;	font-weight: bold;}
.stun					{color: #0f81bc;	font-weight: bold;}
.ion					{color: #d084d6;	font-weight: bold;}
.xray					{color: #32c025;	font-weight: bold;}

@keyframes velvet {
	0% { color: #400020; }
	40% { color: #FF0000; }
	50% { color: #FF8888; }
	60% { color: #FF0000; }
	100% { color: #400020; }
}

.hypnophrase			{color: #202020;	font-weight: bold; animation: hypnocolor 1500ms infinite;}
@keyframes hypnocolor {
	0% { color: #202020; }
	25% { color: #4b02ac; }
	50% { color: #9f41f1; }
	75% { color: #541c9c; }
	100% { color: #7adbf3; }
}

.phobia			{color: #dd0000;	font-weight: bold; animation: phobia 750ms infinite;}
@keyframes phobia {
	0% { color: #f75a5a; }
	50% { color: #dd0000; }
	100% { color: #f75a5a; }
}

.icon 					{height: 1em;	width: auto;}

.memo					{color: #638500;	text-align: center;}
.memoedit				{text-align: center;	font-size: 2;}
.abductor				{color: #800080; font-style: italic;}
.mind_control			{color: #A00D6F; font-size: 3; font-weight: bold; font-style: italic;}
.slime					{color: #00CED1;}
.drone					{color: #848482;}
.monkey					{color: #975032;}
.swarmer				{color: #2C75FF;}
.resonate				{color: #298F85;}

.monkeyhive				{color: #774704;}
.monkeylead				{color: #774704;	font-size: 2;}

/* Debug compatability */
.debug_error					{color:#FF0000; font-weight:bold}
.debug_warning					{color:#FF0000;}
.debug_info						{}
.debug_debug					{color:#0000FF;}
.debug_trace					{color:#888888;}
</style>"}
