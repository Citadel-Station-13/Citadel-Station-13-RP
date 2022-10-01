/// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
/// !!!!!!!!!!HEY LISTEN!!!!!!!!!!!!!!!!!!!!!!!!
/// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

// If you modify this file you ALSO need to modify code/modules/goonchat/browserAssets/browserOutput.css and browserOutput_white.css
// BUT you have to use PX font sizes with are on a x8 scale of these font sizes
// Sample font-size: DM: 8 CSS: 64px

/client/script = {"<style>
body					{font-family: Verdana, sans-serif;}

h1, h2, h3, h4, h5, h6	{color: #0000ff;font-family: Georgia, Verdana, sans-serif;}

em						{font-style: normal;font-weight: bold;}

.motd					{color: #638500;font-family: Verdana, sans-serif;}
.motd h1, .motd h2, .motd h3, .motd h4, .motd h5, .motd h6
						{color: #638500;text-decoration: underline;}
.motd a, .motd a:link, .motd a:visited, .motd a:active, .motd a:hover
						{color: #638500;}

.italics				{					font-style: italic;}

.bold					{					font-weight: bold;}

.prefix					{					font-weight: bold;}
.oocplain				{}
.warningplain			{}

//* OOC *//
.ooc					{					font-weight: bold;}

.ooc .everyone			{color: #002eb8;}
.ooc .looc				{color: #3A9696;}
.ooc .elevated			{color: #2e78d9;}
.ooc .moderator			{color: #184880;}
.ooc .developer			{color: #1b521f;}
.ooc .admin				{color: #b82e00;}
.adminobserverooc		{color: #0099cc;	font-weight: bold;}
.adminooc				{color: #700038;	font-weight: bold;}

.adminsay				{color:	#FF4500;	font-weight: bold;}
.admin					{color: #386aff;	font-weight: bold;}
.ooc .event_manager		{color: #660033;}
.ooc .aooc				{color: #960018;}
.ooc img.text_tag		{width: 32px;		height: 10px;}

//* Admin: Private Messages *//
.pm  .howto				{color: #ff0000;	font-weight: bold;		font-size: 200%;}
.pm  .in				{color: #ff0000;}
.pm  .out				{color: #ff0000;}
.pm  .other				{color: #0000ff;}

/* Admin: Channels */
.mod_channel			{color: #735638;	font-weight: bold;}
.mod_channel .admin		{color: #b82e00;	font-weight: bold;}
.admin_channel			{color: #9611D4;	font-weight: bold;}
.event_channel			{color: #cc3399;	font-weight: bold;}

//* Radio: Misc *//
.deadsay				{color: #530FAD;}
.binarysay				{color: #20c20e;	background-color: #000000;	display: block;}
.binarysay a			{color: #00ff00;}
.binarysay a:active, .binarysay a:visited {color: #88ff88;}
.radio					{color: #008000;}
.deptradio				{color: #ff00ff;}	/* when all other department colors fail */
.newscaster				{color: #750000;}

//* Radio Channels *//
.comradio				{color: #193A7A;}
.syndradio				{color: #6D3F40;}
.centradio				{color: #5C5C8A;}
.aiprivradio			{color: #FF00FF;}
.entradio				{color: #339966;}

.secradio				{color: #A30000;}
.engradio				{color: #A66300;}
.medradio				{color: #008160;}
.sciradio				{color: #993399;}
.suppradio				{color: #5F4519;}
.servradio				{color: #6eaa2c;}
.expradio				{color: #555555;}

.redteamradio			{color: #ff0000;}
.blueteamradio			{color: #0000ff;}
.greenteamradio			{color: #00ff00;}
.yellowteamradio		{color: #d1ba22;}
.gangradio				{color: #ac2ea1;}

//* Miscellaneous *//
.name					{font-weight: bold;}
.say					{}
.yell					{					font-weight: bold;}
.alert					{color: #ff0000;}
h1.alert, h2.alert		{color: #000000;}
.ghostalert				{color: #5c00e6;	font-style: italic; font-weight: bold;}

.emote					{}
.infoplain				{}

//* Game Messages *//

.attack					{color: #ff0000;}
.moderate				{color: #CC0000;}
.disarm					{color: #990000;}
.passive				{color: #660000;}

.announce 				{color: #228b22;	font-weight: bold;}
.boldannounce			{color: #ff0000;	font-weight: bold;}
.minorannounce			{					font-weight: bold;  font-size: 3;}
.greenannounce			{color: #00ff00;	font-weight: bold;}

.adminnotice			{color: #0000ff;}
.adminhelp				{color: #ff0000;	font-weight: bold;}

.critical				{color: #ff0000;	font-weight: bold; font-size: 150%;}
.danger					{color: #ff0000;}
.bolddanger				{color: #ff0000;	font-weight: bold;}
.userdanger				{color: #ff0000;	font-weight: bold; font-size: 3;}
.tinydanger				{color: #ff0000;	font-size: 85%;}
.smalldanger			{color: #ff0000;	font-size: 90%;}

.warning				{color: #ff0000;	font-style: italic;}
.boldwarning			{color: #ff0000;	font-style: italic; font-weight: bold;}
.rose					{color: #ff5050;}
.info					{color: #0000CC;}

.notice					{color: #000099;}
.tinynotice				{color: #000099; font-size: 85%;}
.tinynoticeital			{color: #000099; font-style: italic; font-size: 85%;}
.smallnotice			{color: #000099; font-size: 90%;}
.smallnoticeital		{color: #000099; font-style: italic;	font-size: 90%;}
.boldnotice				{color: #000099;	font-weight: bold;}

.green					{color: #03ff39;}
.grey					{color: #838383;}
.nicegreen				{color: #14a833;}
.boldnicegreen			{color: #14a833;	font-weight: bold;}

.cult					{color: #973e3b;}
.cultlarge				{color: #973e3b;	font-weight: bold;	font-size: 3;}
.narsie					{color: #973e3b;	font-weight: bold;	font-size: 15;}
.narsiesmall			{color: #973e3b;	font-weight: bold;	font-size: 6;}
.colossus				{color: #7F282A;	font-size: 5;}
.hierophant				{color: #660099;	font-weight: bold;	font-style: italic;}
.hierophant_warning		{color: #660099;	font-style: italic;}
.purple					{color: #5e2d79;}
.holoparasite			{color: #35333a;}
.bounty					{color: #ab6613;	font-style: italic;}

.unconscious			{color: #0000ff;	font-weight: bold;}
.suicide				{color: #ff5050;	font-style: italic;}
.reflex_shoot			{color: #000099; font-style: italic;}

.revennotice			{color: #1d2953;}
.revenboldnotice		{color: #1d2953;	font-weight: bold;}
.revenbignotice			{color: #1d2953;	font-weight: bold;	font-size: 3;}
.revenminor				{color: #823abb}
.revenwarning			{color: #760fbb;	font-style: italic;}
.revendanger			{color: #760fbb;	font-weight: bold;	font-size: 3;}

.sentientdisease		{color: #446600;}

.deconversion_message	{color: #5000A0;	font-size: 3;	font-style: italic;}

.ghostalert				{color: #5c00e6;	font-style: italic;	font-weight: bold;}

.alien					{color: #543354;}
.noticealien			{color: #00c000;}
.alertalien				{color: #00c000;	font-weight: bold;}
.changeling				{color: #800080;	font-style: italic;}

.spider					{color: #4d004d;}

.interface				{color: #330033;}

.sans					{font-family: "Comic Sans MS", cursive, sans-serif;}
.papyrus				{font-family: "Papyrus", cursive, sans-serif;}
.robot					{font-family: "Courier New", cursive, sans-serif;}

.command_headset		{font-weight: bold;	font-size: 3;}
.small					{font-size: 1;}
.big					{font-size: 3;}
.reallybig				{font-size: 4;}
.extremelybig			{font-size: 5;}
.redtext				{color: #FF0000;	font-size: 3;}
.yellowtext				{color: #FFFF00;	font-size: 3;}
.greentext				{color: #00FF00;	font-size: 3;}
.clown					{color: #FF69Bf;	font-size: 3;	font-family: "Comic Sans MS", cursive, sans-serif;	font-weight: bold;}
.singing				{font-family: "Trebuchet MS", cursive, sans-serif; font-style: italic;}
.his_grace				{color: #15D512;	font-family: "Courier New", cursive, sans-serif;	font-style: italic;}
.hypnophrase			{color: #3bb5d3;	font-weight: bold;	animation: hypnocolor 1500ms infinite; animation-direction: alternate;}
	@keyframes hypnocolor {
		0%		{color: #0d0d0d;}
		25%		{color: #410194;}
		50%		{color: #7f17d8;}
		75%		{color: #410194;}
		100%	{color: #3bb5d3;}
}

.phobia			{color: #dd0000;	font-weight: bold;	animation: phobia 750ms infinite;}
	@keyframes phobia {
		0%		{color: #0d0d0d;}
		50%		{color: #dd0000;}
		100%	{color: #0d0d0d;}
}

.icon					{height: 1em;	width: auto;}
.iconbig				{height: 32px;	width: 32px; }

.memo					{color: #638500;	text-align: center;}
.memoedit				{text-align: center;	font-size: 2;}
.abductor				{color: #800080;	font-style: italic;}
.mind_control			{color: #A00D6F;	font-size: 3;	font-weight: bold;	font-style: italic;}
.slime					{color: #00CED1;}
.drone					{color: #848482;}
.monkey					{color: #975032;}
.swarmer				{color: #2C75FF;}
.resonate				{color: #298F85;}

.monkeyhive				{color: #774704;}
.monkeylead				{color: #774704;	font-size: 2;}

//* Languages *//

.alien					{color: #543354;}
.tajaran				{color: #803B56;}
.tajaran_signlang		{color: #941C1C;}
.akhani					{color: #AC398C;}
.skrell					{color: #00B0B3;}
.skrellfar				{color: #70FCFF;}
.soghun					{color: #228B22;}
.solcom					{color: #22228B;}
.changeling				{color: #800080;}
.sergal					{color: #0077FF;}
.birdsongc				{color: #CC9900;}
.vulpkanin				{color: #B97A57;}
.enochian				{color: #848A33; letter-spacing:-1pt; word-spacing:4pt; font-family: "Lucida Sans Unicode", "Lucida Grande", sans-serif;}
.daemon					{color: #5E339E; letter-spacing:-1pt; word-spacing:0pt; font-family: "Courier New", Courier, monospace;}
.luinimma				{color: #d4bd11; font-family: "Trebuchet MS", cursive, sans-serif;}
.bug					{color: #9e9e39;}
.vox					{color: #AA00AA;}
.zaddat					{color: #941C1C;}
.akula					{color: #FF1919;}
.rough					{font-family: "Trebuchet MS", cursive, sans-serif;}
.say_quote				{font-family: Georgia, Verdana, sans-serif;}
.terminus				{font-family: "Times New Roman", Times, serif, sans-serif}
.interface				{color: #330033;}
.squeakish				{color: #f54298;}

//* Debug Logs *//
.debug_error					{color:#FF0000; font-weight:bold}
.debug_warning					{color:#FF0000;}
.debug_info						{}
.debug_debug					{color:#0000FF;}
.debug_trace					{color:#888888;}
.maptext { font-family: 'Small Fonts'; font-size: 7px; -dm-text-outline: 1px black; color: white; line-height: 1.1; text-align: center; }

</style>"}
