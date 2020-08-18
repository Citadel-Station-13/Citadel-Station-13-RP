/*********************MANUALS (BOOKS)***********************/

/obj/item/book/manual
	icon = 'icons/obj/library.dmi'
	due_date = 0 // Game time in 1/10th seconds
	unique = 1   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified

	var/datum/codex_tree/tree = null
	var/root_type = /datum/lore/codex/category/main_virgo_lore	//Runtimes on codex_tree.dm, line 18 with a null here


/obj/item/book/manual/legal/Initialize()
	tree = new(src, root_type)
	. = ..()

/obj/item/book/manual/legal/attack_self(mob/user)
	if(!tree)
		tree = new(src, root_type)
	icon_state = "[initial(icon_state)]-open"
	tree.display(user)


/obj/item/book/manual/engineering_construction
	name = "Station Repairs and Construction"
	icon_state ="bookEngineering"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Station Repairs and Construction"

/obj/item/book/manual/engineering_construction/New()
	..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[config_legacy.wikiurl]Guide_to_construction&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/engineering_particle_accelerator
	name = "Particle Accelerator User's Guide"
	icon_state ="bookParticleAccelerator"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Particle Accelerator User's Guide"

/obj/item/book/manual/engineering_particle_accelerator/New()
	..()
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Experienced User's Guide</h1>

				<h2>Setting up the accelerator</h2>

				<ol>
					<li><b>Wrench</b> all pieces to the floor</li>
					<li>Add <b>wires</b> to all the pieces</li>
					<li>Close all the panels with your <b>screwdriver</b></li>
				</ol>

				<h2>Using the accelerator</h2>

				<ol>
					<li>Open the control panel</li>
					<li>Set the speed to 2</li>
					<li>Start firing at the singularity generator</li>
					<li><font color='red'><b>When the singularity reaches a large enough size so it starts moving on it's own set the speed down to 0, but don't shut it off</b></font></li>
					<li>Remember to wear a radiation suit when working with this machine... we did tell you that at the start, right?</li>
				</ol>

				</body>
			</html>
			"}


/obj/item/book/manual/supermatter_engine
	name = "Supermatter Engine Operating Manual"
	icon_state = "bookSupermatter"
	author = "Central Engineering Division"
	title = "Supermatter Engine Operating Manual"

/obj/item/book/manual/supermatter_engine/New()
	..()
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>OPERATING MANUAL FOR MK 1 PROTOTYPE THERMOELECTRIC SUPERMATTER ENGINE 'TOMBOLA'</h1>
				<br>
				<h2>OPERATING PRINCIPLES</h2>
				<br>
				<li>The supermatter crystal serves as the fundamental power source of the engine. Upon being charged, it begins to emit large amounts of heat and radiation, as well and oxygen and phoron gas. As oxygen accelerates the reaction and reacts with phoron to start a fire, it must be filtered out. It's recommended to filter out all gases besides nitrogen for standard operation. </li>
				<br>
				<li>Gas in the reactor chamber housing the supermatter is circulated through the reactor loop, which passes through the filters and thermoelectric generators. The thermoelectric generators transfer heat from the reactor loop to the colder radiator loop, thereby generating power. Additional power is generated from internal turbines in the circulators.</li>
				<br>
				<li>Gas in the radiator loop is circulated through the radiator bank, located in space. This rapidly cools the air, preserving the temperature differential needed for power generation.</li>
				<br>
				<li>The MK 1 Prototype Thermoelectric Supermatter Engine is designed to operate at reactor temperatures of 3000K to 4000K and generate up to 1MW of power. Beyond 1MW, the thermoelectric generators will begin to lose power through electrical discharge, reducing efficiency, but additional power generation remains feasible.</li>
				<br>
				<li>The crystal structure of the supermatter will begin to liquefy if its temperature exceeds 5000K. This eventually results in a massive release of light, heat and radiation, disintegration of both the supermatter crystal and most of the surrounding area, and as as-of-yet poorly documented psychological effects on all animals within a 2km radius. Appropriate action should be taken to stabilize or eject the supermatter before such occurs.</li>
				<br>
				<h2>SUPERMATTER HANDLING</h2>
				<li>Do not expose supermatter to oxygen.</li>
				<li>Do not allow supermatter to contact any solid object apart from specially-designed supporting pallet.</li>
				<li>Do not directly view supermatter without meson goggles.</li>
				<li>While handles on pallet allow moving the supermatter via pulling, pushing should not be attempted.</li>
				<li>Note that prosthetics do not protect against radiation or viewing the supermatter.</li>
				<br>
				<h2>STANDARD STARTUP PROCEDURE</h2>
				<ol>
				<li>Fill reactor loop and radiator loop with three (3) standard canisters of nitrogen gas each.</li>
				<li>Fill the waste handling radiator loop with one (1) standard canister of carbon dioxide gas.</li>
				<li>Enable both the high power gas pumps near the thermo-electric generators and maximize the desired output.</li>
				<li>Enable both the omni-filters and ensure they are set to filter nitrogen back into the system.</li>
				<li>Enable the gas pump from the filters to waste handling and maximize the desired output.</li>
				<li>Close the monitoring room blast doors and open the reactor blast doors,</li>
				<li>Fire 8-9 pulses from emitter at supermatter crystal. The expected power output is around a megawatt. NOTE: It will take a few minutes to heat up.</li>
				<li>Close the reactor blast doors and keep the monitoring room blast doors closed to prevent radiation leaking.</li>
				</ol>
				<br>
				<h2>OPERATION AND MAINTENANCE</h2>
				<ol>
				<li>Ensure that radiation protection and meson goggles are worn at all times while working in the engine room.</li>
				<li>Ensure that reactor and radiator loops are undamaged and unobstructed.</li>
				<li>Ensure that, in a standard setup, only nitrogen is being filtered back into the system. Do not allow exhaust pressure to exceed 4500 kPa.</li>
				<li>Ensure that engine room Area Power Controller (APC) and engine Superconducting Magnetic Energy Storage unit (SMES) are properly charged.</li>
				<li>Ensure that reactor temperature does not exceed 5000K. In event of reactor temperature exceeding 5000K, see EMERGENCY COOLING PROCEDURE.</li>
				<li>In event of imminent and/or unavoidable delamination, see EJECTION PROCEDURE.</li>
				</ol>
				<br>
				<h2>EMERGENCY COOLING PROCEDURE</h2>
				<ol>
				<li>Open Emergency Cooling Valve 1 and Emergency Cooling Valve 2.</li>
				<li>When reactor temperature returns to safe operating levels, close Emergency Cooling Valve 1 and Emergency Cooling Valve 2.</li>
				<li>Adding additional gas to the loops can have a positive effect in reducing reactor temperature.</li>
				<li>If reactor temperature does not return to safe operating levels, see EJECTION PROCEDURE.</li>
				</ol>
				<br>
				<h2>EJECTION PROCEDURE</h2>
				<ol>
				<li>Ensure the engine room has power. The blast doors and ejection platform are unresponsive without power.</li>
				<li>Press Engine Ventilatory Control button to open engine core blast door to space.</li>
				<li>Press Emergency Core Eject button to eject supermatter crystal. NOTE: Attempting crystal ejection while engine core vent is closed will result in ejection failure.</li>
				<li>In event of ejection failure, <i>pending</i></li>
				</ol>
				</body>
			</html>"}

// TESLA Engine

/obj/item/book/manual/tesla_engine
	name = "Tesla Operating Manual"
	icon_state ="bookTesla"
	author = "Engineering Encyclopedia"
	title = "Tesla Engine User's Guide"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>OPERATING MANUAL FOR MK 2 PROTOTYPE TESLA ENGINE &apos;EDISON&apos;S BANE&apos;</h1>
				<br>
				<h2>OPERATING PRINCIPLES</h2>
				<p>This big floaty ball of pure electricity can only be contained by the containment field. It periodically will discharge energy in the form of an electric shock which can be harvested for energy.</p>
				<p>When you shoot the energy ball with the Particle Accelerator, it gains energy, and when enough energy is accumulated a mini-energy ball that orbits the big energy ball will be formed. This can happen as many times as you let it, each mini-ball will send off an extra shock when the energy ball pulses. Be warned, the more mini-balls the energy ball has, the more shocks it sends out at once and the further it can travel each move.</p>
				<p>An energy ball will shoot bolts of electricity off at conductors, which it prioritizes in this order:
				<ol>
					<li>Tesla coils</li>
					<li>Grounding rods</li>
					<li>People and animals</li>
					<li>Machines</li>
				</ol>
				</p>
				<p>Tesla Coils will attract the energy ball&apos;s bolts. They will take half the power of the bolt (if they are connected to a wire node), pump it into the powernet it is hooked to, and then will send the other half of the power to the next available conductor, which follows the criteria listed above. Preferably, this will be another coil to harness more of the power and pump it into the grid.</p>
				<p>Grounding Rods are safety precautions to prevent the tesla bolts from hitting machinery or personnel. If the tesla is loose, being near one will usually keep you safe from direct shocks.</p>
				<br>
				<h2>STARTUP PROCEDURE</h2>
				<ol>
				<li>Bolt and weld down the Field Generators, ensuring they form a complete rectangle.</li>
				<li>Bolt and weld down the Emitters, ensuring their fire will strike the corner Field Generators</li>
				<li>Bolt down the Tesla Generator inside the rectangle formed by the Field Generators in a spot where it will be struck by fire from the Particle Accelerator</li>
				<li>Bolt down Telsa Coils and Grounding Rods</li>
				<li>Activate the Emitters</li>
				<li>Activate each of the Field Generators, then wait until the containment field has completely formed.</li>
				<li>Setup the Particle Accelerator (see our best seller <i>&quot;Particle Accelerator User&apos;s Guide&quot;</i>!) and activate it.</li>
				<li>After a short time the Telsa Generator will create an energy ball, being consumed in the process.</li>
				</ol>
				<br>
				<h2>OPERATION AND MAINTENANCE</h2>
				<ol>
				<li>Ensure that electrical protection and meson goggles are worn at all times while working in the engine room.</li>
				<li>Ensure that Telsa Coils and/or Grounding Rods are placed to safely collect or ground any and all shock.</li>
				<li>Ensure that all Emitters remain activated and have unobstructed lines of fire to the Field Generators.</li>
				<li>Do <b>not</b> let the Emitters run out of power.</li>
				</ol>
				<br>
				<h2>SHUTDOWN PROCEDURE</h2>
				<ol>
				<li>De-activate the Particle Accelerator.  The energy ball will begin to shrink and lose mini-balls.</li>
				<li>When the energy ball has completely dissipated, the Emitters can be de-activated.</li>
				</ol>
				<br>
				<h2>ENERGY BALL ESCAPE PROCEDURE</h2>
				<ol>
				<li>Do not let it escape.</li>
				<li>Have someone ready to blame when it does escape.</li>
				<li>Buy our forthcoming manual &quot;<i>Celebrity Grounding Rod Shelters of the Galaxy</i>&quot;</li>
				</ol>
				</body>
			</html>"}

//R-UST port
/obj/item/book/manual/rust_engine
	name = "R-UST Operating Manual"
	icon_state = "bookSupermatter"
	author = "Cindy Crawfish"
	title = "R-UST Operating Manual"

/obj/item/book/manual/rust_engine/New()
	..()
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<br><br>
				<ol>
				<li>Put uranium in the portable generator near the gyrotron and turn it to full. This is to provide initial power to the core.</li>
				<li>Enable and max output on the SMES in the engine room. This is to power the gyrotron.</li>
				<li>Go into the control room, interact with the fusion core control console. Turn the field on and raise size to 501. Any bigger and it will start EMPing the doors. Any smaller and the fuel pellets might miss.</li>
				<li>Interact with the gyrotron control computer, set power as high as the SMES can support, usually around 4, and turn it on. This will start increasing the plasma temperature to the point where reactions can occur.</li>
				<li>Go into the engine room and insert a deuterium fuel assembly and a tritium fuel assembly into two of the fuel injectors. You can make deuterium rods in the fuel compressor if you want to play it safe.</li>
				<li>Go back to the control room and turn the fuel injectors on. This will start firing pellets into the field.</li>
				<li>Wait for reactions to start (plasma temperature will spike and fuel amounts will drop). Turn the gyrotron power down until it's keeping up with field instability. This will prevent cumulative instability from the deuterium-tritium reaction fucking up the field. If you're using straight deuterium instability isn't a problem and you can turn the gyrotron off.</li>
				<li>Configure the SMES, turn the PACMAN off before it explodes.</li>
				</ol>
				<br>
				<b>NOTES FOR NEWBIES</b>
				<br>
				Anything touching the field will mess with its stability and eventually cause it to rupture. Rupturing is bad. Use the gyrotron to keep instability down if you're running the engine on unstable fuel.
				<br><br>
				Likewise, no matter how sad the core seems, don't fucking hug it, you'll blow the field out and set the engine room on fire.
				</body>
			</html>"}

/obj/item/book/manual/engineering_hacking
	name = "Hacking"
	icon_state ="bookHacking"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Hacking"

/obj/item/book/manual/engineering_hacking/New()
	..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[config_legacy.wikiurl]Hacking&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/engineering_singularity_safety
	name = "Singularity Safety in Special Circumstances"
	icon_state ="bookEngineeringSingularitySafety"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Singularity Safety in Special Circumstances"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Singularity Safety in Special Circumstances</h1>

				<h2>Power outage</h2>

				A power problem has made the entire station lose power? Could be station-wide wiring problems or syndicate power sinks. In any case follow these steps:

				<ol>
					<li><b><font color='red'>PANIC!</font></b></li>
					<li>Get your ass over to engineering! <b>QUICKLY!!!</b></li>
					<li>Get to the <b>Area Power Controller</b> which controls the power to the emitters.</li>
					<li>Swipe it with your <b>ID card</b> - if it doesn't unlock, continue with step 15.</li>
					<li>Open the console and disengage the cover lock.</li>
					<li>Pry open the APC with a <b>Crowbar.</b></li>
					<li>Take out the empty <b>power cell.</b></li>
					<li>Put in the new, <b>full power cell</b> - if you don't have one, continue with step 15.</li>
					<li>Quickly put on a <b>Radiation suit.</b></li>
					<li>Check if the <b>singularity field generators</b> withstood the down-time - if they didn't, continue with step 15.</li>
					<li>Since disaster was averted you now have to ensure it doesn't repeat. If it was a powersink which caused it and if the engineering APC is wired to the same powernet, which the powersink is on, you have to remove the piece of wire which links the APC to the powernet. If it wasn't a powersink which caused it, then skip to step 14.</li>
					<li>Grab your crowbar and pry away the tile closest to the APC.</li>
					<li>Use the wirecutters to cut the wire which is connecting the grid to the terminal. </li>
					<li>Go to the bar and tell the guys how you saved them all. Stop reading this guide here.</li>
					<li><b>GET THE FUCK OUT OF THERE!!!</b></li>
				</ol>

				<h2>Shields get damaged</h2>

				<ol>
					<li><b>GET THE FUCK OUT OF THERE!!! FORGET THE WOMEN AND CHILDREN, SAVE YOURSELF!!!</b></li>
				</ol>
				</body>
			</html>
			"}


/obj/item/book/manual/hydroponics_pod_people
	name = "The Diona Harvest - From Seed to Market"
	icon_state ="bookHydroponicsPodPeople"
	author = "Farmer John"
	title = "The Diona Harvest - From Seed to Market"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h3>Growing a Diona</h3>

				Growing a Diona is easy!
				<p>
				<ol>
					<li>Take a syringe of blood from the body you wish to turn into a Diona.</li>
					<li>Inject 5 units of blood into the pack of dionaea-replicant seeds.</li>
					<li>Plant the seeds.</li>
					<li>Tend to the plants water and nutrition levels until it is time to harvest the Diona.</li>
				</ol>
				<p>
				Note that for a successful harvest, the body from which the blood was taken from must be dead BEFORE harvesting the pod, however the pod can be growing while they are still alive. Otherwise, the soul would not be able to migrate to the new Diona body.<br><br>

				It really is that easy! Good luck!

				</body>
				</html>
				"}


/obj/item/book/manual/medical_cloning
	name = "Cloning Techniques of the 26th Century"
	icon_state ="bookCloning"
	author = "Medical Journal, volume 3"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Cloning Techniques of the 26th Century"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				h3 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<H1>How to Clone People</H1>
				So there are 50 dead people lying on the floor, chairs are spinning like no tomorrow and you haven't the foggiest idea of what to do? Not to worry!
				This guide is intended to teach you how to clone people and how to do it right, in a simple, step-by-step process! If at any point of the guide you have a mental meltdown,
				genetics probably isn't for you and you should get a job-change as soon as possible before you're sued for malpractice.

				<ol>
					<li><a href='#1'>Acquire body</a></li>
					<li><a href='#2'>Strip body</a></li>
					<li><a href='#3'>Put body in cloning machine</a></li>
					<li><a href='#4'>Scan body</a></li>
					<li><a href='#5'>Clone body</a></li>
					<li><a href='#6'>Get clean Structural Enzymes for the body</a></li>
					<li><a href='#7'>Put body in morgue</a></li>
					<li><a href='#8'>Await cloned body</a></li>
					<li><a href='#9'>Cryo and use the clean SE injector</a></li>
					<li><a href='#10'>Give person clothes back</a></li>
					<li><a href='#11'>Send person on their way</a></li>
				</ol>

				<a name='1'><H3>Step 1: Acquire body</H3>
				This is pretty much vital for the process because without a body, you cannot clone it. Usually, bodies will be brought to you, so you do not need to worry so much about this step. If you already have a body, great! Move on to the next step.

				<a name='2'><H3>Step 2: Strip body</H3>
				The cloning machine does not like abiotic items. What this means is you can't clone anyone if they're wearing clothes or holding things, so take all of it off. If it's just one person, it's courteous to put their possessions in the closet.
				If you have about seven people awaiting cloning, just leave the piles where they are, but don't mix them around and for God's sake don't let people in to steal them.

				<a name='3'><h3>Step 3: Put body in cloning machine</h3>
				Grab the body and then put it inside the DNA modifier. If you cannot do this, then you messed up at Step 2. Go back and check you took EVERYTHING off - a commonly missed item is their headset.

				<a name='4'><h3>Step 4: Scan body</h3>
				Go onto the computer and scan the body by pressing 'Scan - &lt;Subject Name Here&gt;.' If you're successful, they will be added to the records (note that this can be done at any time, even with living people,
				so that they can be cloned without a body in the event that they are lying dead on port solars and didn't turn on their suit sensors)!
				If not, and it says "Error: Mental interface failure.", then they have left their bodily confines and are one with the spirits. If this happens, just shout at them to get back in their body,
				click 'Refresh' and try scanning them again. If there's no success, threaten them with gibbing.
				Still no success? Skip over to Step 7 and don't continue after it, as you have an unresponsive body and it cannot be cloned.
				If you got "Error: Unable to locate valid genetic data.", you are trying to clone a monkey - start over.

				<a name='5'><h3>Step 5: Clone body</h3>
				Now that the body has a record, click 'View Records,' click the subject's name, and then click 'Clone' to start the cloning process. Congratulations! You're halfway there.
				Remember not to 'Eject' the cloning pod as this will kill the developing clone and you'll have to start the process again.

				<a name='6'><h3>Step 6: Get clean SEs for body</h3>
				Cloning is a finicky and unreliable process. Whilst it will most certainly bring someone back from the dead, they can have any number of nasty disabilities given to them during the cloning process!
				For this reason, you need to prepare a clean, defect-free Structural Enzyme (SE) injection for when they're done. If you're a competent Geneticist, you will already have one ready on your working computer.
				If, for any reason, you do not, then eject the body from the DNA modifier (NOT THE CLONING POD) and take it next door to the Genetics research room. Put the body in one of those DNA modifiers and then go onto the console.
				Go into View/Edit/Transfer Buffer, find an open slot and click "SE" to save it. Then click 'Injector' to get the SEs in syringe form. Put this in your pocket or something for when the body is done.

				<a name='7'><h3>Step 7: Put body in morgue</h3>
				Now that the cloning process has been initiated and you have some clean Structural Enzymes, you no longer need the body! Drag it to the morgue and tell the Chef over the radio that they have some fresh meat waiting for them in there.
				To put a body in a morgue bed, simply open the tray, grab the body, put it on the open tray, then close the tray again. Use one of the nearby pens to label the bed "CHEF MEAT" in order to avoid confusion.

				<a name='8'><h3>Step 8: Await cloned body</h3>
				Now go back to the lab and wait for your patient to be cloned. It won't be long now, I promise.

				<a name='9'><h3>Step 9: Cryo and clean SE injector on person</h3>
				Has your body been cloned yet? Great! As soon as the guy pops out, grab them and stick them in cryo. Clonexadone and Cryoxadone help rebuild their genetic material. Then grab your clean SE injector and jab it in them. Once you've injected them,
				they now have clean Structural Enzymes and their defects, if any, will disappear in a short while.

				<a name='10'><h3>Step 10: Give person clothes back</h3>
				Obviously the person will be naked after they have been cloned. Provided you weren't an irresponsible little shit, you should have protected their possessions from thieves and should be able to give them back to the patient.
				No matter how cruel you are, it's simply against protocol to force your patients to walk outside naked.

				<a name='11'><h3>Step 11: Send person on their way</h3>
				Give the patient one last check-over - make sure they don't still have any defects and that they have all their possessions. Ask them how they died, if they know, so that you can report any foul play over the radio.
				Once you're done, your patient is ready to go back to work! Chances are they do not have Medbay access, so you should let them out of Genetics and the Medbay main entrance.

				<p>If you've gotten this far, congratulations! You have mastered the art of cloning. Now, the real problem is how to resurrect yourself after that traitor had his way with you for cloning his target.

				</body>
				</html>
				"}


/obj/item/book/manual/ripley_build_and_repair
	name = "APLU \"Ripley\" Construction and Operation Manual"
	icon_state ="book"
	author = "Randall Varn, Einstein Engines Senior Mechanic"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "APLU \"Ripley\" Construction and Operation Manual"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ul.a {list-style-type: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<center>
				<br>
				<span style='font-size: 12px;'><b>Weyland-Yutani - Building Better Worlds</b></span>
				<h1>Autonomous Power Loader Unit \"Ripley\"</h1>
				</center>
				<h2>Specifications:</h2>
				<ul class="a">
				<li><b>Class:</b> Autonomous Power Loader</li>
				<li><b>Scope:</b> Logistics and Construction</li>
				<li><b>Weight:</b> 820kg (without operator and with empty cargo compartment)</li>
				<li><b>Height:</b> 2.5m</li>
				<li><b>Width:</b> 1.8m</li>
				<li><b>Top speed:</b> 5km/hour</li>
				<li><b>Operation in vacuum/hostile environment: Possible</b>
				<li><b>Airtank volume:</b> 500 liters</li>
				<li><b>Devices:</b>
					<ul class="a">
					<li>Hydraulic clamp</li>
					<li>High-speed drill</li>
					</ul>
				</li>
				<li><b>Propulsion device:</b> Powercell-powered electro-hydraulic system</li>
				<li><b>Powercell capacity:</b> Varies</li>
				</ul>

				<h2>Construction:</h2>
				<ol>
					<li>Connect all exosuit parts to the chassis frame.</li>
					<li>Connect all hydraulic fittings and tighten them up with a wrench.</li>
					<li>Adjust the servohydraulics with a screwdriver.</li>
					<li>Wire the chassis (Cable is not included).</li>
					<li>Use the wirecutters to remove the excess cable if needed.</li>
					<li>Install the central control module (Not included. Use supplied datadisk to create one).</li>
					<li>Secure the mainboard with a screwdriver.</li>
					<li>Install the peripherals control module (Not included. Use supplied datadisk to create one).</li>
					<li>Secure the peripherals control module with a screwdriver.</li>
					<li>Install the internal armor plating (Not included due to corporate regulations. Can be made using 5 metal sheets).</li>
					<li>Secure the internal armor plating with a wrench.</li>
					<li>Weld the internal armor plating to the chassis.</li>
					<li>Install the external reinforced armor plating (Not included due to corporate regulations. Can be made using 5 reinforced metal sheets).</li>
					<li>Secure the external reinforced armor plating with a wrench.</li>
					<li>Weld the external reinforced armor plating to the chassis.</li>
				</ol>

				<h2>Additional Information:</h2>
				<ul>
					<li>The firefighting variation is made in a similar fashion.</li>
					<li>A firesuit must be connected to the firefighter chassis for heat shielding.</li>
					<li>Internal armor is plasteel for additional strength.</li>
					<li>External armor must be installed in 2 parts, totalling 10 sheets.</li>
					<li>Completed mech is more resilient against fire, and is a bit more durable overall.</li>
					<li>The Company is determined to ensure the safety of its <s>investments</s> employees.</li>
				</ul>
				</body>
			</html>
			"}


/obj/item/book/manual/research_and_development
	name = "Research and Development 101"
	icon_state = "rdbook"
	author = "Dr. L. Ight"
	title = "Research and Development 101"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				h3 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Science For Dummies</h1>
				So you want to further SCIENCE? Good man/woman/thing! However, SCIENCE is a complicated process even though it's quite easy. For the most part, it's a three step process:
				<ol>
					<li><b>Deconstruct</b> items in the Destructive Analyzer to advance technology or improve the design.</li>
					<li><b>Build</b> unlocked designs in the Protolathe and Circuit Imprinter.</li>
					<li><b>Repeat</b>!</li>
				</ol>

				Those are the basic steps to furthering science. What do you do science with, however? Well, you have four major tools: R&D Console, the Destructive Analyzer, the Protolathe, and the Circuit Imprinter.

				<h2>The R&D Console</h2>
				The R&D console is the cornerstone of any research lab. It is the central system from which the Destructive Analyzer, Protolathe, and Circuit Imprinter (your R&D systems) are controlled. More on those systems in their own sections.
				On its own, the R&D console acts as a database for all your technological gains and new devices you discover. So long as the R&D console remains intact, you'll retain all that SCIENCE you've discovered. Protect it though,
				because if it gets damaged, you'll lose your data!
				In addition to this important purpose, the R&D console has a disk menu that lets you transfer data from the database onto disk or from the disk into the database.
				It also has a settings menu that lets you re-sync with nearby R&D devices (if they've become disconnected), lock the console from the unworthy,
				upload the data to all other R&D consoles in the network (all R&D consoles are networked by default), connect/disconnect from the network, and purge all data from the database.<br><br>

				<b>NOTE:</b> The technology list screen, circuit imprinter, and protolathe menus are accessible by non-scientists. This is intended to allow 'public' systems for the plebians to utilize some new devices.

				<h2>Destructive Analyzer</h2>
				This is the source of all technology. Whenever you put a handheld object in it, it analyzes it and determines what sort of technological advancements you can discover from it. If the technology of the object is equal or higher then your current knowledge,
				you can destroy the object to further those sciences.
				Some devices (notably, some devices made from the protolathe and circuit imprinter) aren't 100% reliable when you first discover them. If these devices break down, you can put them into the Destructive Analyzer and improve their reliability rather than further science.
				If their reliability is high enough, it'll also advance their related technologies.

				<h2>Circuit Imprinter</h2>
				This machine, along with the Protolathe, is used to actually produce new devices. The Circuit Imprinter takes glass and various chemicals (depends on the design) to produce new circuit boards to build new machines or computers. It can even be used to print AI modules.

				<h2>Protolathe</h2>
				This machine is an advanced form of the Autolathe that produce non-circuit designs. Unlike the Autolathe, it can use processed metal, glass, solid phoron, silver, gold, and diamonds along with a variety of chemicals to produce devices.
				The downside is that, again, not all devices you make are 100% reliable when you first discover them.

				<h2>Reliability and You</h2>
				As it has been stated, many devices, when they're first discovered, do not have a 100% reliability. Instead,
				the reliability of the device is dependent upon a base reliability value, whatever improvements to the design you've discovered through the Destructive Analyzer,
				and any advancements you've made with the device's source technologies. To be able to improve the reliability of a device, you have to use the device until it breaks beyond repair. Once that happens, you can analyze it in a Destructive Analyzer.
				Once the device reaches a certain minimum reliability, you'll gain technological advancements from it.

				<h2>Building a Better Machine</h2>
				Many machines produced from circuit boards inserted into a machine frames require a variety of parts to construct. These are parts like capacitors, batteries, matter bins, and so forth. As your knowledge of science improves, more advanced versions are unlocked.
				If you use these parts when constructing something, its attributes may be improved.
				For example, if you use an advanced matter bin when constructing an autolathe (rather than a regular one), it'll hold more materials. Experiment around with stock parts of various qualities to see how they affect the end results! Be warned, however:
				Tier 3 and higher stock parts don't have 100% reliability and their low reliability may affect the reliability of the end machine.
				</body>
			</html>
			"}


/obj/item/book/manual/robotics_cyborgs
	name = "Cyborgs for Dummies"
	icon_state = "borgbook"
	author = "XISC"
	title = "Cyborgs for Dummies"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Cyborgs for Dummies</h1>

				<h2>Chapters</h2>

				<ol>
					<li><a href="#Equipment">Cyborg Related Equipment</a></li>
					<li><a href="#Modules">Cyborg Modules</a></li>
					<li><a href="#Construction">Cyborg Construction</a></li>
					<li><a href="#Maintenance">Cyborg Maintenance</a></li>
					<li><a href="#Repairs">Cyborg Repairs</a></li>
					<li><a href="#Emergency">In Case of Emergency</a></li>
				</ol>


				<h2><a name="Equipment">Cyborg Related Equipment</h2>

				<h3>Exosuit Fabricator</h3>
				The Exosuit Fabricator is the most important piece of equipment related to cyborgs. It allows the construction of the core cyborg parts. Without these machines, cyborgs cannot be built. It seems that they may also benefit from advanced research techniques.

				<h3>Cyborg Recharging Station</h3>
				This useful piece of equipment will suck power out of the power systems to charge a cyborg's power cell back up to full charge.

				<h3>Robotics Control Console</h3>
				This useful piece of equipment can be used to immobilize or destroy a cyborg. A word of warning: Cyborgs are expensive pieces of equipment, do not destroy them without good reason, or the Company may see to it that it never happens again.


				<h2><a name="Modules">Cyborg Modules</h2>
				When a cyborg is created it picks out of an array of modules to designate its purpose. There are 6 different cyborg modules.

				<h3>Standard Cyborg</h3>
				The standard cyborg module is a multi-purpose cyborg. It is equipped with various modules, allowing it to do basic tasks.<br>A Standard Cyborg comes with:
				<ul>
				  <li>Crowbar</li>
				  <li>Stun Baton</li>
				  <li>Health Analyzer</li>
				  <li>Fire Extinguisher</li>
				</ul>

				<h3>Engineering Cyborg</h3>
				The Engineering cyborg module comes equipped with various engineering-related tools to help with engineering-related tasks.<br>An Engineering Cyborg comes with:
				<ul>
				  <li>A basic set of engineering tools</li>
				  <li>Metal Synthesizer</li>
				  <li>Reinforced Glass Synthesizer</li>
				  <li>An RCD</li>
				  <li>Wire Synthesizer</li>
				  <li>Fire Extinguisher</li>
				  <li>Built-in Optical Meson Scanners</li>
				</ul>

				<h3>Mining Cyborg</h3>
				The Mining Cyborg module comes equipped with the latest in mining equipment. They are efficient at mining due to no need for oxygen, but their power cells limit their time in the mines.<br>A Mining Cyborg comes with:
				<ul>
				  <li>Jackhammer</li>
				  <li>Shovel</li>
				  <li>Mining Satchel</li>
				  <li>Built-in Optical Meson Scanners</li>
				</ul>

				<h3>Security Cyborg</h3>
				The Security Cyborg module is equipped with effective security measures used to apprehend and arrest criminals without harming them a bit.<br>A Security Cyborg comes with:
				<ul>
				  <li>Stun Baton</li>
				  <li>Handcuffs</li>
				  <li>Taser</li>
				</ul>

				<h3>Janitor Cyborg</h3>
				The Janitor Cyborg module is equipped with various cleaning-facilitating devices.<br>A Janitor Cyborg comes with:
				<ul>
				  <li>Mop</li>
				  <li>Hand Bucket</li>
				  <li>Cleaning Spray Synthesizer and Spray Nozzle</li>
				</ul>

				<h3>Service Cyborg</h3>
				The service cyborg module comes ready to serve your human needs. It includes various entertainment and refreshment devices. Occasionally some service cyborgs may have been referred to as "Bros."<br>A Service Cyborg comes with:
				<ul>
				  <li>Shaker</li>
				  <li>Industrial Dropper</li>
				  <li>Platter</li>
				  <li>Beer Synthesizer</li>
				  <li>Zippo Lighter</li>
				  <li>Rapid-Service-Fabricator (Produces various entertainment and refreshment objects)</li>
				  <li>Pen</li>
				</ul>

				<h2><a name="Construction">Cyborg Construction</h2>
				Cyborg construction is a rather easy process, requiring a decent amount of metal and a few other supplies.<br>The required materials to make a cyborg are:
				<ul>
				  <li>Metal</li>
				  <li>Two Flashes</li>
				  <li>One Power Cell (Preferably rated to 15000w)</li>
				  <li>Some electrical wires</li>
				  <li>One Human Brain</li>
				  <li>One Man-Machine Interface</li>
				</ul>
				Once you have acquired the materials, you can start on construction of your cyborg.<br>To construct a cyborg, follow the steps below:
				<ol>
				  <li>Start the Exosuit Fabricators constructing all of the cyborg parts</li>
				  <li>While the parts are being constructed, take your human brain, and place it inside the Man-Machine Interface</li>
				  <li>Once you have a Robot Head, place your two flashes inside the eye sockets</li>
				  <li>Once you have your Robot Chest, wire the Robot chest, then insert the power cell</li>
				  <li>Attach all of the Robot parts to the Robot frame</li>
				  <li>Insert the Man-Machine Interface (With the Brain inside) into the Robot Body</li>
				  <li>Congratulations! You have a new cyborg!</li>
				</ol>

				<h2><a name="Maintenance">Cyborg Maintenance</h2>
				Occasionally Cyborgs may require maintenance of a couple types, this could include replacing a power cell with a charged one, or possibly maintaining the cyborg's internal wiring.

				<h3>Replacing a Power Cell</h3>
				Replacing a Power cell is a common type of maintenance for cyborgs. It usually involves replacing the cell with a fully charged one, or upgrading the cell with a larger capacity cell.<br>The steps to replace a cell are as follows:
				<ol>
				  <li>Unlock the Cyborg's Interface by swiping your ID on it</li>
				  <li>Open the Cyborg's outer panel using a crowbar</li>
				  <li>Remove the old power cell</li>
				  <li>Insert the new power cell</li>
				  <li>Close the Cyborg's outer panel using a crowbar</li>
				  <li>Lock the Cyborg's Interface by swiping your ID on it, this will prevent non-qualified personnel from attempting to remove the power cell</li>
				</ol>

				<h3>Exposing the Internal Wiring</h3>
				Exposing the internal wiring of a cyborg is fairly easy to do, and is mainly used for cyborg repairs.<br>You can easily expose the internal wiring by following the steps below:
				<ol>
					<li>Follow Steps 1 - 3 of "Replacing a Cyborg's Power Cell"</li>
					<li>Open the cyborg's internal wiring panel by using a screwdriver to unsecure the panel</li>
				</ol>
				To re-seal the cyborg's internal wiring:
				<ol>
					<li>Use a screwdriver to secure the cyborg's internal panel</li>
					<li>Follow steps 4 - 6 of "Replacing a Cyborg's Power Cell" to close up the cyborg</li>
				</ol>

				<h2><a name="Repairs">Cyborg Repairs</h2>
				Occasionally a Cyborg may become damaged. This could be in the form of impact damage from a heavy or fast-travelling object, or it could be heat damage from high temperatures, or even lasers or Electromagnetic Pulses (EMPs).

				<h3>Dents</h3>
				If a cyborg becomes damaged due to impact from heavy or fast-moving objects, it will become dented. Sure, a dent may not seem like much, but it can compromise the structural integrity of the cyborg, possibly causing a critical failure.
				Dents in a cyborg's frame are rather easy to repair, all you need is to apply a welding tool to the dented area, and the high-tech cyborg frame will repair the dent under the heat of the welder.

				<h3>Excessive Heat Damage</h3>
				If a cyborg becomes damaged due to excessive heat, it is likely that the internal wires will have been damaged. You must replace those wires to ensure that the cyborg remains functioning properly.<br>To replace the internal wiring follow the steps below:
				<ol>
					<li>Unlock the Cyborg's Interface by swiping your ID</li>
					<li>Open the Cyborg's External Panel using a crowbar</li>
					<li>Remove the Cyborg's Power Cell</li>
					<li>Using a screwdriver, expose the internal wiring of the Cyborg</li>
					<li>Replace the damaged wires inside the cyborg</li>
					<li>Secure the internal wiring cover using a screwdriver</li>
					<li>Insert the Cyborg's Power Cell</li>
					<li>Close the Cyborg's External Panel using a crowbar</li>
					<li>Lock the Cyborg's Interface by swiping your ID</li>
				</ol>
				These repair tasks may seem difficult, but are essential to keep your cyborgs running at peak efficiency.

				<h2><a name="Emergency">In Case of Emergency</h2>
				In case of emergency, there are a few steps you can take.

				<h3>"Rogue" Cyborgs</h3>
				If the cyborgs seem to become "rogue", they may have non-standard laws. In this case, use extreme caution.
				To repair the situation, follow these steps:
				<ol>
					<li>Locate the nearest robotics console</li>
					<li>Determine which cyborgs are "Rogue"</li>
					<li>Press the lockdown button to immobilize the cyborg</li>
					<li>Locate the cyborg</li>
					<li>Expose the cyborg's internal wiring</li>
					<li>Check to make sure the LawSync and AI Sync lights are lit</li>
					<li>If they are not lit, pulse the LawSync wire using a multitool to enable the cyborg's LawSync</li>
					<li>Proceed to a cyborg upload console. The Company usually places these in the same location as AI upload consoles.</li>
					<li>Use a "Reset" upload moduleto reset the cyborg's laws</li>
					<li>Proceed to a Robotics Control console</li>
					<li>Remove the lockdown on the cyborg</li>
				</ol>

				<h3>As a last resort</h3>
				If all else fails in a case of cyborg-related emergency, there may be only one option. Using a Robotics Control console, you may have to remotely detonate the cyborg.
				<h3>WARNING:</h3> Do not detonate a borg without an explicit reason for doing so. Cyborgs are expensive pieces of company equipment, and you may be punished for detonating them without reason.

				</body>
			</html>
		"}


/obj/item/book/manual/security_space_law
	name = "Corporate Regulations"
	desc = "A set of corporate guidelines for keeping law and order on privately-owned space stations."
	icon_state = "bookSpaceLaw"
	author = "The Company"
	title = "Corporate Regulations"

/obj/item/book/manual/security_space_law/New()
	..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[config_legacy.wikiurl]Corporate_Regulations&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}



/obj/item/book/manual/medical_diagnostics_manual
	name = "Medical Diagnostics Manual"
	desc = "First, do no harm. A detailed medical practitioner's guide."
	icon_state = "bookMedical"
	author = "Medical Department"
	title = "Medical Diagnostics Manual"

/obj/item/book/manual/medical_diagnostics_manual/New()
	..()
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<br>
				<h1>The Oath</h1>

				<i>The Medical Oath sworn by recognised medical practitioners in the employ of [GLOB.using_map.company_name]</i><br>

				<ol>
					<li>Now, as a new doctor, I solemnly promise that I will, to the best of my ability, serve humanity-caring for the sick, promoting good health, and alleviating pain and suffering.</li>
					<li>I recognise that the practice of medicine is a privilege with which comes considerable responsibility and I will not abuse my position.</li>
					<li>I will practise medicine with integrity, humility, honesty, and compassion-working with my fellow doctors and other colleagues to meet the needs of my patients.</li>
					<li>I shall never intentionally do or administer anything to the overall harm of my patients.</li>
					<li>I will not permit considerations of gender, race, religion, political affiliation, sexual orientation, nationality, or social standing to influence my duty of care.</li>
					<li>I will oppose policies in breach of human rights and will not participate in them. I will strive to change laws that are contrary to my profession's ethics and will work towards a fairer distribution of health resources.</li>
					<li>I will assist my patients to make informed decisions that coincide with their own values and beliefs and will uphold patient confidentiality.</li>
					<li>I will recognise the limits of my knowledge and seek to maintain and increase my understanding and skills throughout my professional life. I will acknowledge and try to remedy my own mistakes and honestly assess and respond to those of others.</li>
					<li>I will seek to promote the advancement of medical knowledge through teaching and research.</li>
					<li>I make this declaration solemnly, freely, and upon my honour.</li>
				</ol><br>

				<HR COLOR="steelblue" WIDTH="60%" ALIGN="LEFT">

				<iframe width='100%' height='100%' src="[config_legacy.wikiurl]Guide_to_Medicine&printable=yes&removelinks=1" frameborder="0" id="main_frame"></iframe>
				</body>
			</html>

		"}


/obj/item/book/manual/engineering_guide
	name = "Engineering Textbook"
	icon_state ="bookEngineering2"
	author = "Engineering Encyclopedia"
	title = "Engineering Textbook"

/obj/item/book/manual/engineering_guide/New()
	..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='100%' src="[config_legacy.wikiurl]Guide_to_Engineering&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>		</body>

		</html>

		"}


/obj/item/book/manual/chef_recipes
	name = "Chef Recipes"
	icon_state = "cooked_book"
	author = "Victoria Ponsonby"
	title = "Chef Recipes"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Food for Dummies</h1>
				Here is a guide on basic food recipes and also how to not poison your customers accidentally.

				<h3>Basics:</h3>
				Knead an egg and some flour to make dough. Bake that to make a bun or flatten and cut it.

				<h3>Burger:</h3>
				Put a bun and some meat into the microwave and turn it on. Then wait.

				<h3>Bread:</h3>
				Put some dough and an egg into the microwave and then wait.

				<h3>Waffles:</h3>
				Add two lumps of dough and 10 units of sugar to the microwave and then wait.

				<h3>Popcorn:</h3>
				Add 1 corn to the microwave and wait.

				<h3>Meat Steak:</h3>
				Put a slice of meat, 1 unit of salt, and 1 unit of pepper into the microwave and wait.

				<h3>Meat Pie:</h3>
				Put a flattened piece of dough and some meat into the microwave and wait.

				<h3>Boiled Spaghetti:</h3>
				Put the spaghetti (processed flour) and 5 units of water into the microwave and wait.

				<h3>Donuts:</h3>
				Add some dough and 5 units of sugar to the microwave and wait.

				<h3>Fries:</h3>
				Add one potato to the processor, then bake them in the microwave.


				</body>
			</html>
			"}


/obj/item/book/manual/barman_recipes
	name = "Barman Recipes"
	icon_state = "barbook"
	author = "Sir John Rose"
	title = "Barman Recipes"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Drinks for Dummies</h1>
				Here's a guide for some basic drinks.

				<h3>Black Russian:</h3>
				Mix vodka and Kahlua into a glass.

				<h3>Cafe Latte:</h3>
				Mix milk and coffee into a glass.

				<h3>Classic Martini:</h3>
				Mix vermouth and gin into a glass.

				<h3>Gin Tonic:</h3>
				Mix gin and tonic into a glass.

				<h3>Grog:</h3>
				Mix rum and water into a glass.

				<h3>Irish Cream:</h3>
				Mix cream and whiskey into a glass.

				<h3>The Manly Dorf:</h3>
				Mix ale and beer into a glass.

				<h3>Mead:</h3>
				Mix enzyme, water, and sugar into a glass.

				<h3>Screwdriver:</h3>
				Mix vodka and orange juice into a glass.

				</body>
			</html>
			"}


/obj/item/book/manual/detective
	name = "The Film Noir: Proper Procedures for Investigations"
	icon_state ="bookDetective"
	author = "The Company"
	title = "The Film Noir: Proper Procedures for Investigations"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Detective Work</h1>

				Between your bouts of self-narration and drinking whiskey on the rocks, you might get a case or two to solve.<br>
				To have the best chance to solve your case, follow these directions:
				<p>
				<ol>
					<li>Go to the crime scene. </li>
					<li>Take your scanner and scan EVERYTHING (Yes, the doors, the tables, even the dog). </li>
					<li>Once you are reasonably certain you have every scrap of evidence you can use, find all possible entry points and scan them, too. </li>
					<li>Return to your office. </li>
					<li>Using your forensic scanning computer, scan your scanner to upload all of your evidence into the database.</li>
					<li>Browse through the resulting dossiers, looking for the one that either has the most complete set of prints, or the most suspicious items handled. </li>
					<li>If you have 80% or more of the print (The print is displayed), go to step 10, otherwise continue to step 8.</li>
					<li>Look for clues from the suit fibres you found on your perpetrator, and go about looking for more evidence with this new information, scanning as you go. </li>
					<li>Try to get a fingerprint card of your perpetrator, as if used in the computer, the prints will be completed on their dossier.</li>
					<li>Assuming you have enough of a print to see it, grab the biggest complete piece of the print and search the security records for it. </li>
					<li>Since you now have both your dossier and the name of the person, print both out as evidence and get security to nab your baddie.</li>
					<li>Give yourself a pat on the back and a bottle of the ship's finest vodka, you did it!</li>
				</ol>
				<p>
				It really is that easy! Good luck!

				</body>
			</html>"}

/obj/item/book/manual/nuclear
	name = "Fission Mailed: Nuclear Sabotage 101"
	icon_state ="bookNuclear"
	author = "Syndicate"
	title = "Fission Mailed: Nuclear Sabotage 101"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Nuclear Explosives 101</h1>
				Hello and thank you for choosing the Syndicate for your nuclear information needs. Today's crash course will deal with the operation of a Nuclear Fission Device.<br><br>

				First and foremost, DO NOT TOUCH ANYTHING UNTIL THE BOMB IS IN PLACE. Pressing any button on the compacted bomb will cause it to extend and bolt itself into place. If this is done, to unbolt it, one must completely log in, which at this time may not be possible.<br>

				<h2>To make the nuclear device functional</h2>
				<ul>
					<li>Place the nuclear device in the designated detonation zone.</li>
					<li>Extend and anchor the nuclear device from its interface.</li>
					<li>Insert the nuclear authorisation disk into the slot.</li>
					<li>Type the numeric authorisation code into the keypad. This should have been provided.<br>
					<b>Note</b>: If you make a mistake, press R to reset the device.
					<li>Press the E button to log on to the device.</li>
				</ul><br>

				You now have activated the device. To deactivate the buttons at anytime, for example when you've already prepped the bomb for detonation, remove the authentication disk OR press R on the keypad.<br><br>
				Now the bomb CAN ONLY be detonated using the timer. Manual detonation is not an option. Toggle off the SAFETY.<br>
				<b>Note</b>: You wouldn't believe how many Syndicate Operatives with doctorates have forgotten this step.<br><br>

				So use the - - and + + to set a detonation time between 5 seconds and 10 minutes. Then press the timer toggle button to start the countdown. Now remove the authentication disk so that the buttons deactivate.<br>
				<b>Note</b>: THE BOMB IS STILL SET AND WILL DETONATE<br><br>

				Now before you remove the disk, if you need to move the bomb, you can toggle off the anchor, move it, and re-anchor.<br><br>

				Remember the order:<br>
				<b>Disk, Code, Safety, Timer, Disk, RUN!</b><br><br>
				Intelligence Analysts believe that normal corporate procedure is for the Facility Director to secure the nuclear authentication disk.<br><br>

				Good luck!
				</body>
			</html>
			"}

/obj/item/book/manual/atmospipes
	name = "Pipes and You: Getting To Know Your Scary Tools"
	icon_state = "pipingbook"
	author = "Maria Crash, Senior Atmospherics Technician"
	title = "Pipes and You: Getting To Know Your Scary Tools"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Contents">Contents</a></h1>
				<ol>
					<li><a href="#Foreword">Author's Foreword</a></li>
					<li><a href="#Basic">Basic Piping</a></li>
					<li><a href="#Insulated">Insulated Pipes</a></li>
					<li><a href="#Devices">Atmospherics Devices</a></li>
					<li><a href="#HES">Heat Exchange Systems</a></li>
					<li><a href="#Final">Final Checks</a></li>
				</ol><br>

				<h1><a name="Foreword"><U><B>HOW TO NOT SUCK QUITE SO HARD AT ATMOSPHERICS</B></U></a></h1><BR>
				<I>Or: What the fuck does a "pressure regulator" do?</I><BR><BR>

				Alright. It has come to my attention that a variety of people are unsure of what a "pipe" is and what it does.
				Apparently, there is an unnatural fear of these arcane devices and their "gases." Spooky, spooky. So,
				this will tell you what every device constructable by an ordinary pipe dispenser within atmospherics actually does.
				You are not going to learn what to do with them to be the super best person ever, or how to play guitar with passive gates,
				or something like that. Just what stuff does.<BR><BR>


				<h1><a name="Basic"><B>Basic Pipes</B></a></h1>
				<I>The boring ones.</I><BR>
				Most ordinary pipes are pretty straightforward. They hold gas. If gas is moving in a direction for some reason, gas will flow in that direction.
				That's about it. Even so, here's all of your wonderful pipe options.<BR>

				<ul>
				<li><b>Straight pipes:</b> They're pipes. One-meter sections. Straight line. Pretty simple. Just about every pipe and device is based around this
				standard one-meter size, so most things will take up as much space as one of these.</li>
				<li><b>Bent pipes:</b> Pipes with a 90 degree bend at the half-meter mark. My goodness.</li>
				<li><b>Pipe manifolds:</b> Pipes that are essentially a "T" shape, allowing you to connect three things at one point.</li>
				<li><b>4-way manifold:</b> A four-way junction.</li>
				<li><b>Pipe cap:</b> Caps off the end of a pipe. Open ends don't actually vent air, because of the way the pipes are assembled, so, uh, use them to decorate your house or something.</li>
				<li><b>Manual valve:</b> A valve that will block off airflow when turned. Can't be used by the AI or cyborgs, because they don't have hands.</li>
				<li><b>Manual T-valve:</b> Like a manual valve, but at the center of a manifold instead of a straight pipe.</li><BR><BR>
				</ul>

				An important note here is that pipes are now done in three distinct lines - general, supply, and scrubber. You can move gases between these with a universal adapter. Use the correct position for the correct location.
				Connecting scrubbers to a supply position pipe makes you an idiot who gives everyone a difficult job. Insulated and HE pipes don't go through these positions.

				<h1><a name="Insulated"><B>Insulated Pipes</B></a></h1>
				<li><I>Bent pipes:</I> Pipes with a 90 degree bend at the half-meter mark. My goodness.</li>
				<li><I>Pipe manifolds:</I> Pipes that are essentially a "T" shape, allowing you to connect three things at one point.</li>
				<li><I>4-way manifold:</I> A four-way junction.</li>
				<li><I>Pipe cap:</I> Caps off the end of a pipe. Open ends don't actually vent air, because of the way the pipes are assembled, so, uh. Use them to decorate your house or something.</li>
				<li><I>Manual Valve:</I> A valve that will block off airflow when turned. Can't be used by the AI or cyborgs, because they don't have hands.</li>
				<li><I>Manual T-Valve:</I> Like a manual valve, but at the center of a manifold instead of a straight pipe.</li><BR><BR>

				<h1><a name="Insulated"><B>Insulated Pipes</B></a></h1><BR>
				<I>Special Public Service Announcement.</I><BR>
				Our regular pipes are already insulated. These are completely worthless. Punch anyone who uses them.<BR><BR>

				<h1><a name="Devices"><B>Devices: </B></a></h1>
				<I>They actually do something.</I><BR>
				This is usually where people get frightened, afraid, and start calling on their gods and/or cowering in fear. Yes, I can see you doing that right now.
				Stop it. It's unbecoming. Most of these are fairly straightforward.<BR>

				<ul>
				<li><b>Gas pump:</b> Take a wild guess. It moves gas in the direction it's pointing (marked by the red line on one end). It moves it based on pressure, the maximum output being 15000 kPa (kilopascals).
				Ordinary atmospheric pressure, for comparison, is 101.3 kPa, and the minimum pressure of room-temperature pure oxygen needed to not suffocate in a matter of minutes is 16 kPa
				(though 18 kPa is preferred when using internals with pure oxygen, for various reasons). A high-powered variant will move gas more quickly at the expense of consuming more power. Do not turn the distribution loop up to 15000 kPa.
				You will make engiborgs cry and the Chief Engineer will beat you.</li>
				<li><b>Pressure regulator:</b> These replaced the old passive gates. You can choose to regulate pressure by input or output, and regulate flow rate. Regulating by input means that when input pressure is above the limit, gas will flow.
				Regulating by output means that when pressure is below the limit, gas will flow. Flow rate can be controlled.</li>
				<li><b>Unary vent:</b> The basic vent used in rooms. It pumps gas into the room, but can't suck it back out. Controlled by the room's air alarm system.</li>
				<li><b>Scrubber:</b> The other half of room equipment. Filters air, and can suck it in entirely in what's called a "panic siphon." Activating a panic siphon without very good reason will kill someone. Don't do it.</li>
				<li><b>Meter:</b> A little box with some gauges and numbers. Fasten it to any pipe or manifold and it'll read you the pressure in it. Very useful.</li>
				<li><b>Gas mixer:</b> Two sides are input, one side is output. Mixes the gases pumped into it at the ratio defined. The side perpendicular to the other two is "node 2," for reference, on non-mirrored mixers..
				Output is controlled by flow rate. There is also an "omni" variant that allows you to set input and output sections freely..</li>
				<li><b>Gas filter:</b> Essentially the opposite of a gas mixer. One side is input. The other two sides are output. One gas type will be filtered into the perpendicular output pipe,
				the rest will continue out the other side. Can also output from 0-4500 kPa. The "omni" vairant allows you to set input and output sections freely.</li>
				</ul>

				<h1><a name="HES"><B>Heat Exchange Systems</B></a></h1>
				<I>Will not set you on fire.</I><BR>
				These systems are used to only transfer heat between two pipes. They will not move gases or any other element, but will equalize the temperature (eventually). Note that because of how gases work (remember: pv=nRt),
				a higher temperature will raise pressure, and a lower one will lower temperature.<BR>

				<li><I>Pipe:</I> This is a pipe that will exchange heat with the surrounding atmosphere. Place in fire for superheating. Place in space for supercooling.</li>
				<li><I>Bent pipe:</I> Take a wild guess.</li>
				<li><I>Junction:</I> The point where you connect your normal pipes to heat exchange pipes. Not necessary for heat exchangers, but necessary for H/E pipes/bent pipes.</li>
				<li><I>Heat exchanger:</I> These funky-looking bits attach to an open pipe end. Put another heat exchanger directly across from it, and you can transfer heat across two pipes without having to have the gases touch.
				This normally shouldn't exchange with the ambient air, despite being totally exposed. Just don't ask questions.</li><BR>

				That's about it for pipes. Go forth, armed with this knowledge, and try not to break, burn down, or kill anything. Please.


				</body>
			</html>
			"}

/obj/item/book/manual/evaguide
	name = "EVA Gear and You: Not Spending All Day Inside, 2nd Edition"
	icon_state = "evabook"
	author = "Maria Crash, Senior Atmospherics Technician"
	title = "EVA Gear and You: Not Spending All Day Inside, 2nd Edition"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Foreword">EVA Gear and You: Not Spending All Day Inside, 2nd Edition</a></h1>
				<I>Or: How not to suffocate because there's a hole in your shoes</I><BR>

				<h2><a name="Contents">Contents</a></h2>
				<ol>
					<li><a href="#Foreword">A foreword on using EVA gear</a></li>
					<li><a href="#Softsuits">Use of Softsuits</a></li>
					<li><a href="#Voidsuits">Putting on a Voidsuit</a></li>
					<li><a href="#Hardsuits">Operation of Hardsuits</a></li>
					<li><a href="#Equipment">Cyclers and Other Modification Equipment</a></li>
					<li><a href="#Advice">Miscellaneous Advice</a></li>
					<li><a href="#Final">Final Checks</a></li>
				</ol>
				<br>

				EVA gear. Wonderful to use. It's useful for mining, engineering, and occasionally just surviving, if things are that bad. Most people have EVA training,
				but apparently there are some on a space station who don't. This guide should give you a basic idea of how to use this gear, safely. It's split into three main sections:
				softsuits, voidsuits, and hardsuits. General advice and instructions for modification are present as well.<BR><BR>

				One important point for synthetics and people using full-body prosthetics: You obviously don't need oxygen, but you do run the risk of overheating in vacuum.
				Rather than oxygen, use a suit cooling unit. Many emergency equipment stores don't hold them, unfortunately, but dedicated EVA stores will. Be aware of your heat tolerances.<BR><BR>

				<h2><a name="Softsuits">Softsuits and Emergency Equipment</a></h2>
				<I>The bulkiest things this side of Alpha Centauri</I><BR>
				These suits are the both grey ones that are stored in EVA and orange emergency suits in emergency lockers. They're the more simple to get on, but are also a lot bulkier, and provide less protection from environmental hazards such as radiation or physical impact.
				As Medical, Engineering, Security, and Mining all have voidsuits of their own, these don't see much use outside of emergencies. In an emergency, knowing how to put one on can save your life.<BR><BR>

				First, take the suit. It should be in three pieces: A top, a bottom, and a helmet. Put the bottom on first, shoes and the like will fit in it. If you have magnetic boots, however,
				put them on on top of the suit's feet. Next, get the top on, as you would a shirt. It can be somewhat awkward putting these pieces on, due to the makeup of the suit,
				but to an extent they will adjust to you. You can then find the snaps and seals around the waist, where the two pieces meet. Fasten these, and double-check their tightness.
				The red indicators around the waist of the lower half will turn green when this is done correctly. Next, put on whatever breathing apparatus you're using, be it a gas mask or a breath mask. Make sure the oxygen tube is fastened into it.
				Put on the helmet now, straightforward, and make sure the tube goes into the small opening specifically for internals. Again, fasten seals around the neck, a small indicator light in the inside of the helmet should go from red to off when all is fastened.
				There is a small slot on the side of the suit where an emergency oxygen tank or extended emergency oxygen tank will fit,
				but it is recommended to have a full-sized tank on your back for EVA.<BR><BR>

				Important note: When using these, especially in emergencies, be aware of your surroundings! These suits can tear or breach more easily than any other type, especially in an environment with broken glass and metal everywhere.
				If your suit is breached, you will be in deep trouble. Pressure issues can inhibit breathing even with internals.<BR><BR>

				These suits tend to be wearable by most species. They're large and flexible. They might be pretty uncomfortable for some, though, so keep that in mind.<BR><BR>

				<h2><a name="Voidsuits">Voidsuits</a></h2>
				<I>Heavy, uncomfortable, still the best option.</I><BR>
				These suits come in many specialized varieties. The most common are engineering, atmospherics, security, medical, and mining varieties.
				These provide a lot more protection than the standard suits, and depending on the specialization, can offer different protections.
				For example, security suits have armor plating, engineering suits have radiation protection, and atmospherics suits are rated for extremely high temperatures.<BR><BR>

				Similarly to the softsuits, these are split into three parts. Fastening the pant and top are mostly the same as the softsuits, with the exception that these are a bit heavier,
				though not as bulky. The helmet goes on differently, with the air tube feeding into the suit and out a hole near the left shoulder, while the helmet goes on turned ninety degrees counter-clockwise,
				and then is turned to face the front and sealed. There is a small button on the right side of the helmet that activates the helmet light.
				The tanks that fasten onto the side slot are emergency tanks, as well as full-sized oxygen tanks, leaving your back free for a backpack or satchel.<BR><BR>

				These suits generally only fit one species. NanoTrasen's are usually human-fitting by default, but there's equipment that can make modifications to the hardsuits to fit them to other species.<BR><BR>

				Later-model voidsuits can have magboots and helmets installed into the suit and deployed when needed. Check the operator's manual for individual suits to see how the helmets are installed.
				If a helmet is installed, you can skip it while putting the suit on, obviously. When deployed, it will deploy from the back of your neck, covering the head and sealing at the front.<BR><BR>

				<h2><a name="Hardsuits">Hardsuits/Rigs</a></h2>
				<I>The fancy stuff.</I><BR>
				Proper hardsuits are the most complex sort of EVA equipment available, and blur the line between spacesuits and smaller exosuits. They're sometimes known as 'rigs' or 'powered armor'.
				These are the suits with the widest variety of uses, owing to the wide variety of equipment that can be installed on them. Like voidsuits, they come in different, specialized varieties, each one offering different protections and different equipment.
				Equipment that can be installed includes weapons, power tools, mining equipment, medical equipment, AI assistants, and more.<BR><BR>

				Putting these on is relatively simple. They come as compact packs, worn like a backpack and secured with a harness. Activating them, though, is a more complex process. The suit deploys from the module similarly to helmets deploying from voidsuits.
				After it covers the whole body, the suit can be started. The startup sequence takes some time. The suit will automatically fit itself to your body, sealing each section individually - boots, gloves, pants, torso, and helmet - then connecting them.<BR><BR>

				Operating a hardsuit is a much more complicated proposal than operating other EVA equipment. While putting them on is relatively simple, and operating basic functions like oxygen and magboots is the same as other suits, the rest is far more complex.
				Consult the operator's manual for invidual pieces of equipment that you plan to use. Use of these for heavy work is only reccomended for people who have specialized training and extensive EVA experience.
				The potential of a suit breach is always there, and the use of powered equipment raises it significantly.<BR><BR>

				<h2><a name="Advice">Miscellaneous Advice</a></h2>
				<I>Pro tip: Safety first.</I><BR>
				There's a lot of general advice that can be helpful for people who haven't taken a long-form instruction course. Much of this is going to be fairly obvious safety advice, but it's never bad to remind yourself of that.<BR><BR>

				<ul>
					<li>Magboots are important. They can be the difference between keeping your footing and needing a rescue team. A tie-off or a jetpack can substitute if necessary.</li>
					<li>Be aware of breach hazards, especially in softsuits. Loss of suit pressure can be a fatal disaster.</li>
					<li>Keep an eye on your internals. Having to make two trips outside is better than running out of air.</li>
					<li>Similarly, keep an eye on the battery status of cooling units and other equipment.</li>
					<li>In vacuum, sound doesn't carry. Use a radio or sign language for communication.</li><BR><BR>
				</ul>

				<h2><a name="Equipment">Modification Equipment</a></h2>
				<I>How to actually make voidsuits fit you.</I><BR>
				There's a variety of equipment that can modify hardsuits to fit species that can't fit into them, making life quite a bit easier.<BR><BR>

				The first piece of equipment is a suit cycler. This is a large machine resembling the storage pods that are in place in some places. These are machines that will automatically tailor a suit to certain specifications.
				The largest uses of them are for their cleaning functions and their ability to tailor suits for a species. Do not enter them physically. You will die from any of the functions being activated, and it will hurt the whole time you're dying.
				These machines can both tailor a suit between species, and between types. This means you can convert engineering hardsuits to atmospherics, or the other way. This is useful. Use it if you can.<BR><BR>

				There's also modification kits that let you modify suits yourself. These are extremely difficult to use unless you understand the actual construction of the suit. I do not reccomend using them unless no other option is available.<BR><BR>

				<h2><a name="Final">Final Checks</a></h2>
				<ul>
					<li>Are all seals fastened correctly?</li>
					<li>If you have modified it manually, is absolutely everything sealed perfectly?</li>
					<li>Do you either have shoes on under the suit, or magnetic boots on over it?</li>
					<li>Do you have internals connected and activated?</li>
					<li>Do you have a way to communicate with the station in case something goes wrong?</li>
					<li>Do you have a second person watching if this is a training session?</li><BR>
				</ul>

				If you don't have any further issues, go out and do whatever is necessary.

				</body>
			</html>
			"}

//Books originally stored in manuals_vr. Consolidated.

/obj/item/book/manual/standard_operating_procedure
	name = "Standard Operating Procedure"
	desc = "A set of corporate guidelines for keeping space stations running smoothly."
	icon_state = "sop"
	author = "NanoTrasen"
	title = "Standard Operating Procedure"

/obj/item/book/manual/standard_operating_procedure/New()
	..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[config_legacy.wikiurl]Standard_Operating_Procedure&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/command_guide
	name = "The Chain of Command"
	desc = "A set of corporate guidelines outlining the entire command structure of NanoTrasen from top to bottom."
	icon_state = "commandGuide"
	author = "Jeremiah Acacius"
	title = "Corporate Regulations"

/obj/item/book/manual/command_guide/New()
	..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[config_legacy.wikiurl]Chain_of_Command&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/the_humanized_mice
	name = "The Humanized Mice"
	icon_state = "hum_mic"
	author = "Melora Creager"
	title = "The Humanized Mice"

/obj/item/book/manual/the_humanized_mice/New()
	..()
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<br>
				<h1>Excerpt: The Humanized Mice</h1>

				<i>The majority of this book's pages are irreparably damaged or defaced. This mostly intact article is the only legible excerpt.</i><BR><BR>
				<hr>
				<ul>
					<i>...terview, 05-04-20...<br>
					He says, "What we're really worried about is creating some sort of creature that would be functioning like a human being, yet have strong animal-like features.*<br>
					<ul><i>*Grotesque mutations have been reported.</i></ul>
					Certainly, if the mouse stood on its hind legs, if it stood on its hind legs and said, 'Hi, I'm Mickey!' we'd be worried. We'd be more than worried," the doctor said.<br>
					We are moving rapidly into a post-Darwinian era, an era when species will no longer exist.<br>
					Once the general public gets the hang of genetic engineering, there will be an explosion of monstrous creations.<br>
					Designing creatures will be a new art form as creative as painting or sculpture.<br>
					Few of the new creations will be masterpieces, but all will bring joy to their creators and diversity to our fauna and flora.<br>
					...<br>
					A 60 million-year-old mouse that had a rare and poisonous bite? The humanized mice?<br>
					They will have to explain themselves.<br>
					...<br>
					What if the human mind somehow got trapped inside of a sheep's head?<br>
					What if...What if...What if...<br>
					...<br>
					Although constitutional prohibitions against slavery prevent the patenting of people, some of my best friends are clones.<br>
					Topping seasonal wishlists, uncertainties about the health and lifespan of clones persist.<br>
					...<br>
					On the underside of the aging spaceship, genetic replicas of existing dogs thrive alongside tiny bodies hidden in flowerpots in a sand-filled fishtank.<br></i>

				</ul><br>

				<HR COLOR="steelblue" WIDTH="60%" ALIGN="LEFT">

				</body>
			</html>

		"}

/////////////////////////////////////////////
/////////////////////////////////////////////
/////	SOP & CorpReg Special Editions	/////
/////////////////////////////////////////////
/////////////////////////////////////////////

/obj/item/book/manual/legal/sop_vol1
	name = "SOP Volume 1: Alert Levels"
	icon_state = "sop_se"
	author = "NanoTrasen"
	title = "SOP Volume 1: Alert Levels"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Volume One: Alert Levels</h1>
				<hr>
				<h2>Code Green - All Clear</h2>

				Standard operating level. No suspected, or immediate threat to the station. All departments may carry out work as normal.<BR><BR>
				<ul>
					<li> Suit sensors are not required to be on.</li>
					<li> Security may have weapons visible but they must be holstered.</li>
					<li> Security may not wear specialized body armor.</li>
					<li> Crew members may freely walk in the hallways.</li>
					<li> Crew members may freely walk in the maintenance hallways.</li>
					<li> AI/Cyborgs have no need to bolt down any secure areas.</li>
					<li> Security must respect the privacy of crew members and no unauthorized searches are allowed.</li><BR>
				</ul>
				<hr>
				<h2>Code Blue - Suspected Threat</h2>

				Elevated alert level. There are reports or other evidence available to indicate that there is a possible threat to the station.<BR><BR>
				<ul>
					<li> Suit sensors are mandatory to at least vital trackers, but coordinate positions are not required.</li>
					<li> Security may have weapons visible but they must be holstered.</li>
					<li> Security may not use specialized body armor.</li>
					<li> Crew members may be searched by security with probable cause.</li>
					<li> AI/Cyborgs may bolt down high secure areas.</li>
					<li> Maintenance hallways are now restricted to Medical, Engineering, and Security only.</li><BR>
				</ul>
				<hr>
				<h2>Code Yellow - Security Alert</h2>

				Raised alert level. Security threat on the facility. Issued by Central Command, the Colony Director, or the Head of Security. If the Head of Security is not present or available, another Head of Staff may issue a Code Yellow.<BR><BR>
				<ul>
					<li> Security staff may have weapons visible, random searches are NOT permitted.</li>
					<li> Security may inspect and search departments respectfully by order of Central Command, The colony director(Or acting), or the Head of Security.</li>
					<li> Security may use body armor.</li>
					<li> Crew members may be searched by security with probable cause.</li>
					<li> Crew are to follow the instruction of the Security Department.</li><BR>
				</ul>
				<hr>
				<h2>Code Orange - Engineering Alert</h2>

				Raised alert level. A major engineering-related emergency, such as many active breaches from meteors or possible engine delamination. Issued by Central Command, the Colony Director, or the Chief Engineer. If the Chief Engineer is not present or available, another Head of Staff may issue a Code Orange.<BR><BR>
				<ul>
					<li> Crew are to avoid affected or damaged areas of the station with the exception of Engineering and Atmospherics staff, and the medical team if needed.</li>
					<li> Security may detain any other staff entering affected and damaged areas for neglect of duty.</li>
					<li> Engineering may be allowed access to any area of the facility if it pertains to the declaration of alert.</li>
					<li> Crew are to follow the instruction of the Engineering Department.</li><BR>
				</ul>
				<hr>
				<h2>Code Violet - Medical Emergency</h2>

				Raised alert level. A medical emergency has occurred, such as a virus outbreak or a large number of injured personnel. Issued by Central Command, the Colony Director, or the Chief Medical Officer. If the Chief Medical officer is not present or available, another Head of Staff may issue a Code Violet.<BR><BR>
				<ul>
					<li> Crew are to avoid interfering or getting in the way of Medical personnel at all costs.</li>
					<li> Crew are to stay in their respective departments.</li>
					<li> All aboard are required to set their suit sensors to tracking or face charges of negligence.</li>
					<li> Security may detain any staff attempting to breach quarantine if a virus outbreak has occurred.</li>
					<li> The Medical Team may be allowed elevated access to perform essential duties</li>
					<li> Crew are to follow the instruction of the Medical Department. Else wise crew can be charged with negligence of duty.</li><BR>
				</ul>
				<hr>
				<h2>Code Red - Confirmed Threat</h2>

				Maximum alert level. There is an immediate threat to the station or severe damage. Martial Law is in effect.<BR><BR>
				<ul>
					<li> Suit sensors are to be turned fully on at all times, set to tracking, violators can be detained by Security.</li>
					<li> Security can raid departments and arrest any crew member deemed a threat to the facility.</li>
					<li> All crew members must remain in their respective departments.</li>
					<li> AI/Cyborgs may bolt down maintenance and airlocks leading to the exterior of the facility.</li>
					<li> Energy guns, laser guns, and riot gear are allowed to be given out to security personnel if the <<Head of Security|HoS>> or <<Warden>> agree.</li>
					<li> All orders from Heads of Staff and Security must be followed, any disobedience is punishable.</li><BR>
				</ul>
				<hr>
				<h2>Code Delta - Imminent Destruction</h2>

				The station's self destruct mechanism has been engaged due to overwhelming threat to the station. Martial Law is in effect.<BR><BR>
				<ul>
					<li> Suit sensors are to be turned fully on at all times.</li>
					<li> All crew members are to evacuate immediately, if possible.</li>
					<li> Security may use force to ensure total evacuation of the crew.</li><BR>
				</ul>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the Standard Operating Procedure at the time of its publication. Standing policy is that the most recent amendments to Standard Operating Procedure are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/sop_vol2
	name = "SOP Volume 2: Emergency Situations Protocol"
	icon_state = "sop_se"
	author = "NanoTrasen"
	title = "SOP Volume 2: Emergency Situations Protocol"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Volume Two: Emergency Situations Protocol</h1>
				<hr>
				<h2>Evacuation Procedure</h2>
				<ul>
					<li> All personnel are to evacuate on the escape pods or the emergency shuttle, which Central Command sends.</li>
					<li> All personnel are required to assist with evacuation. All crew must be evacuated, regardless of their consciousness.</li>
					<li> Prisoners are to be brought to the secure area of the escape shuttle, except for prisoners who pose a severe threat.</li>
					<li> Unsleeved bodies are to be brought back to Central Command for processing.</li>
					<li> AI units may be brought to Central Command on portable card devices (InteliCards) if structural failure is likely or AI units wish to leave.</li>
					<li> Mechs and Cyborg units are to be hauled to the escape shuttle for Central Command to inspect.</li>
					<li> Authorizing early shuttle launches is <b>not allowed</b> unless there is an immediate threat to shuttle integrity.</li><BR>
				</ul>
				<hr>
				<h2>Radiation Storm</h2>
				<ul>
					<li> All crew to move to the maintenance tunnels.</li>
					<li> Wait a while until it's safe to move again, and continue your business. Report to Medbay if you're feeling strange.</li>
					<li> Medbay staff should be ready to administer anti-radiation medications to the ones who got caught in the storm.</li><BR>
				</ul>
				<hr>
				<h2>Viral Outbreak</h2>
				<ul>
					<li> If a severe viral strain is on board the station, the Chief Medical Officer is required to quarantine infected parts of the station with the help of security.</li>
					<li> All infected crew are to be isolated in Virology or Medbay.</li>
					<li> Sterile masks/Internals and gloves are mandatory for medical personnel and recommended for crew.</li>
					<li> Quarantine must be maintained until the outbreak is contained and resolved.</li>
					<li> A code violet is to be called.</li><BR>
				</ul>
				<hr>
				<h2>Singularity Containment Failure</h2>
				<ul>
					<li> Observation and notification of Singularity movement.</li>
					<li> Evacuation to be called if deemed a major threat to station integrity.</li>
					<li> Use bombs or Bag of Holding to destroy singularity.</li>
					<li> Demotion of Chief Engineer or Engineer and reparation of the engine if no threat manifests.</li>
					<li> A code Orange is to be called.</li><BR>
				</ul>
				<hr>
				<h2>Tesla Energy Containment Failure</h2>
				<ul>
					<li> A code Orange is to be called.</li>
					<li> W.I.P </li><BR>
				</ul>
				<hr>
				<h2>Extraterrestrial Takeover</h2>
				<ul>
					<li> Prevent infection from spreading to Central Command.</li>
					<li> Destroy all extraterrestrial sources on the station.</li>
					<li> Round up all forms of extraterrestrial lifeforms and contain or terminate them, do not terminate if there is a chance of containment.</li>
					<li> If extraterrestrial forces cannot be defeated, arm and detonate the <<Nuclear Fission Explosive>> to ensure their suppression.</li>
					<li> A code red should be called.</li><BR>
				</ul>
				<hr>
				<h2>Phoron</h2>

				Phoron is an element that is both very toxic and very flammable.  Phoron in its solid state is generally safe to handle, if not exposed to flame, while liquid and gaseous phoron present a health and fire hazard that will ignite extremely easily.  If orange particles are found floating in the air, phoron is in the air.<BR><BR>
				<ul>
					<li> Allow emergency services to resolve the situation, Call an Orange Alert if the affected area is more then two rooms or has the easy potential to spread.</li><BR>
				</ul>
				<b>If you see phoron in the air and are not currently inside the room, follow these steps;</b>
				<ul>
					<li> Do <b>not</b> enter the room, especially if no inflatable barriers have been set up.  You will spread the phoron and endanger yourself and the rest of the crew.</li>
					<li> Inform everyone that there is a phoron leak.  Be specific about where the leak is.  If a radio is not available, use an intercom.</li>
					<li> Let the engineering team handle the leak.  Do not hinder emergency services.</li><BR>
				</ul>
				<b>If you are in a room containing phoron, follow these steps immediately.</b>
				<ul>
					<li> Immediately put on a closed air supply.  All personnel are given a survival kit containing a mask and a small tank containing oxygen, commonly referred to as internals.</li>
					<li> Call for help, tell everyone that there is phoron where you are.  If a radio is not available, use an intercom.  Do not open any emergency shutters unless instructed to do so by trained personnel, or you will endanger the crew.</li>
					<li> Do not panic.  Brief phoron inhalation takes a long time to kill a person and can be reversed with medical care.</li>
					<li> <b>Do not light any fires or cause any sparks!</b> Phoron is very flammable, and a phoron fire is extremely dangerous.</li>
					<li> When you are rescued by trained personnel, be sure to have your clothes decontaminated, as phoron can cling to them, making them toxic to wear.  A simple wash is enough to remove the remaining phoron.</li><BR>
				</ul>
				<hr>
				<h2>In Case of Fire</h2>

				If a fire occurs, note the information below.<BR><BR>
				<ul>
					<li> An Orange Level Alert should be called.</li>
					<li> Fire shutters should activate automatically. If for some reason they do not, you can manually activate them by pulling a fire alarm.</li>
					<li> Immediate evacuation of all untrained personnel.</li>
					<li> Fire alarms to be used to control the hazard.</li>
					<li> Atmospheric Technicians and Station Engineers are to remove the hazard.</li>
					<li> Pump air back into the area when fixed.</li>
					<li> Ensure the damage is repaired.</li>
					<li> Anyone besides Engineering, Atmospherics, and Medical personnel are strictly prohibited from being in the area.</li><BR>
				</ul>
				<hr>
				<h2>Fire Safety</h2>

				As the station is merely a structure surrounded by vacuum and filled with air, fire safety is very important.  The following restrictions must be followed, or loss of life may occur.<BR><BR>
				<ul>
					<li> Smoking or any open flames are not allowed in any areas that bear a fire hazard sign or a no smoking sign.</li>
					<li> Flames cannot be left unattended.  This includes the incinerator and the toxins mixing room.</li><BR>
				</ul>
				<hr>
				<h2>Hull Breach</h2>

				In the event of a section of the station being depressurized, these steps are to be followed.<BR><BR>
				<ul>
					<li> Allow emergency services to resolve the situation, Call an Orange Alert</li><BR>
				</ul>
				<b>If you are not in the breach;</b>
				<ul>
					<li> Inform everyone that there is a breach.  Be specific.  If a radio is not available, use an intercom.</li>
					<li> Do <b>not</b> open any emergency shutters, or you may spread the breach and endanger yourself and the crew.  Assume that any downed shutter has a vacuum on the other side, even if not flashing.</li><BR>
				</ul>
				<b>If you are in the breach;</b>
				<ul>
					<li> Immediately put on a closed air supply. All personnel are given a survival kit containing a mask and a small tank containing oxygen, commonly referred to as internals.</li>
					<li> Call for help over the radio, and be specific on your location and that there is a breach.  If a radio is not available, use an intercom.</li>
					<li> If possible, locate an emergency closet.  They are light-blue colored and contain emergency softsuits, which are designed to be worn easily.  Put one on as soon as possible, as a lack of pressure can be fatal.  Emergency closets also contain spare internals.</li>
					<li> Do not open any emergency shutters if not instructed to do so by trained personnel, or you may endanger the crew.</li>
					<li>The engineering team is to repair breaches as soon as possible.</li><BR>
				</ul>
				<hr>
				<h2>Incoming Meteors, Space Dust, and Other Objects</h2>

				If objects approaching the station are expected to impact at high speeds, follow the below steps to ensure your safety.<BR><BR>
				<ul>
					<li> Move to the center of the station, as it is safest from external impacts.</li>
					<li> If a room is damaged from impact, do not enter.</li>
					<li> Once the threat has passed, personnel may return to their previous location, if it was not damaged from the impact.</li>
					<li> Damages are to be repaired by the engineering team.</li>
					<li> If the room you are in suffers an impact and causes a hull breach, refer to the Hull Breaches section.</li><BR>
				</ul>
				<hr>
				<h2>Supermatter Delamination</h2>

				The station depends on Supermatter to power everything on board.  All personnel should be aware of how to act in the event of delamination.<BR><BR>
				<b>Engineering Personnel:</b>
				<ul>
					<li> Refer to the Supermatter Engine manual for methods on stabilizing the engine.</li>
					<li> If the engine cannot be stabilized, the Chief Engineer should eject it.  If there is no Chief Engineer, the station AI should do so.</li>
					<li> If an ejection is not possible, evacuate all personnel from engineering.  Supermatter delamination will cause a large explosion, which will be fatal.</li>
					<li> Evacuate if possible and await rescue if the engine cannot be saved.</li><BR>
				</ul>
				<b>Medical Personnel:</b>
				<ul>
					<li> Prepare anti-radiation and antitoxins to distribute, in case the engine cannot be saved.</li>
					<li> Small amounts of anti-hallucinogenics are recommended to be distributed if delamination occurs.</li>
					<li> Evacuate if possible and await rescue if the engine cannot be saved.</li><BR>
				</ul>
				<b>Command Personnel:</b>
				<ul>
					<li> Facilitate the evacuation of all personnel to a safe area to await rescue if the engine cannot be saved.</li><BR>
				</ul>
				<b>Everyone Else:</b>
				<ul>
					<li> Prepare to evacuate to a designated safe area, which is distant enough to protect you from the effects of the delamination.</li>
					<li> If movement on the surface is not possible, move as far from engineering as possible, as it will minimize the effects of delamination.</li>
					<li> Be aware that delamination effects include a large explosion near the epicenter of where the supermatter was, as well as a burst of radiation.  You may also start to hallucinate.  You should report to medical after the delamination, if you failed to escape it.</li><BR>
				</ul>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the Standard Operating Procedure at the time of its publication. Standing policy is that the most recent amendments to Standard Operating Procedure are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/sop_vol3
	name = "SOP Volume 3: Legal Clauses"
	icon_state = "sop_se"
	author = "NanoTrasen"
	title = "SOP Volume 3: Legal Clauses"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Volume Three: Legal Clauses</h1>
				<hr>
				<h2>Corporate Labor Charter</h2>
				<ul>
					<li>Everyone has the right to work, free choice of employment, just and favorable conditions of work, and to protection against unemployment.</li>
						<ul><i><li>What it means: Barring an emergency in which you are qualified and able to help safely resolve, you cannot be conscripted or otherwise forced into an occupation that you have no desire or ability to meet the responsibilities of. For example, a Cargo Technician cannot be fired for not following orders to go mining, because that's a completely different job.</li></i></ul>
					<li>Everyone, without any discrimination, has the right to equal pay for equal work.</li>
						<ul><i><li>What it means: You cannot be denied work or pay because of your appearance, race, gender, species, or religious affiliation within reason. For example, a Tajaran cannot be removed from command just for being a Tajaran.</li></i></ul>
					<li>Everyone who works has the right to just and favorable remuneration ensuring for himself and his family an existence worthy of a sentient being's dignity, and supplemented, if necessary, by other means of social protection.</li>
						<ul><i><li>What it means: You are paid a living wage in the form of Thalers via electronic deposit in such a way that you may access and spend those funds freely. You are also granted, if you so desire, certain benefits from the company such as safe and affordable housing at the nearby colony. For example, paying you with commodities such as meat is not permitted (even if you would be okay with being paid in meat).</li></i></ul>
					<li>Everyone has the right to form and to join trade unions for the protection of his/her interests.</li>
						<ul><i><li>What it means: You can be part of a union. This is self explanatory.</i></ul>
					<li>Everyone has the right to rest and leisure, including reasonable limitation of working hours and periodic holidays with pay.</li>
						<ul><i><li>What it means: All employees are entitled to break time, vacations, and holidays as outlined in your employee handbook. (( What this actually means OOCly: Nobody can come along and fire you or punish you for not doing your job 24/7 on the server. As long as the needs of your current job are met within reason, and there's no current emergencies, you can bugger off to do lewds. Just remember to clock out.))</li></i></ul>
					<li>Everyone has the right to a non-hostile workplace, and will not be forced to stay against their will.</li>
						<ul><i><li>What it means: If Employees feel that they are being harassed, they have the right to quit. No contract or agreement may force them to continue working or penalize them if they do not. That said, a superior also has the right to punish you (up to and including termination) if you are being excessively cruel or combative despite requests to stop such actions. A company may also refuse service to any customers that are being abusive.</li></i></ul></li><BR>
				</ul>
				Violation of employee labor rights is punishable under Corporate Regulations c.123.<BR><BR>
				<hr>
				<h2>Going on break</h2>

				There are time clock terminals available across the station in areas near the bridge, the bar, and elsewhere. If you plan in advance to go off duty for the rest of the shift, please use these terminals so your job role can be filled in by another crew member.

				Clocking out is not necessary if you plan to return to your duties within a half hour. It is, however, still polite to inform your coworkers that you are going on a short break. Intercourse is Prohibited unless clocked out.<BR><BR>
				<hr>
				<h2>Nanotrasen Privacy Policy</h2>

				Under normal station operation, the invasion of private areas such as locked dorms, bathrooms, personal offices, personal belongings, personal lockers, or other personal space is highly illegal without consent of the owner or a search warrant. Furthermore, the use of thermal imaging goggles or other artificial means of observing crew in private areas such as tracking devices is also strictly forbidden without explicit consent or warrant, and the tools used to conduct such crimes are considered contraband. If your right to privacy is violated by security or other members of the crew, contact the Colony Director or Central Command to submit an official complaint. If this violation of privacy results in the conviction of a crime, you may be eligible to have the incident voided by order of Central Command and be compensated for wrongful arrest.

				This privacy policy may at times be suspended for the greater security of the station crew. If heightened security alertness is abused by the command staff, such as failing to lower the alert level after an incident, or raising the alert level when there is no incident, please contract your NanoTrasen Representative as soon as possible.

				Violation of employee privacy is punishable under Corporate Regulations c.221.<BR><BR>
				<hr>
				<h2>Hazardous Area Operations</h2>

				It is the duty of every member of the crew to safeguard their life and ensure their own physical wellbeing, first and foremost. However, in the process of performing the duties of their assigned roles, crewmembers are sometimes expected to enter or operate in hazardous environments. When such hazards cannot be avoided, NanoTrasen has allocated the appropriate resources to the crew to mitigate risk.
				However, in the course of exploration, or for the purposes of recreation, some crew may encounter hazardous environments outside the bounds of standard NanoTrasen protocol. It is the duty of NanoTrasen’s Central Command authorities to ensure that such environments cannot be accessed accidentally by uninformed parties. Should a NanoTrasen employee expressly and of their own will demonstrate their desire to enter a marked hazardous zone, they automatically accept the following provisions:
				<ul>
					<li>Entering a hazardous zone outside of the line of assigned duties waives NanoTrasen Security and Medical forces of any obligation to render aid, up to and including corpse recovery.
					<li>Many hazardous areas have little to no Communications Hub or Suit Sensor Report coverage. As such, there may be no mechanism by which crew wellbeing or position may be tracked, and usual expectations regarding emergency responses are void.
					<li>Hazardous areas are considered to be outside of NanoTrasen’s contraband enforcement regulations. However, returning to a NanoTrasen owned environment with contraband retrieved from hazardous areas is a violation of Corporate Regulations. Any retrieved contraband must be secured and delivered directly to a steward of the Research or Security departments as soon as the crewmember returns from the hazardous area.</li><BR>
				</ul>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the Standard Operating Procedure at the time of its publication. Standing policy is that the most recent amendments to Standard Operating Procedure are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/sop_vol4
	name = "SOP Volume 4: Courtesy Procedures"
	icon_state = "sop_se"
	author = "NanoTrasen"
	title = "SOP Volume 4: Courtesy Procedures"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Volume Four: Courtesy Procedures</h1>
				<hr>
				<h2>Visitors</h2>

				As our facilities are mainly located in fringe space on the frontier and often act as a gateway to the frontier; as well as some installations being near colonies, such as the NSB Adephagia visitors are expected and common.  There are two types of visitors, those that are pre-authorized and those that are not.

				Pre-authorized visitors are those that have notified the station in advance.  They are easily distinguished by possessing an ID card.  No special processing is needed for them.  Those that lack an ID are visitors who were not pre-authorized.<BR><BR>

				Visitors who were not pre-authorized are still welcome to come aboard but must report to the Head of Personnel or Site Director for an identification card denoting them as visitors, upon arrival.  Upon obtaining an ID, they are to be treated as if they were pre-authorized.<BR><BR>

				Visitors must follow Corporate Regulations, as it applies to everyone.  Visitors are permitted free access to all public areas of the station. In addition, visitors are permitted to enter restricted areas with permission from the relevant Head of Staff or Site Director. The Head of Staff or Site Director retains the right to have the visitor removed from the restricted zone at any time.<BR><BR>

				Vessels docked to the station are not considered part of the station, but their owners are required to follow regulations while docked.  The crew may not board a docked vessel not belonging to the station without the consent of the vessel's owner, unless the owner is confirmed to be engaging in acts that threaten the life or liberty of a person, or are otherwise committing a Sol Gov high crime.<BR><BR>
				<hr>
				<h2>Dress Code</h2>

				All crew members and visitors, with exceptions listed below, are to wear the following at minimum: A shirt that covers the chest, pants, shorts or skirts that go no shorter than two inches above the knee, and some form of foot covering. Those in departments considered to be emergency services (Security, Medical, Engineering) should wear a marker denoting their department (even if they have a nudity permit!), examples being armbands, uniforms, badges, or other means.<BR><BR>

				Those in a department are expected to wear clothes appropriate to protect against common risks for the department.  Off duty personnel, visitors, and those engaging in certain recreational areas such as the Pool (if one is available on your facility) have less strict dress code, however clothing of some form must still be worn in public with the exception of a nudity permit, nudity permits are only handed out to species whose genitalia is not visible under normal circumstances or those with acceptable animalistic heritage such as Quadrapeds commonly known as "Taurs", this means for example human "Nudists" are not permitted and cannot legally hold a nudity permit, if someone who does not meet nudity permit criteria holds a nudity permit, the permit is considered nullified and the subject must agree to dress themselves or face a charge of indecent exposure.<BR><BR>

				Certain positions within NanoTrasen are expected to maintain a specific dress code. The strictness of these codes are ''Enforced'', ''Recommended'', and ''Suggested''. They are defined as follows:<BR><BR>
				<ul>
					<li>Failure or refusal to adhere to an enforced dress code may result in suspension or termination.</li>
						<ul><li>Security staff are enforced to wear Security clothing, or any clothing with dominant colors of red and black, or red and blue. If an individual has a nudity permit, they must at least wear a red security armband, appropriate security-issue outerwear, or a security hat. This is to ensure security is easily identifiable.</li>
							<li>Medical staff are enforced to wear sterile lab clothing while working in Medical facilities. Even if you have a nudity permit, you must cover up with a sterile lab coat and latex gloves while treating patients, if in surgical it is enforced to use a sterile mask to prevent infection as well.</li>
							<li>Science staff enforced to wear the appropriate protective gear for their sub-division while on duty, Xenobiologists must wear a biosuit, Xenoflorists must wear an apron, Xenoarcheologiests must wear a full anomaly suit including hood and goggles whenever handling an anomaly, all other science staff is required to wear protective eyewear, Science goggles and protective outerwear such as a lab coat or cloak. If a VIP is visiting the station, please dress appropriately for your department.</ul></li><BR>
				</ul>
				<ul>
					<li>Failure or refusal to adhere to the recommended dress code may result in suspension or termination only if an accident results from disobeying the dress code.</li>
						<ul><li>Engineering staff are recommended but not enforced to wear bright and easily recognizable clothing, such as yellows or oranges, to be easily spotted in case of an emergency.</li>
							<li>Service staff are recommended but not enforced to wear aprons while preparing or harvesting food. Bartenders and waiter staff have no specific dress code, but it is suggested that they agree on similar clothing to wear for the day.</ul></li><BR>
				</ul>
				<ul>
					<li>Failure or refusal to adhere to suggested dress codes are not valid grounds for punishment but may result in a lack of respect from co-workers.</li>
						<ul><li>Cargo/Mining staff are suggested but not enforced to wear uniforms made of highly durable cloth so as to avoid damage caused by physical labor.</li>
							<li> Colony Director and Head of Personnel are suggested but not enforced to wear their issued uniforms while on duty, or at least their hats. This is to ensure commanders are easily identifiable.</ul></li><BR>
				</ul>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the Standard Operating Procedure at the time of its publication. Standing policy is that the most recent amendments to Standard Operating Procedure are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/sop_vol5_1
	name = "SOP Volume 5.1: Department Regulations (Cargo)"
	icon_state = "sop_se_vol5"
	author = "NanoTrasen"
	title = "SOP Volume 5.1: Department Regulations (Cargo)"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Volume Five: Department Regulations (Cargo)</h1>
				<hr>
				<h2>Cargo and Logistics</h2>

				NanoTrasen provides a collection of Example Paperwork for Cargo that can be used during a shift. Keep several copies available at all times.<BR><BR>
				<hr>
				<h2>Ordering Cargo</h2>

				Orders are normally made in person at the cargo computer, and either signed or stamped by the head of staff. Any orders not made in person, such as the science department requesting you send them a box of monkey cubes who are unable to leave their department due to their work, should be sent a copy of the Item Request Form through the mail system. It is not required to go through all of this, but if the goods you ordered fall into the wrong hands, and it's ''your'' name on the order form, you will be liable if you cannot prove you did all the necessary procedures to ensure the order reached its destination. These procedures are more to protect yourself from liability so Internal Affairs doesn't complain.<BR><BR>

				Orders stamped with a head of department's stamp should take precedence over any orders without a stamp, and should be ordered first. In order of precedence from most to least important: Central Command stamp, Colony Director's stamp, Head of Personnel's stamp, Quartermaster's stamp, then finally, any other Head of Staff's stamp.<BR><BR>

				As a Cargo Technician, anything that is stamped with the Quartermaster's stamp or above should be automatically approved once any suspicions (if any) are resolved. The reason why is that the Quartermaster, Head of Personnel, the Colony Director, and Central Command all directly outrank you and can override you and order the item themselves if you refuse, and then probably fire you. As long as there's a stamp on the request form and the request was ordered in their name, you are not liable for whatever happens.<BR><BR>

				If something seems suspicious about any cargo request, such as a missing signature on a request for a pile of guns, you should immediately stall the order. If the order was made by someone who directly outranks you (as explained above) you need only require a confirmation of identity with both a stamp and a valid signature, and the order may be approved. If the suspicious request was made by someone who does not directly outrank you, contact the Head of Security <i>and</i> confirm the customer's identity before proceeding.<BR><BR>

				If the order is not automatically approved, then it is up to you whether the order is approved or declined. Does the HoS need to be stocking the armory with heavy weapons during code green? Does that assistant really need insulated gloves? Does engineering really need your latest shipment of diamonds to build a disco bar in space? If an order seems ridiculous, reject it. On the other hand, if the order is sensible, then accept it.<BR><BR>

				Either way, begin with the following steps:
				<ol>
					<li>If an order is accepted, skip this step. If it has been declined, stamp the request form with the "Denied" stamp, and put it in the file cabinet next to the cargo computer. Inform the customer that their request has been declined, and the reason why. Give the denied customer a copy of the form below, and keep a copy for your own records and paperclip it to the request form that was denied.</li>
					<li>If an order is accepted, skip this step. If the order is declined, this is the final step. Open the cargo computer and decline the order if it exists.</li>
					<li>The order has been accepted. Open the cargo computer and accept the order, or place the order and accept it if the order does not exist.</li>
					<li>Do not immediately call the cargo shuttle. Confirm with the customer, "Will that be all?" If so, or if they just wander off without confirming this, you may now call the cargo shuttle. If not, approve or decline the orders and follow the prior steps until there are no more requests. Keep an eye on the remaining cargo points each time a request is approved. If there aren't enough, confirm any requests that are more important to the customer first.</li>
					<li>Wait for the cargo shuttle to arrive. Ask the customer how they would like the cargo delivered. There are four methods of delivery: <b>Pickup, mail, MULE, or courier</b>. By default, cargo is pickup. <b>Dangerous cargo is pickup only</b>. Dangerous cargo is listed below, and is to be returned to Central Command if the order cannot be picked up within 30 minutes of arrival.</li>
						<ul><li>Authentication Key Pinpointer crate</li>
							<li>Electromagnetic weapons crate</li>
							<li>Incendiary weapons crate</li>
							<li>Phoron gas canister</li>
							<li>Supermatter Core</li>
							<li>Predatory Animal Crates</ul></li>
					<li>Upon arrival of the cargo, bring all cargo to the center of the cargo bay. You may be dealing with multiple orders from multiple people, so ensure you have sorted the cargo to its correct owner before delivering anything. Leave notes if nessicary. <b>Do not</b> open any crates for any reason unless instructed to do so by the customer.</li>
					<li>Once the cargo is sorted, deliver the cargo using the specified method to the specified location. By default, it is to be sent to the customer's department. Pickup orders are to be kept in the cargo bay (not the lobby) until the customer arrives to pick it up. Mailed orders are to be wrapped and tagged in the mail room and sent through the pipe network to their destination. MULE-delivered orders are to be loaded onto a MULE bot, turned on, and controlled using your PDA or manual input of destination. Courier delivered orders must have a cargo technician bring the order(s) directly to the destination, and if dealing with multiple orders, the cargo train can be used.</li>
					<li>Upon delivery of any order, ensure you are given back the manifest of the order. The Quartermaster is responsible for stamping manifests and returning them to Central Command.</li>
					<li>If possible, collect the empty crates of any completed orders for return to Central Command. If you have any stamped manifests, put them in one of these crates.</li>
					<li>Return the shuttle to Central Command.</li>
					<li>And then you're done! Relax and wait for the next cargo request.</li><BR>
				</ol>
				<hr>
				<h2>Mining Weapon Permits</h2>

				It has been ruled that all relevant employees be issued weapon permits to allow for personal protection in the course of carrying out the duties assigned to NanoTrasen’s specialized departments. As such, weaponry and permits have been distributed to those departments affected by this provision. The ownership of a Mining weapon permit represents the employee’s entitlement to carry any weapon conducive to maintaining a safe environment when engaged in EVA activities, or during transit to engage in such activities. The Mining weapon permit does not grant its bearer the right to bear or display arms inside a NanoTrasen facility, unless for the purposes of transportation to or from the Research or Security departments. Secure lockers have been provided for the express storage of these weapons. The on-station carrying of assigned melee weaponry, including but not limited to survival knives, outside of the Mining department is equally unlawful. Failure to properly secure all weaponry within the relevant department may result in penalties, up to and including the revocation of this Departmental weapon permit or the revocation of Departmental certification for an unstated period of time.<BR><BR>
				<ul>Under specific circumstances, namely the announcement of Codes: Red or Delta, the restrictions barring the carry or usage of assigned or recovered weaponry may be waived by an acting member of the on-site Command Staff. In the event that no Security crewmembers are available – either by incapacitation or other condition – these restrictions may also be lifted on Code: Yellow.</ul>
				<hr>
				<h2>Mining Mechanized Suit Equipment: Utility and Weapon Storage</h2>

				Mining crew assigned mechanized suits by the Research Department may only operate said equipment during EVA activities, or for the purpose of transportation to or from the Research Department. Weaponry or potentially hazardous utility devices mounted on mechanized suits must be detached and stored in the secure lockers provided to the department for weapons storage when they are not actively being used on the mechanized suit. The operation of an armed Mech onboard the station is unlawful and may be met with immediate lethal force.<BR><BR>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the Standard Operating Procedure at the time of its publication. Standing policy is that the most recent amendments to Standard Operating Procedure are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/sop_vol5_2
	name = "SOP Volume 5.2: Department Regulations (Engineering)"
	icon_state = "sop_se_vol5"
	author = "NanoTrasen"
	title = "SOP Volume 5.2: Department Regulations (Engineering)"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Volume Five: Department Regulations (Engineering)</h1>
				<hr>
				<h2>Construction/Repairs</h2>
				<i>This section is incomplete. Assign Central Command intern to complete this section at a later date.</i><BR><BR>
				<hr>
				<h2>Obtaining a Permit for Renovation</h2>
				<ul>
					<li>Should the desire arise to alter or upgrade parts of the station permanently, a permit must be requested from Central Command for construction.</li>
					<li>A blueprint should be submitted, mapping the area as it is, and then an additional blueprint displaying what changes are to be made.</li>
					<li>When the blueprint and permit is approved, you will be contacted by a Central Command representative.</li><BR>
				</ul>
				<i>((Construction Permits are just the in-character way of doing changes to the station. For changes to actually be permanent, consult the Guide to Mapping and submit changes to the GiT.))</i><BR><BR>
				<hr>
				<h2>Shields</h2>
				<ul>
					<li>Unless circumstances such as a meteor shower require it, hull shields and bubble shields should not be activated where they block access to station facilities, including external airlocks, docking ports, mass drivers or disposals/vents to space such as those in virology and xenobiology.</li>
					<li>Full-station hull shields or other precautionary measures may be installed ahead of time provided they are not activated.</li>
					<li>Local protective shielding for specific areas may be deployed freely where they do not impede station operations.</li><BR>
				</ul>
				<hr>
				<h2>Fire and Environmental Hazards</h2>
				<ul>
					<li>Immediate evacuation of all untrained personnel.</li>
					<li>Fire alarms to be used to control hazard.</li>
					<li>Atmospheric Technicians and Engineers are to remove hazard.</li><BR>
				</ul>
				<hr>
				<h2>Meteor Storm</h2>
				<ul>
					<li>All crew to move to central parts of the station.</li>
					<li>Damage is to be repaired by Atmospheric Technicians and Engineers after the threat has passed.</li><BR>
				</ul>
				<hr>
				<h2>Singularity Containment Failure</h2>
				<ul>
					<li>Observation of Singularity movement.</li>
					<li>Evacuation to be called if deemed a major threat to station integrity.</li>
					<li>Demotion of Chief Engineer and repair of Engine if no threat manifests.</li><BR>
				</ul>
				<hr>
				<h2>Supermatter Meltdown Imminent</h2>
				<ul>
					<li>Eject the Core.</li>
					<li>Chief Engineer has to submit an incident report to Internal Affairs.</li><BR>
				</ul>
				<hr>
				<h2>Supermatter Meltdown</h2>
				<ul>
					<li>Evacuate engineering and inform the CMO.</li>
					<li>Set up secondary power sources such as the solar arrays or the singularity if available.</li>
					<li>Demotion of Chief Engineer and repair of Engineering department.</li><BR>
				</ul>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the Standard Operating Procedure at the time of its publication. Standing policy is that the most recent amendments to Standard Operating Procedure are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/sop_vol5_3
	name = "SOP Volume 5.3: Department Regulations (Medical)"
	icon_state = "sop_se_vol5"
	author = "NanoTrasen"
	title = "SOP Volume 5.3: Department Regulations (Medical)"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Volume Five: Department Regulations (Medical)</h1>
				<hr>
				<h2>Medical Oath</h2>

				The Medical Oath sworn by recognized medical doctors in the employ of NanoTrasen.<BR><BR>
				<ul>
					<i><li> Now, as a new doctor, I solemnly promise that I will, to the best of my ability, serve sentient life-caring for the sick, promoting good health, and alleviating pain and suffering.</li>
					<li>I recognise that the practice of medicine is a privilege with which comes considerable responsibility and #I will not abuse my position.</li>
					<li> I will practise medicine with integrity, humility, honesty, and compassion-working with my fellow doctors and other colleagues to meet the needs of my patients.</li>
					<li> I shall never intentionally do or administer anything to the overall harm of my patients.</li>
					<li> I will not permit considerations of gender, race, religion, political affiliation, sexual orientation, nationality, or social standing to influence my duty of care.</li>
					<li> I will oppose policies in breach of human rights and will not participate in them. I will strive to change laws that are contrary to my profession's ethics and will work towards a fairer distribution of health resources.</li>
					<li> I will assist my patients to make informed decisions that coincide with their own values and beliefs and will uphold patient confidentiality.</li>
					<li> I will recognise the limits of my knowledge and seek to maintain and increase my understanding and skills throughout my professional life. I will acknowledge and try to remedy my own mistakes and honestly assess and respond to those of others.</li>
					<li> I will seek to promote the advancement of medical knowledge through teaching and research.</li>
					<li> I make this declaration solemnly, freely, and upon my honour.</li><BR></i>
				</ul>
				<hr>
				<h2>Non-Disclosure Policy</h2>

				All patient records, cloning, treatments, therapies, prescriptions, etc, almost anything the medical crew does, is <b>not</b> to be disclosed to other members of the station outside of Medbay without the (unanimous) permission of (all) the patient(s) directly involved. Even Security, the Colony Director, and Central Command are not allowed to share details of any past or ongoing treatments, and you are not required to inform them should they inquire unless you have the direct consent of the victim.<BR><BR>

				For example, if someone comes to medbay asking for someone else to be resleeved, you are to do so without hesitation. It's none of your business how they ended up dead, because you can't do anything to fix them besides cloning. If security comes asking questions about the individual you spoke to, you may disclose the identity of the individual who delivered the body, but you may not disclose any treatments they themselves received.<BR><BR>

				The only exception to this is the presentation of a valid warrant, usually issued by the Head of Security, in case Security has pressing reason to access any medical information beyond autopsy reports and concrete evidence as to why they believe Medbay would have such information.<BR><BR>

				Such warrants can be disputed up the chain of command if you think the disclosure by the warrant is unnecessary for its purpose or if the warrant is enforced out of bounds described within the warrant. It goes from Head of Security to Colony Director to CC itself. Internal Affairs Agents may assist in the process of determining if a warrant was valid and enforced correctly or not. Caregivers do not have to disclose information while a warrant is disputed and cannot be punished for not doing so. Failure to obey orders only applies after the warrant has been validated by the latest instance - Central Command. Delaying warrant enforcement out of spite, misplaced principle or because of a personal bias is obstruction of duty - disputes have to be in good faith when it is believed the Security is overstepping their authority.<BR><BR>

				Warrants that try to disclose details of conversations between caregiver and patient are only enforceable when there is concrete, physical evidence linking this person to a crime and even then only if the potentially disclosed information would be relevant to the crime or to aid in capture of fugitives. These warrants should be held to the highest scrutiny, as they're the biggest breach of patient confidentiality possible.<BR><BR>

				In case of emergency, warrants can be issued ex post facto to legitimize divulged information - like a caregiver telling suit sensors of a known and public fugitive to security. These warrants can be disputed still and if it is found to be invalid, the caregiver may have broken Non-Disclosure Policy unless they have been tricked or lied to to divulge the information by third parties  (See Corporate Regulations c.401 to punish said third parties accordingly), such as security convincing them that it is an active, dangerous criminal when it was in fact not or threaten them with violence or legal ramifications. In these cases, fear of life and freedom or good faith may exonerate the caregiver.<BR><BR>

				Repeated failure to obey the non-disclosure policy is grounds for termination from the medical department.<BR><BR>
				<hr>
				<h2>Right to Refuse Treatment</h2>

				As a patient, to consent to or refuse treatment, you must have the capacity to make that decision. Capacity means the ability to use and understand information to make a decision.<BR><BR>

				Under the terms of the Sol Central Mental Capacity Act of 2550, all adults are presumed to have sufficient capacity to decide on their own medical treatment, unless there is significant evidence to suggest otherwise.<BR><BR>

				For consent to treatment or refusal of treatment to be valid, the decision must be voluntary and you must be appropriately informed:<BR><BR>
				<ul>
					<li>Voluntary: you must make your decision to consent to or refuse treatment alone, and your decision must not be due to pressure by healthcare professionals, friends or family.
					<li>Appropriately informed: you must be given full information about what the treatment involves, including the benefits and risks, whether there are reasonable alternative treatments, and what will happen if treatment doesn’t go ahead.
				</ul>

				Doctors are authorized to refuse treatment if they believe alternative procedures would be even more detrimental to the well being of the patient (such as refusing anesthetics before a major surgery, which could cause the patient bleed out or go into shock or be harmed by moving during aforementioned surgery).<BR><BR>

				If you have capacity and make a voluntary and appropriately informed decision to refuse a treatment, your decision must be respected. This applies even if your decision would result in your death.<BR><BR>

				If you are 18 or older, have the capacity to make an advance decision about treatment and know that you have a condition that, in time, may affect your capacity to make decisions, or simply as part of your preparations for growing older, you can arrange an advance decision and have it included in your medical records. This is a decision to refuse particular medical treatments for a time in the future when you may be unable to make such a decision.<BR><BR>

				The treatments you are deciding to refuse must all be named in the advance decision and you need to be clear about all the circumstances in which you want to refuse this treatment. If the treatment is life-sustaining, your advance decision will need to be in writing, signed in the presence of a witness, and you must include a clear statement that the advance decision is to apply to the specific treatment, even if your life is at risk.<BR><BR>

				Provided your advance decision is valid and applicable to current circumstances, it has the same effect as a decision that is made by a person with capacity. This means that the healthcare professionals treating you cannot perform specific procedures or treatments against your wishes.<BR><BR>
				<hr>
				<h2>Phoron Spill</h2>

				Upon announcement of a phoron spill, respond immediately, following these steps:<BR><BR>
				<ul>
					<li>Get a cryobag. Be prepared to deal with a patient who has most likely panicked.</li>
					<li>Get a toxins first aid kit, or drag the medibot. Preferably a toxins first aid kit. Anti-toxin works faster than tricordazine.</li>
					<li>Get to the patient immediately and urge them to start making their way toward medbay as far as they can get, using the main corridor. If possible, have a second emergency responder get a biosuit and prepare their emergency oxygen tank and mask in case the patient failed to escape the zone of contamination. <b>Do not</b> under any circumstance attempt to hack any doors or otherwise gain entry to an area that would require actions that pose a risk of fire, such as tampering with wires, or cutting walls with a welder.</li>
					<li>Administer antitoxin and remove all clothing from the victim as soon as they are found. Continue to administer high doses of antitoxin as you return to medbay.</li>
					<li>If the victim collapses or is found already collapsed, immediately put the victim into the cryobag and rush to medbay.</li>
					<li>Use the cryo pods to stabilize the victim if their condition does not respond to antitoxin treatment. If the victim already had to be put inside a cryobag, then they should be put into a cryo pod immediately on arrival to medbay.</li>
					<li>After successful treatment, scan the patient for any internal injuries caused by the poisoning, such as a damaged liver. Treat if necessary.</li><BR>
				</ul>
				<hr>
				<h2>Viral Outbreak</h2>
				<ul>
					<li>All infected crew to be isolated in Virology or Medbay.</li>
					<li>Sterile masks/Internals and gloves are mandatory for medical personnel and recommended for crew.</li>
					<li>Quarantine must be maintained until outbreak can be contained and disease can be treated.</li><BR>
				</ul>
				<hr>
				<h2>Autopsy</h2>

				In the event that a deceased individual is discovered, or an individual perishes while under your care, an autopsy should be performed if one has not been done already.<BR><BR>
				<ul>
					<li>Security should be informed any time a corpse is discovered, regardless of whether the cause of death is known or not.</li>
					<li>An autopsy should be performed and recorded in an effort to resolve any questions that may arise later on, or if evidence is needed by Security.</li>
					<li>If you have valid reason to believe the death was a suicide, see <i>Suicide or other voluntary death</i> below for how to proceed.</li><BR>
				</ul>
				<hr>
				<h2>Suicide or other voluntary death</h2>

				In <b>all</b> cases of corpses being found that are potential suicides, Security should be contacted to investigate, just in case it's actually murder.<BR><BR>
				If a crewmember is exhibiting suicidal behavior, either verbally or through their actions, Security is obligated to detain the individual. However, after the offending crewmember has been detained, they are meant to be remanded to Medical's custody. The Psychiatric Ward exists specifically to detain any crew at risk of engaging in self-harm or other suicidal behaviors until they can be evaluated.<BR><BR>
				<ul>
					<li>When Security alerts Medical that they will be delivering an at-risk patient, prepare a straight jacket and sedatives.</li>
					<li>Meet Security in the Medical foyer with the patient, and escort <b>both</b> the officer and the patient to the Psychiatric Ward's processing airlock.</li>
					<li>Allow Security to remove the patient's personal effects. These must be stored in the corresponding cell's locker.</li>
					<li>Dress the patient in their new attire. Ideally a medical gown and/or white jumpsuit and white shoes.</li>
					<li>Buckle the patient to the bed in their cell and utilize the attached flasher to disorient the patient long enough for their restraints to be removed.</li>
					<li>Provide Yard Access unless the patient is a danger to other patients.</li>
					<li>In the event that a patient continues to attempt to cause themselves or others harm after being checked in to the Psychiatric Ward, call for Security and detain the patient again. Administer sedatives, and then a straight jacket. Transfer the patient to Solitary Confinement.</li>
					<li>The Patient should be held in the Psychiatric Ward until a Psychiatrist is capable of providing an evaluation. If they are determined to be a danger to themselves and others, their status should be upgraded to HuT. Otherwise, begin the process of releasing the patient and returning their possessions.</li><BR>
				</ul>
				<hr>
				<h2>Psychiatric Patient Expectations</h2>

				As a psychiatric patient, you are expected to abide by certain standards. Failure to obey will result in further punishment such as solitary confinement.<BR><BR>
				<ul>
					<li>If you are incarcerated, do not attempt escape.</li>
					<li>Further attempts at suicide will be met with solitary confinement. ((Also probably a server ban.))</li>
					<li>If you feel you have been unjustly incarcerated, contact the Psychiatrist, Chief Medical Officer, Internal Affairs, or Colony Director (in that order of first to last) to appeal your case.</li><BR>
				</ul>
				<hr>
				<h2>Psychiatric Patient Rights</h2>

				As a psychiatric patient, you are entitled to certain rights under any circumstance, regardless of the nature of your crimes.<BR><BR>
				<ul>
					<li>All patients are entitled to medical examination and aid if requested.</li>
					<li>All patients are entitled to speak to an <<Internal Affairs Agent>> for legal council if requested.</li>
					<li>All patientss are entitled to be allowed to send fax to Central Command if requested.</li>
					<li>All patients are entitled to food and water if requested.</li>
					<li>All patients are entitled to be provided with clothing--preferably the standard gown and/or white jumpsuit, and white shoes.</li>
					<li>All patients are entitled to safe and reasonable cell accommodations such as functional lighting, a place to sleep, and access to the brig's communal area if serving a sentence longer than 20 minutes.</li><BR>
				</ul>
				<hr>
				<h2>Resleeving Policy Regarding DNRs</h2>
				<ul>
					<li><b>Always</b> attempt resleeving if a mind and body record already exists in database and they are not explicitly listed as "Do Not Revive" (DNR) in their medical records. The presence of these records implies they want to be revived.</li>
					<li>If they are missing one of the two records, consult their medical records for any indications that they are DNR, and then mind-scan the victim post-mortem if they are missing the mind record, or use a card-sleeve to consult with them if they are missing a body record, so you can ask how they want their new body to be designed.</li>
					<li>If at any time you believe a DNR order has been falsified, or unjustly ordered, you should bring it to the attention of Central Command immediately. Falsifying a DNR order is punishable under the Reformation Act of 2560, and is viewed as attempted murder by Corporate Regulations.</li>
					<li>A valid DNR is usually:</li>
						<ol><li>A confirmed desire to not be resleeved. See also <i>Right to Refuse Treatment</i>. An employee may also specify a standing DNR in their medical and/or employment records. These are witnessed by central command's medical departments, and are legally binding.</li>
					<li>Reasonable order from a station's Chief Medical Officer or CentCom to withhold resleeving for known suicidal<sup>*</sup> individuals. Note there must be hard evidence of a suicide for this to be valid, such as announcing the suicide on the radio, or a note left behind, multiple eye witnesses, etc.</li>
					<li>Reasonable order from a director or CMO where resleeving may cause unnecessary tramua, ex. only on-hand mind record would leave the deceased remembering particularly traumatic experiences, such as a slow and drawn out death. This should only be used if alternative backup memory/mind scans are available off-site, or if the subject requests such before their demise (and meets the requirements of a valid DNR).</li>
					<li>Legal execution by order of Central Command and/or tribunal of heads as listed under legal code (obtaining copies of suspects body and mind data are encouraged in case of appeal by governing bodies).</ol></li><BR>
						<ul><li>Note that recreational activities in which someone expects to be possibly killed do not count as suicide. These individuals usually already have a scan on file in advance, and should always be revived.</ul></li><BR>
				</ul>
				<hr>
				<h2>Paramedic Weapon Permits</h2>

				It has been ruled that all relevant employees be issued weapon permits to allow for personal protection in the course of carrying out the duties assigned to NanoTrasen’s specialized departments. As such, weaponry and permits have been distributed to those departments affected by this provision. The ownership of a Paramedic weapon permit represents the employee’s entitlement to carry any weapon conducive to maintaining a safe environment when engaged in Hazardous Area recovery activities, or during transit to engage in such activities. The Paramedic weapon permit does not grant its bearer the right to bear or display arms inside a NanoTrasen facility, unless for the purposes of transportation to or from the Research or Security departments. Secure lockers have been provided for the express storage of these weapons. The on-station carrying of assigned melee weaponry, including but not limited to survival knives, outside of the Paramedic Triage Bay is equally unlawful. Failure to properly secure all weaponry within the relevant department may result in penalties, up to and including the revocation of this Departmental weapon permit or the revocation of Departmental certification for an unstated period of time.<BR><BR>
					<ul>Under specific circumstances, namely the announcement of Codes: Red or Delta, the restrictions barring the carry or usage of assigned or recovered weaponry may be waived by an acting member of the on-site Command Staff. In the event that no Security crewmembers are available – either by incapacitation or other condition – these restrictions may also be lifted on Code: Yellow.<BR><BR>
				</ul>
				<hr>
				<h2>Transcore Data Packet for Medical evacuations</h2>

				During the evacuation of the station, it is the <b>CMO's duty</b> to gather all medical information pertaining to personnel sleeves for the current work shift. Located inside their office should be a locker containing a "Transcore" Data packet which is to be inserted into the resleevers monitor for instant back up of this critical information. The CMO and other medical personnel are to guard this packet with their lives if need be, so that it can be transported off the station and given to the proper authorities!<BR><BR>
				<i>((OOC NOTE: THIS SHOULD ONLY BE INTERACTED WITH IN CODE DELTA OR EVACUATION SCENARIOS. YOU RISK OUT OF CHARACTER PUNISHMENT OTHERWISE.))</i><BR><BR>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the Standard Operating Procedure at the time of its publication. Standing policy is that the most recent amendments to Standard Operating Procedure are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/sop_vol5_4
	name = "SOP Volume 5.4: Department Regulations (Research)"
	icon_state = "sop_se_vol5"
	author = "NanoTrasen"
	title = "SOP Volume 5.4: Department Regulations (Research)"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Volume Five: Department Regulations (Research)</h1>
				<hr>
				<h2>Contraband Policy</h2>
				<ul>
					<li>Any items (including weapons) handled by the Research Department, even those normally deemed illegal by NanoTrasen, are completely legal within the confines of the research department. The moment these weapons leave the department, security is permitted to arrest for contraband as per Corporate Regulations c.212. This includes combat mechs. Combat mechs that don't have weapons equipped are still considered combat mechs for the purposes of this restriction.</li>
					<ul><li>All weapons handled by the research department should be for explicitly scientific purposes. The Research Director may selectively suspend this right at any time for any scientist for any reason.</li>
						<li>The surface exterior is considered within the Research Department's weapon allowance zone.</li>
						<li>If one or more of these weapons are used in a crime within the Research Department, this weapons policy is null and the weapons are treated as contraband upon arrest.</ul></li>
					<li>Explosives and launchers are to be handled with a bomb suit worn at all times.</li>
					<li>Any accidents relating to handling contraband are to be reported immediately to security and the research director. If an injury results from such a mishap, the medical staff should also be informed. If station damage occurs, contact engineering staff.</li>
					<li>Moving of weapons through main corridors is strictly forbidden. If security wants weapons for their own uses, or if there's a gateway mission about to happen, weapons may not be transported by scientists. All weapons must be transported by security officers as couriers.</li>
					<li>Explorers are the exception to the above restrictions. An explorer may carry arms and armor outside of the Research Department, but <b>only</b> to and from the gateway prep area, or shuttle hangar. Any off-duty explorer possessing weapons may be charged according to normal Corporate Regulations.</li><BR>
				</ul>
				<hr>
				<h2>Toxin Laboratory Procedure</h2>
				<ul>
					<li>Internals are required at all time while inside labs.</li>
					<li>During mixing process, an Explosive Ordnance Disposal suit is to be worn at all times.</li>
					<li>When mixing process is complete, mixing chamber is to be vented into space.</li>
					<li>All detonations are to be announced over public comms with a countdown, and must be detonated on the designated bomb range.</li>
					<li>Decontamination and medical examination.</li><BR>
				</ul>
				<hr>
				<h2>Scientific Expeditions</h2>
				<ul>
					<li>Gateway/Shuttle expeditions are to be organized by the Pathfinder unless CentComm commands otherwise. Failing the presence of a Pathfinder, a Research Director may organize an expedition. If two or more Explorer crewmembers wish to embark on an expedition when no Pathfinder or Research Director is available, they may do so after faxing notice of their intent to Central Command. The Colony Director should not be starting expeditions on their own without orders directly from Central Command.</li>
					<li>The Research Director has the ability to prevent an expedition from leaving, only if they have a valid reason for preventing it. Any research director that is found to be preventing an organized and equipped expedition from leaving, provided the minimum requirements for leaving, as listed under the next section are met, shall be considered as exceeding official authority.</li>
					<li>If the Pathfinder insists on bringing the Colony Director along, the Director should assign an Acting Director in their place.</li>
					<li>Heads of staff excluding the Research Director should <b>not</b> be participating in gateway missions or expeditions without explicit consent of the Colony Director.</li>

					<b>Initial Away Team</b><BR><BR>

					An initial expedition team must consist of the following where reasonably possible. A Pathfinder or equivalent should ideally make requests for staff via the PDA department relay, command channel with the appropriate heads of staff, or station announcements.<BR><BR>

					<ul><li>Either the Pathfinder, or the Research Director, acting as the leadership role for the expedition. In instances where both the Pathfinder and Research Director are out on the planet's surface, the Pathfinder retains command of the expedition, if the Pathfinder is incapacitated, the Research Director assumes command.</li>
						<li>All available Explorer crew members. This is their primary mission purpose, after all. They should be armed and armored with whatever equipment Research can provide. Their first goal should be to identify any threats near the landing site or gateway endpoint and ensure the path is clear for other members, before the next stage of the expedition.</li>
						<li>An Engineer may accompany to play the role of sapper, equipped with general purpose tools for hacking, construction, and deconstruction. One goal of the engineer should be to set up a telecommunications relay, if the site is discovered to be habitable and will maintain crew for a large part of the shift.</li>
						<li>A Scientist may accompany the initial expedition, equipped with camera, scientific instruments, and clipboard with pen and papers for taking notes. This can be the Research Director but it is preferred that a normal scientist come along instead or in addition to the Research Director. It may be better, however, if the scientist arrives after the site is cleaned and prepared.</li>
						<li>A Medical Doctor, Paramedic, Explorer Medic, or Search and Rescue crew member to play the role of medic, equipped with one of each type of first aid kit, and at least one cryobag for emergencies.</li>
						<li>If reasonably available, a Security Officer to play the role of escort, equipped with lethal ranged weapons of choice, or equipment from storage as assigned by the expedition leader. Their goal should be to secure the landing site with the initial team, and prevent any creatures from compromising the gateway or shuttle and making it back to the station.</li>
						<li>A Pilot should accompany any expeditions via shuttle, as their skills can be required to make a hasty departure, or ferry crew members to and from the landing zone to obtain additional supplies or return any casualties.</li>
						<li>Volunteers may enlist to join the initial expedition, if they sign a waiver before departing on the expedition, and have the required skills to fulfill one of the above roles.</li><BR>
					</ul>
					<li>If only one crewmember is occupying a department, they may not accept this request without going Off Duty, or receiving the approval of their Department Head. If no Department Head is present, any crewmember or crewmembers abandoning their department to embark on an expedition should be treated as a violation of Corporate Regulations c.222.</li>
					<li>Regardless of rank or certification, no crewmember may pilot and maneuver the Expedition shuttle, unless authorized for the purposes of emergency retrieval or reaction during a Code Red situation, without at least one passenger also capable of piloting the shuttle. Due to retrieval concerns in the event of an unexpected emergency, solo piloting of the shuttle should be treated as a violation of Corporate Regulations c.215, c.222, and c.402.</li><BR>
				</ul>
					<b>Pre-Mission Setup</b><BR><BR>

					<ul><li>All weapon-trained crew may be offered the opportunity to arm themselves from Security supplies or Research production. Crew armed in such a manner shall return the weaponry obtained to the armory for storage after the expedition is over.</li>
						<li>It is heavily recommended that when possible, energy weaponry should be used. Friendly fire incidents are easier to treat when surgery is not required in the field.</li>
						<li>All participants must bring a shortwave radio. Confirm a shared frequency on all shortwaves before embarking. Setting up a communications relay at the landing zone, while an admirable endeavor, is optional.</li>
						<li>The participants should be in sealed pressure suits unless the destination is already known, and confirmed to have a habitable atmosphere.</li>
						<li>Internals must be turned on prior to crossing the threshold of the gateway, and during all shuttle flights for the initial expedition.</li>
						<li>Magboots are recommended but not required.</li>
						<li>As each team member's loadout is complete, they should wait outside the gateway or shuttle until the mission begins.</li><BR>
					</ul>
					<b>Mid-Mission Operations</b><BR><BR>

					<ul><li>If separated from the group, or in an airless environment, establish communication immediately with other members of the group. If you are unable to re-establish communications, wait where you are for rescue. If you are in danger of running out of oxygen or supplies, move back towards the start of the mission, following any marker beacons that were laid down.</li>
						<li>Once present with the whole group, and no longer in an airless environment, all members but the assigned team leader should turn off their long range communications until separated again.</li>
						<li>If the group is scattered due to an imprecise gateway destination target, and the location of the return gateway is unknown, first objective is to locate and calibrate the return gateway. Return gateway can be calibrated using a multitool on the control panel in the center of the gate.</li>
						<li>Any artifacts or strange life forms should be documented as soon as it is safe to do so. If possible, they should be brought back. Having an artifact handling container may help with this.</li>
						<li>If an expedition participant is injured and needs surgery, they should be evacuated to the station immediately. The expedition should not proceed unless their role is satisfied by someone else, or they return to continue. (That said, you're allowed to use your better judgment. You're not going to get banned because someone died and you decided to keep going. That risk is kind of part of the whole point of things.)</li><BR>
					</ul>
					<b>Post-Mission Debriefing</b><BR><BR>

					<ul><li>The returning crew are not to leave the gateway room or shuttle hangar until allowed to do so by the Research Director, or if the research director is absent, then by the team leader, or next in command. During this time, participants should be screened for contraband, health, and mental well-being before returning to the rest of the station.</li>
						<li>If any staff are at risk of health complications such as parasitic life forms, viral infections, insanity, etc, they are to be immediately evacuated to the Medical Department for treatment.</li>
						<li>Excluding items that the Research Department wants to study, Security is to confiscate any contraband discovered during the mission.</li>
						<li>All weapons and armor taken for the trip should be returned to the armory, even if it was originally brought to the station through cargo. The exception is the Explorer equipment produced by Research, which can be stored securely in Research while the explorers are off duty.</li>
						<li>Other excess supplies are to be returned to their rightful department.</li>
						<li>A post-mission report should be faxed to Central Command detailing any discoveries located, and if any artifacts are recovered, if they will be returned to Central Command at the end of the shift or if they will be stored in Research to be collected after the shift ends.</li>
						<li>At this point, if the destination is habitable to normal crew without preparation, or if engineers wish to make it so, they may embark on follow-up expeditions to occupy and utilize the area for their purposes. This can '''only''' be done if the destination is safe for crew habitation, and a <<Pilot>> is available in the case of shuttle destinations, or the gateway prep area being cleaned of dangerous items for gateway destinations.</li><BR>
					</ul>
				</ul>
				<hr>
				<h2>Exploration Weapon Permits</h2>

				It has been ruled that all relevant employees be issued weapon permits to allow for personal protection in the course of carrying out the duties assigned to NanoTrasen’s specialized departments. As such, weaponry and permits have been distributed to those departments affected by this provision. The ownership of an Exploration weapon permit represents the employee’s entitlement to carry any weapon conducive to maintaining a safe environment when engaged in off-station activities, or during transit to engage in such activities. The Exploration weapon permit does not grant its bearer the right to bear or display arms inside a NanoTrasen facility, unless for the purposes of transportation to or from the Research or Security departments. Secure lockers have been provided for the express storage of these weapons. The on-station carrying of assigned melee weaponry, including but not limited to survival knives and machetes, outside of the Exploration department is equally unlawful. Failure to properly secure all weaponry within the relevant department may result in penalties, up to and including the revocation of this Departmental weapon permit or the revocation of Departmental certification for an unstated period of time.<BR><BR>
				<ul>Under specific circumstances, namely the announcement of Codes: Red or Delta, the restrictions barring the carry or usage of assigned or recovered weaponry may be waived by an acting member of the on-site Command Staff. In the event that no Security crewmembers are available – either by incapacitation or other condition – these restrictions may also be lifted on Code: Yellow.<BR><BR>
				</ul>
				<hr>
				<h2>Crew Restrictions: Special Concerns</h2>

				Due to concerns regarding the physical demands expected of Exploration, including but not limited to resilience and physical strength, Central Command has determined that any NanoTrasen employee under <u>2'6"/76.2cm</u> may not be employed on any NanoTrasen facility Exploration team. Transfer to the Exploration department after the assignment of another Departmental role is equally unlawful. However, employees matching (disqualifying criteria <u>2'6"/76.2cm</u>) may volunteer for, and be selected to go on, scientific expeditions as auxiliaries. This ruling may be appealed in the future.<BR><BR>
				<ul>
					<li>This policy has the following exceptions: NanoTrasen employees may be employed by the Exploration department if fulfilling the role of <u>Pilot/Aviator</u>. All other provisions apply.</li><BR>
				</ul>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the Standard Operating Procedure at the time of its publication. Standing policy is that the most recent amendments to Standard Operating Procedure are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/sop_vol5_5
	name = "SOP Volume 5.5: Department Regulations (Security)"
	icon_state = "sop_se_vol5"
	author = "NanoTrasen"
	title = "SOP Volume 5.5: Department Regulations (Security)"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Volume Five: Department Regulations (Security)</h1>
				<hr>
				<h2>Permits</h2>

				Any permit legally distributed by the Head of Security, the Colony Director, or (in the case of multi-shift permits) Central Command, some aspects of standard operating procedure may be overridden--within reason. The Colony Director's approving signature is required for all permits. If the Colony Director is not aboard or is not active, the current Acting Colony Director (usually the Head of Personnel), may substitute for the Colony Director's signature.<BR><BR>

				The Head of Security's signature is also required for all permits. Likewise, if the Head of Security is not available, the Head of Personnel may substitute for this signature. However, both approving signatures <b>must</b> be written by different individuals. Therefore, the Head of Personnel, or even Colony Director, may <b>never</b> sign for both the Colony Director's and Head of Security's approval on any permit. They must always be different.<BR><BR>

				Therefore, it is impossible for any one crew member to approve their own permit on their own. Both the Head of Security and Colony Director must stamp the document with their appropriate department head staffs stamps for the document to be valid. An Acting Colony Director must use the Head of Personnel's stamp and not the Colony Director's stamp. Only a member of Central Command can bypass this process with both a valid signature and a stamp from Central Command on the permit form.<BR><BR>

				The terms of the permit explicitly overriding standard operating procedure will be fully detailed in the permit's details. Anything not explicitly covered by the permit should be treated normally by standard operating procedure. If you believe there is an inconsistency, a conflict, or an unintended gap in a permit's details, contact your on-station Internal Affairs Agent or your assigned CentCom Representative.<BR><BR>

				If the terms of a permit are violated by the permit holder, or the individual owning the permit is involved in a violent crime (even if the permit is not relevant), the permit may be suspended until the end of the shift at the Head of Security's discretion. If the permit was abused to commit said violent crime, the permit is automatically terminated upon lawful conviction of a crime. If seeking to suspend or terminate a permit distributed by Central Command, proceed to do so, and then contact a CentCom Representative immediately so they may be informed of the incident.<BR><BR>

				The Colony Director and Head of Security (or equivalent signatories) may revoke their approval for a permit <b>at any time</b> if they believe the permit holder cannot be trusted with their privileges. If one or both of the signatories revoke their approval, Security staff is to be informed, and the permit is automatically null and void until the invalidated signature is replaced. Any item(s) normally deemed contraband without the permit become contraband once more, and the owner must comply with orders to surrender said item(s) to Security or risk facing charges.<BR><BR>

				When dealing with an individual who is in possession of anything normally deemed contraband that does <i>not</i> serve any lawfully prescribed medicinal purpose, security staff should always check for a permit. If the individual cannot produce the physical copy of the permit, the individual is to be charged normally as per Corporate Regulations c.118 and/or c.212.<BR><BR>
				<hr>
				<h2>Relevant Terminology</h2>
				<ul>
					<li><b>Armed</b>: Possessing weapons or anything being used as a weapon even if that is not its intended purpose (such as a crowbar). This includes non-lethals, and even basic tools if being used to assault someone.</li>
					<li><b>Brig</b>: The part of the station used to detain those who violate Corporate Regulations.</li>
					<li><b>Contraband</b>: Anything that is stolen or illegal to possess by anyone aboard the crew. For example, insulated gloves and multitools are not considered contraband on their own, but if they were stolen from the Engineering department, they qualify as contraband.</li>
					<li><b>Excessive Force</b>: Use of force beyond what is necessary to resolve a problem or neutralize a given threat.</li>
					<li><b>IAA</b>: An acronym that refers to an Internal Affairs Agent.</li>
					<li><b>Lethals</b>: Weapons designed for or able to switch to configurations intended for lethal force.</li>
					<li><b>Non-lethals</b>: Weapons that are not designed to be used lethally, and instead are meant to incapacitate suspects with little or no injury.</li>
					<li><b>Robust</b>: As an adjective; able to withstand or overcome adverse conditions. As a verb; slang for viciously assaulting someone. Often used as a compliment in both cases.</li>
					<li><b>Shitcurity</b>: Slang for describing a security officer who unnecessarily or illegally exercises their authority in order to inflate their ego, or a security officer who simply doesn't follow standard operating procedure.</li>
					<li><b>Use of Force</b>: Either lethal or non-lethal, this is the use of weapons to incapacitate a suspect. You may be told at times to use lethal force, or non-lethal force, depending on circumstance. By default, non-lethal force is preferred.</li>
					<ul><li><b>Shoot-to-Stun</b>: Using non-lethals to incapacitate the target in order to handcuff or otherwise subdue them without injury. Although the term is ''shoot''-to-stun, stun batons, pepper spray, and flashers all fall under this category when talking about engagements with suspects.</li>
						<li><b>Shoot-to-Kill</b>: Using lethal weapons to engage a target until a threat is neutralized. This doesn't actually mean you ''have'' to kill the target (contrary to the term), but the weapons employed may very well kill the target whether you want to or not. Even in Shoot-to-Kill scenarios, you should still attempt to provide immediate medical attention and revive them once they are otherwise safely subdued and the combat is over.</li>
						<li><b>Shoot-to-Disable</b>: To incapacitate a target, usually a vehicle (such as mechs) or machine (such as cyborgs), by damaging it to the point of interoperability.</li><BR>
					</ul>
				</ul>
				<hr>
				<h2>Rules of Engagement</h2>
				<ul>
					<li>When confronting a suspect for any level 1 crime, you must offer the suspect a chance to pay a fine. If the fine is paid, they are not to be arrested, detained, or searched unless otherwise specified by Corporate Regulations. The fine is to be turned in to the Head of Security, Head of Personnel, or Colony Director. If the fine is refused, they are to be arrested.</li>
					<li>Calling for backup over a level 1 crime is usually considered a waste of resources. One officer should be enough.</li>
					<li>When arresting or fining a suspect, they are to be informed of their right to pay a fine (if applicable) and their right to an Internal Affairs Agent (IAA) to represent them in an appeal to the HoS or Colony Director if they so desire. If there is no IAA available, they may still attempt to appeal on their own, but should still be punished until the punishment expires or the appeal passes. (See <i>Appeals</i> for details.)</li>
					<li>Refusal of handcuffs does not constitute resisting arrest, as per Corporate Regulations c.202. If a suspect refuses handcuffs and is being arrested, but is cooperative, they are to be escorted by no less than two armed security personnel to the brig. If this is not possible, inform the suspect, and handcuff them regardless of their cooperation.</li>
					<li>A suspect attempting to flee, or assault another crew member, is authorized shoot-to-stun.</li>
					<li>When confronting an armed suspect, always call for backup, preferably prior to the engagement. If the suspect draws a weapon, already has a weapon in their hands, or has used a weapon already, use of force is immediately authorized and you are not required to announce intentions to arrest until after they are subdued.</li>
					<li>If a suspect uses a mech to resist arrest, shoot-to-kill authorized. Deployment of barricades and use of flipped tables for cover is also advised to create chokepoints where security can fire upon the target.</li>
					<li>If a suspect is green, screaming, and able to punch down walls, they're probably affected by the hulk gene from genetic manipulation, and if they exist without an ongoing emergency where such muscle is needed or the CMO did not directly inform Security in advance, a 'hulk' outside of medbay or research is shoot-to-kill. Unlike most shoot-to-kill scenarios where the actual killing part is a matter of option and circumstance, there is no way to safely contain a hulk in prison, so if you are forced to confront one, continue engagement until the target is deceased.</li>
					<li>If a suspect escapes into space, shoot-to-kill is authorized for any personnel who go out into space to pursue. L.W.A.P. sniper rifles and GPS are recommended for the pursuit, as are jetpacks. Additionally, someone should be viewing cameras to watch station access points and various outposts on the asteroid and near the orbital construction site.</li>
					<li>During Code Delta, any noncompliance from staff is to be met with lethal force.</li>
					<li>For secure areas, see below for specific rules of engagement.</li><BR>
				</ul>
				<hr>
				<h2>Secure areas</h2>
				<ul>
					<li>In code green, secure areas like the armory, vault, gateway, armory, AI core, research server room, telecommunications satellite, etc, should never be blocked. Only the vault should be bolted. Use of deployable barriers to block areas during code green is considered illegal under Corporate Regulations c.217. Trespassing in these areas is covered under c.207.</li>
					<li>The armory is restricted to security and the Colony Director only. Non-security staff are not authorized without permission from the Head of Security or Colony Director. Unauthorized personnel in this area are shoot to kill '''excluding''' the Head of Personnel who should just be ordered to leave immediately. The Head of Personnel may have an urgent reason for wanting to break protocol. If they do not, proceed with an arrest.</li>
					<li>The engine is restricted to engineers and the Colony Director. No other staff are permitted in the engine, and anyone found in these areas should be subdued through applicable use of force, up to and including deadly. However, be conscious of the context of their break-in. If the station has been suffering a power failure because the engine was never started, their intentions might be less malicious than someone breaking into an engine that is working perfectly fine.</li>
					<li>The vault contains valuable items within it, so Security is usually stationed close by. If sparking is heard, the security staff at this post should alert other security personnel for backup, and investigate while backup arrives. Should an individual be discovered in the vault other than the Colony Director, use of force is authorized.</li>
					<li>The AI sometimes likes to bolt itself in even during code green. It is not supposed to do this. If the AI bolts its self in, request the AI to unbolt the doors, citing Standard Operating Procedure. If the AI does not comply, ask the Research Director or Colony Director to try reasoning with it. If it still does not comply, it is up to the staff in charge of overseeing the AI how to proceed, usually by changing laws. Unauthorized personnel discovered attempting to breach the AI core are shoot to kill.</li>
					<li>The Gateway is often able to access dangerous far away worlds and alternate realities and even different points in time. Be careful to keep track of any ongoing gateway missions, but if someone is discovered actively breaking into this location, and you are 100% certain they are not supposed to be there, confirm with your superiors, and if they are indeed unauthorized, they are to be captured, searched, and interrogated before being charged and sentenced.</li>
					<li>The Research Server Room has a variety of sensitive information. Unauthorized personnel in this location are to be captured, searched, and interrogated before being charged and sentenced.</li>
					<li>The Brig is considered a high security area. Unauthorized personnel attempting to break in, or any "Hold until Transfer" inmates attempting to break out, are both shoot to kill.</li>
					<li>The Telecomms Satellite is a highly sensitive area that provides vital communications among the crew and to CentCom, thus any unauthorized personnel who have evaded or destroyed the laser turrets and accessed the control room are shoot-to-kill.</li>
					<li>Just because borgs can access everywhere in the station doesn't mean they should be there. Borgs will usually obey orders to leave secure areas, and you can usually ask who gave them the order to go there in the first place. If the borg has a valid reason for being there, such as a mediborg rescuing brig inmates who were injured in a fight, then you should leave it alone, or at worst you should accompany the borg to aid its duties. If the borg does not have a valid reason, and it refuses to leave, incapacitate it by <b>any</b> means and alert Robotics about the incident right away.</li><BR>

					<i>((It's also possible in many cases that a player in these areas might be breaking server rules. Make sure you ahelp when you see it happening, preferably <u>before</u> you try to handle it yourself. Not to say you have to <i>wait</i> for an admin and let the possible griefer do whatever they want. Just that by ahelping, you hopefully get an admin to arrive and investigate what happened, and whether or not any rules actually got broken.))</i><BR><BR>
				</ul>
				<hr>
				<h2>Criminal Processing</h2>

				See Corporate Regulations for rules that carry fines or brig time.<BR><BR>

				See also Legal Standard Operating Procedure for information regarding tribunals.<BR><BR>

				Breaking standard operating procedure is not punishable by law, but if an accident or fatality occurs for violating it, see Corporate Regulations c.206.<BR><BR>

				Criminal processing should not take more than a few minutes at most. Don't needlessly waste time with additional questioning and interrogation until they're already properly arrested.<BR><BR>

				Upon arrest of a criminal, follow the following steps:<BR><BR>
				<ol>
					<li> State the main reason for their arrest, even if you have already. This is not required, but it's good practice.</li>
					<li> Bring the suspect to Security Processing. If paying a fine will replace jail time, offer them the chance to pay the fine before proceeding. This is assuming they have not paid the fine already and had to be handcuffed in the first place. If the fine is paid, skip to the final step. Otherwise, continue.
					<li> Read Corporate Regulations out loud for every valid charge, and update their security record accordingly.</li>
					<li> After you have read the charges you should state the following word-for-word: </li>
					<ul><b>"According to NanoTrasen Criminal Processing Policy, you are entitled to appeal your case to an Internal Affairs Agent at this time, if such is available. Should you accept this offer, be advised your criminal processing may be delayed until your agent is satisfied with the case. If they rule in favor, they will contact the Head of Security on your behalf. If accepted, you will be released or your sentence will be reduced. If at any time, the Internal Affairs agent, the Head of Security, or the Colony Director rejects your appeal, your sentence will be unaffected."</b></li>
					</ul>
					<li> If they either do not want to bother with an appeal, or their appeal is not sufficient enough to be alleviated of all charges, proceed to next step. If their appeal is sufficient for immediate release, proceed to final step. Otherwise, continue.</li>
					<li> Search the individual for contraband and question them as necessary. Empty pockets, remove accessories such as webbing off their uniform, check their PDA for stolen/illegal cartridges, check their headset for illegal/stolen encryption cards, check their shoes for knives, check anything and everything that could contain items. If contraband or stolen property is found, charge them accordingly. See Corporate Regulations for details. Anything else <i>not</i> considered contraband but still may compromise the security of the cell (such as a chef's kitchen knife, or an engineer's tools) should also be temporarily confiscated and returned after the sentence is served.</li>
					<li> Calculate sentencing based on the total charges. <b>Do not</b> charge more than the minimum sentence unless it this is not their first offense. Multiple instances of the same offense counts in this case. For example, if a suspect stole three items, you cannot charge them theft three times, but you <i>can</i> charge the maximum sentence for theft. If they have already been arrested for the same crime during that shift, follow Corporate Regulations regarding Modifiers & Special Situations.</li>
					<li>Update the prisoner's security records accordingly. Set their status to "Imprisoned".</li>
					<li>Return the prisoner's PDA and headset to their person. If you cannot provide them with their original headset and PDA for suspected security reasons, you must provide at least a basic headset and a temporary PDA. All prisoners are entitled to some kind of communication device unless the privilege is abused, or the device is evidence for a crime (such as a PDA with incriminating logs).</li>
					<li>Inform their head of staff of their arrest. You have no authority to demote anyone unless you're the Head of Security who is demoting another security officer.</li>
					<li>Escort the prisoner to their cell, preferably with one security guard to aid you. Bring any of their belongings that you did not confiscate.</li>
					<li>Find a vacant cell and buckle the prisoner to the bed. If the sentence is longer than 10 minutes, they are required to wear an orange jumpsuit and shoes, so change their clothes if needed.</li>
					<li>Put all of their belongings (besides communication) that are not evidence for a crime into the cell's locker, which will lock automatically when you start the timer.</li>
					<li>Set and start the timer. The door will close and the locker will be locked.</li>
					<li>Enter the cell with stun baton at the ready and remove the prisoner's handcuffs. If possible, have a second security officer present to help. It is unlawful to leave a prisoner restrained in a cell unless in solitary confinement.</li>
					<li>Ensure someone is monitoring the prison area for the duration of the prisoner's sentence, or at least be there when it ends.</li>
					<li>Wait for the sentence to expire. Proceed to final step once it has expired.</li>
					<li>Return all temporarily confiscated goods.</li>
					<li>Allow the prisoner to leave Security. Set the prisoner's status to "released" or "parolled" depending on their conviction or lack thereof.</li><BR>
				</ol>
				<hr>
				<h2>Prisoner Expectations</h2>

				As a prisoner, you are expected to abide by certain standards. Failure to obey will result in further punishment such as solitary confinement or more brig time.<BR><BR>
				<ul>
					<li>If you are incarcerated, do not attempt escape.</li>
					<li>Irritating officers for amusement is a generally poor idea. Refrain from repeatedly banging upon windows.</li>
					<li>Attempts at suicide will be met with solitary confinement. ((Also probably a server ban.))</li>
					<li>If you feel you have been unjustly incarcerated, contact the Warden, the Head of Security, Internal Affairs, or Colony Director (in that order of first to last) to appeal your case.</li><BR>
				</ul>
				<hr>
				<h2>Prisoner Rights</h2>

				As a prisoner, you are entitled to certain rights under any circumstance, regardless of the nature of your crimes.<BR><BR>
				<ul>
					<li>All prisoners are entitled to a swift processing when being arrested and put into the brig. Longer than 1/4th of their sentence is considered a violation of this right so long as the prisoner is cooperating.</li>
					<li>All prisoners are entitled to medical examination and aid if requested.</li>
					<li>All prisoners are entitled to speak to an <<Internal Affairs Agent>> for legal council if requested.</li>
					<li>All prisoners are entitled to be allowed to send fax to Central Command if requested.</li>
					<li>All prisoners are entitled to food and water if requested.</li>
					<li>All prisoners are entitled to be provided with clothing--preferably the standard orange prisoner jumpsuit and orange shoes.</li>
					<li>All prisoners are entitled to safe and reasonable cell accommodations such as functional lighting, a place to sleep, and access to the brig's communal area if serving a sentence longer than 20 minutes.</li><BR>
				</ul>
				<hr>
				<h2>Standard Security Gear</h2>

				Aside from what the normal crew is allowed, this is what security should be carrying under code green.<BR><BR>
				<ul>
					<li><b>Security Cadet/Security Conscript</b></li>
					Security cadets are just assistants who wish to pursue a career in security. Security personnel should take these individuals under their wing to educate them on Standard Operating Procedure, Corporate Regulations, and other tips on how to do their job effectively and fairly. Security conscripts on the other hand can be recruited by the Head of Security during an emergency, and will have their ID temporarily changed by the Head of Personnel. Both of these are allowed only the same standard equipment with some exceptions listed below, but can be equipped to handle a variety of problems that normal security is too preoccupied to handle.
					<ul><li>Holotag to denote their active service. They must have at least a holotag, else they are not granted any other security equipment.</li>
						<li>Red armband, if they are not issued a security uniform.</li>
						<li>Whatever equipment is deemed necessary by the HoS depending on circumstance.</li>
						<li><b>No weapons are allowed for security cadets outside of code red or worse.</b></li><BR>
					</ul>
					<li><b>Security Officer</b></li>
					The gear available to security officers is available to all security personnel under normal circumstances. Weapons of <b>all</b> kind should be kept holstered and preferably concealed during code green. Brandishing weapons openly tends to make the crew needlessly nervous and hostile toward security personnel.
					<ul><li>Security uniform or appropriate variant of security uniform. Red jumpsuits are acceptable substitutes.</li>
						<li>Security softcap (Optional)</li>
						<li>Standard Security helmet, kept in backpack unless responding to a call.</li>
						<li>Standard Security armored vest</li>
						<li>Standard Security HUD glasses or equivalent</li>
						<li>R.O.B.U.S.T. PDA cartridge</li>
						<li>Security belt</li>
						<li>Security caution tape</li>
						<li>Flasher</li>
						<li>Pepper spray</li>
						<li>Stun baton</li>
						<li><b>One</b> Taser</li>
						<ul><li> A stun revolver can be substituted for a taser without any special permissions.</li></ul>
						<li>Maximum 2 reloads (<i>cell, magazine, etc.</i>) for selected sidearm</li>
						<li>Flashbang</li>
						<li>Hailer</li>
						<li>Minimum 1 pair of handcuffs</li>
						<li>Universal recorder (Optional)</li>
						<li>Basic First Aid supplies (Optional)</li>
						<li>Emergency light source (flare or flashlight)</li><BR>
					With explicitly written permission from the Head of Security or Colony Director, <i>any</i> firearm may be carried during code green by <i>any</i> personnel carrying a valid permit. However, it is strongly recommended to never issue permits for automatic or high powered weapons. The most common (and most reasonable) permit distributed is usually for a common energy gun.<BR><BR>
					</ul>
					<li><b>Detective</b></li>
					Although the detective's task is not to make arrests, they should be prepared in case the situation arises where they must defend themselves or arrest someone who is discovered at the end of an investigation over a serious crime. In addition to the standard Security Officer gear, there are some differences and additions. If two detectives are present, this gear should be shared between them.<BR><BR>
					<ul><li>Detective attire in place of Security uniform.</li>
					<li>Standard Security armored vest (optional)</li>
					<li>Forensic Scanner</li>
					<li>Black or latex gloves</li>
					<li>Evidence bags</li>
					<li>Universal recorder</li>
					<li>Camera</li>
					<li>.45 caliber or 9mm automatic handgun with less-than-lethal rounds.</ul></li><BR>
					<li><b>Warden</b></li>
					Half of your job is to look after the prisoners; make sure they aren't abused or given unfair sentences and that they don't escape. The other half of your job is to arm security with weapons in emergencies. You are not a Security Officer and should not leave the brig if possible. <BR><BR>

					However, you may operate as an officer shall the need arise, under the permission of your HoS. If you have no prisoners to watch out for, you can be helpful to your team by coordinating with officers over your radio channel, checking cameras when people call for help, and updating arrest records. You can also do roll call every so often, to make sure that the officers are still alive and well. You have the opportunity to make Security run like a well-oiled machine, but don't start acting like your boss. Also make sure you keep track of what's in the armory.<BR><BR>

					You start with a list of everything in the armory and should keep track of who and what is being taken and their reason why. Moreover, make sure the armory stock is well-balanced. Sometimes, the people at Central forget to stock a certain type of weaponry, whether lethal or non-lethal; and it is your job to make sure the situation is remedied before it's too late. Sitting at your desk is alright, but you should make sure to scan the cell blocks every once in a while to make sure no one is hurt in the cells, or there are any areas of break in. Your job is to protect all of security from people busting in, or out. A quick sweep every few minutes should be fine, being a warden is a mostly relaxing job, just make sure to stun anyone who is behaving suspiciously in security and hold them till the Head of Security comes. Remember, talk first, disarm second, kill if that's your only option (it never is).

					If you are going to sit around, it may be worthwhile to update the security records for your prisoners. Seriously. Update the security records. Just because you have access to lethal weapons and armor does NOT mean you are allowed to use them or carry them around with you as you please, you like every other person aboard are required to follow Standard Operating Procedure. You may patrol the brig with non-lethals.<BR><BR>
					<ul><li>Warden attire in place of Security uniform/Warden armored jacket (standard security armored vest is an acceptable substitute)</li>
						<li>Box of handcuffs</li>
						<li>A Stun Baton</li>
						<li>Pepper Spray</li>
						<li>Flashbangs (On Code Blue or during an emergency scenario)</li>
						<li>Lethal weapons (Only on Code Red, POSSIBLY on code yellow with permission of the HOS, and Code Delta.)</li><BR>
					</ul>
					<li><b>Head of Security</b></li>
					When it comes to weapons, the Head of Security has, surprisingly, the least flexibility of all station staff, their main job is to manage security and not to be going around chasing criminals or handling investigations if they don't have to, you're job is to sit in your comfy chair and give orders to your subordinates unless there is not someone to fill a particular spot and to solve high-level legal disputes. When there are normal officers to do the main legwork you are to either be in the bridge or security. Notable exceptions are scenarios in which heads of staff are threatened.<BR><BR>

					The Head of Security also has the power to deputize people during a crisis, and so, may have a valid reason to carry multiple weapons at one time in specific scenarios. You are expected to follow standard operating procedure just as anyone else is, especially when it comes to weapons and armor.<BR><BR>
					<ul><li>Head of Security attire in place of a Security uniform.</li>
						<li>Head of Security armored coat and hat. This is the only exception to the HOS and armor usage, as it may be worn at any time.</li>
						<li>Outside of the security wing, one or more lethal weapons, such as an energy pistol, or any non-explosive weapon, so long as it fits into a backpack. At least one lethal weapon is recommended.</li>
						<li><i>At least</i> one ranged weapon for non-lethal engagement, such as a taser, or stun revolver, should also be carried at all times. Weapons with toggle-able fire modes between stun and kill (such as an energy pistol) are considered lethal weapons and should be considered as explained above.</li><BR>
					</ul>
					<li><b>Head of Personnel</b></li>
					The Head of Personnel is <b>not</b> a member of Security and should <b>never</b> be carrying any weapons aside from the energy pistol, baton, and flash supplied to them for self defense. Permits by the Head of Security or Colony Director may override this, but otherwise, they are in direct violation of Corporate Regulations c.212, and should be charged accordingly.<BR><BR>

					If a violation is made, Security should also check if the HoP has illegal access on their ID, because that is most likely how they obtained the weapon. Just because they <i>can</i> give themselves all-access doesn't mean they are <i>allowed</i> to outside of an emergency.<BR><BR>

					As an Acting Director, the Head of Personnel <i>may</i> legally carry a wider variety of firearms, but this is heavily discouraged.<BR><BR>

					<li><b>Colony Director</b></li>
					Because the Colony Director is in charge of the station, it is recommended that the Colony Director carry <i>some</i> kind of weapon at all times. The Colony Director is an obvious target for hostile elements, and should not be helpless in a fight. Different colony directors have different preferences depending on their background. Some Colony Directors enjoy the symbolism of a sword, while others prefer the practicality of a firearm, but in any case, the policy and regulations are the same.<BR><BR>

					<ul><li>No more than <b>one</b> non-explosive lethal weapon is permitted for self-defense. However, possession of <i>additional</i> weapons (excluding standard issue energy pistol or equivalent) is considered a violation of Corporate Regulations c.212.</li>
					<li>A collapsible baton or stun baton are also both fine, but it is recommended that the Colony Director pick only one of these to carry.</li>
					<li>Any body armor is permitted for the Colony Director to wear Outside of Code Green. However, wearing cumbersome body armor is not recommended, as the Colony Director's objective should not be to engage in extended fights, but rather, to escape them.</li><BR>
					</ul>
				</ul>
				<hr>
				<h2>Executions</h2>
				<ul>
					<li>Prisoner is informed of their punishment, and allowed to decide how they die (within reason). Suggested options include lethal injection, firing squad,  phoron gassing, or being exiled through the Bluespace Gateway and given an exile implant so they cannot return.</li>
					<li>Prisoner is to be granted a final request (within reason, because obviously "let me go" or "kill this dude for me" isn't reasonable).</li>
					<li>Prisoner is given their last meal.</li>
					<li>Prisoner is escorted to the execution location under heavily armed guards, bound in a straight jacket and leg cuffs. Escorting officers are armed to kill. Lethal injections are done in medbay surgery room under supervision of doctor, firing squad is done on the shooting range, gassing is done in toxins or a room is built by engineering, etc.</li>
					<li>It is required for the Colony Director to be present (<b>not an acting Colony Director</b>), or an execution may not proceed.</li>
					<li>For an individual to be executed without planetside cloning (and thus, stay dead, unless they have privately owned cloning equipment), Central Command must make their own judgements. This is extremely rare and usually only occurs in cases of terrorism. Central Command must be faxed prior to the execution. If Central chooses to commute it to another sentence, exonerate it entirely, or even pardon it, on-station security must comply immediately.</li><BR>
				</ul>
				<hr>
				<h2>Crew Restrictions: Special Concerns</h2>

				Due to concerns regarding the physical demands expected of Security, including but not limited to resilience and physical strength, Central Command has determined that any NanoTrasen employee under <u>2'6"/76.2cm</u> may not be employed on any NanoTrasen facility Security team. Transfer to the Security department after the assignment of another Departmental role is equally unlawful. This ruling may be appealed in the future.<BR><BR>
					<ul><li>This policy has the following exceptions: NanoTrasen employees may be employed by the Security department if fulfilling the role of <u>Detective/Forensic Technician</u>. All other provisions apply.</li><BR>
					</ul>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the Standard Operating Procedure at the time of its publication. Standing policy is that the most recent amendments to Standard Operating Procedure are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/sop_vol5_6
	name = "SOP Volume 5.6: Department Regulations (Command)"
	icon_state = "sop_se_vol5"
	author = "NanoTrasen"
	title = "SOP Volume 5.6: Department Regulations (Command)"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Volume Five: Department Regulations (Command)</h1>
				<hr>
				<h2>Vacancy in the chain of command</h2>

				In the event of any command role (excluding Colony Director) being unoccupied, it is advised (though not required) that the current Colony Director promote someone within the department to be head of staff.<BR><BR>

				In the event that the Colony Director is absent, please refer to the the Chain of Command guide book for more detailed instructions.<BR><BR>
				<hr>
				<h2>Promotion and Demotion</h2>

				Heads of staff are in charge of promotions and demotions within their respective departments, and both the Head of Personnel and Colony Director are expected to honor these requests unless under outstanding circumstances.<BR><BR>

				Although some parts of Corporate Regulations list demotion and dismissal as a possible punishment, under <b>no circumstance</b> should the Head of Personnel honor a request to demote non-Security by the demand of the Head of Security alone. However, the severity of the infraction should be considered, and if necessary, the Colony Director or Acting Colony Director may enforce a demotion if the head of staff for the offending party's department refuses to do so.<BR><BR>

				The Colony Director (and any Acting Colony Director) may promote or demote anyone for any reason (excluding nepotism or discrimination) up to and including replacing their own rank. No permission is required from any heads of staff for any changes of rank, but it is still considered courteous to ask.<BR><BR>

				The Head of Personnel cannot promote or demote other heads of staff, but may promote or demote any other staff with the permission or at the request of their relevant head(s) of staff. They may also promote any staff up to and including replacing their own rank, with a limit of no more than two Heads of Personnel at any time, provided that one of their roles be titled "Assistant Head of Personnel". The Head of Personnel may demote or promote an Assistant Head of Personnel (thus switching places with them), but an Assistant Head of Personnel cannot demote or promote the main Head of Personnel. The Head of Personnel may not promote themselves or anyone else to Colony Director without a head of staff vote or by Central Command's authorization, but they may promote themselves to Acting Colony Director in the event that it is considered necessary by the Chain of Command.<BR><BR>

				All staff may ask to be demoted down to and including resignation at any time, for any reason. Note that if you resign, Security may not charge staff with <i>Failure to Execute an Order</i> (Corporate Regulations c.111>>), and if you are already being charged, that charge is to be dropped upon announcement of your resignation. If you are in the brig at the time of your resignation, the time added to your sentence by your violation of c.111 is to be revoked. However, if your resignation <b>directly</b> results in serious damage, injury, or fatalities, you are still liable for the violation of <i>Failure to Execute an Order with Serious Consequences</i> (Corporate Regulations c.201) regardless of your resignation. For example, an Engineer resigning after being told to set up the engine is not liable, even if the power goes out. However, if the engine explodes as a direct result of their failure to follow orders, they may be charged accordingly.<BR><BR>
				<hr>
				<h2>Refusal to change rank</h2>

				All staff may refuse a promotion except under the circumstance that your current role is required by the Chain of Command to assume the role of Acting Colony Director. If a staff member does not wish to be the Acting Colony Director, they may use their position as Acting Colony Director to promote a willing replacement candidate to Acting Colony Director.<BR><BR>

				If a staff member is demoted by the appropriate superior, they are to be informed directly (in person or via PDA). Within no more than 10 minutes, the demoted individual must either report to the Head of Personnel to surrender their ID's access, or must surrender their ID to Security, or must surrender their ID to their own head of staff. If the staff member being demoted openly refuses to cooperate, or is unresponsive to news of their demotion after 10 minutes, Security may be dispatched at request of the demoted individual's current/former head of staff to locate the individual and confiscate their ID. If the individual continues to resist confiscation, they may be charged with <i>Exceeding Official Powers</i> (Corporate Regulations c.214).<BR><BR>

				If a demotion has been performed for reasons believed to be unjustified, the demoted individual should cooperate with the demotion, but immediately file a complaint to the next highest person in the chain of command. For example, if your own head of staff demoted you, complain to the Colony Director. If the Colony Director demoted you, or rejects your complaint, complain to Central Command. If you are still rejected, the decision is final.<BR><BR>
				<hr>
				<h2>Unique roles</h2>

				In the event that it is deemed necessary, a head of staff may request to alter a subordinate's role to anything within their department, with any title they desire, so long as it does not cause any obvious confusion. Furthermore, multiple heads of staff may cooperate to create hybrid roles that have access to multiple departments.<BR><BR>

				Please note that for the purposes of this particular section, a Quartermaster is considered a head of staff, and should be consulted prior to the creation of any unique or hybrid roles in the fields of cargo or mining operations.<BR><BR>

				Hybrid roles should not be used to replace duties that are already covered by other staff. For example, a scientist should not be given mining access when there's perfectly good miners already present. Hybrid roles are meant to make current duties easier to fulfill, such as a Security Officer being given access to engineering because they are assigned to the security detail for a construction site.<BR><BR>
				<hr>
				<h2>Crew Restrictions: Special Concerns</h2>
				Due to concerns regarding the hazardous nature of Command duties and the volatile nature of Vox biology, Central Command has determined that the following race – Vox – may not be employed on any NanoTrasen facility Command team, barring the following provisions: Vox may be employed as Chief Engineer, Chief Medical Officer, or Research Director. Prohibited Vox Command positions follow: Colony Director, Head of Security, or Head of Personnel. Transfer to the proscribed Command departments after the assignment of another Departmental role is equally unlawful. This ruling may be appealed in the future.<BR><BR>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the Standard Operating Procedure at the time of its publication. Standing policy is that the most recent amendments to Standard Operating Procedure are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/sop_vol5_7
	name = "SOP Volume 5.7: Department Regulations (Internal Affairs)"
	icon_state = "sop_se_vol5"
	author = "NanoTrasen"
	title = "SOP Volume 5.7: Department Regulations (Internal Affairs)"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Volume Five: Department Regulations (Internal Affairs)</h1>
				<hr>
				<h2>Impartiality Clause</h2>

				An Internal Affairs Agent is not to serve the interests of any group or individual, including their own superiors up to and including NanoTrasen at the corporate level. Their only loyalty is to the rules as they are written, and to the party that follows them. Their job is only to ensure that those rules are being obeyed, and that if they are not, they make it known to those who can enact changes.<BR><BR>

				An Internal Affairs Agent is not a lawyer, though many may come from a background in practicing law. They will only defend and protect a party who is following the rules of the company, and any laws that the company is supposed to follow.<BR><BR>

				Any faults in those rules such as inconsistencies or oversights should be brought to the attention of NanoTrasen.<BR><BR>

				An Internal Affairs Agent should never make assumptions of anyone's intentions, nor include speculation of intentions in any given report. The Internal Affairs Agent is to summarize the facts and <i>only</i> the facts in their report.<BR><BR>
				<hr>
				<h2>Employee Comments and Concerns</h2>

				If an employee wishes to address a matter with Internal Affairs, they must go to an Internal Affairs Office at their assigned station or facility. They should contact an Internal Affairs Agent in advance to let them know that they are coming.<BR><BR>

				If an Internal Affairs Agent is not presently available on the station, your facility should have a fax machine available somewhere in public for you to contact Central Command directly. For general comments and positive feedback, Central Command will make note of your report and forward it to the relevant parties. For complaints and negative feedback, Central Command will usually send an Internal Affairs Agent to the station regardless of whether or not you have included these complaints in your fax. The Internal Affairs Agent will conduct an investigation for which the objective is merely to gather the facts.<BR><BR>
				<hr>
				<h2>Prisoner Comments and Concerns</h2>

				Prisoner comments and concerns will be handled in the same way as employee comments and concerns except in that a prisoner cannot come to the Internal Affairs Office. Instead, Security must arrange for the Internal Affairs Agent to meet with the prisoner in safety, but privacy.<BR><BR>

				All NanoTrasen holding facilities are equipped with at least one visitor booth wherein an Internal Affairs Agent and a prisoner may meet face-to-face without having to be in direct physical contact. If such a facility is not available, and the Internal Affairs Agent does not feel comfortable conducting the interview elsewhere, the condition of safety has not been met. If a third party not participant in the interview is able to listen in, then the condition of privacy has not been met. Note that there is no reason for Security to require that a guard be kept directly in the room, as the prisoner's visitation facility already ensures safety of the Internal Affairs Agent.<BR><BR>

				If safety or privacy cannot <b>both</b> be reasonably accommodated, the interview cannot proceed, and the reason why should be noted in your report.<BR><BR>

				As a final note, bear in mind that an Internal Affairs Agent is at no point required to <i>help</i> a prisoner. Their only job is to decide whether or not the company rules were followed. If no wrongdoing occurred, the Internal Affairs Agent can decide not to bother filing a report, and may decide not to hear grievances from that prisoner in future.<BR><BR>
				<hr>
				<h2>Violations of Employee Rights</h2>

				If the Corporate Labor Charter rights of employees are being violated, Internal Affairs <b>must</b> make note of these violations regardless of whether or not the victims of such violations are even aware of their rights. A report to Central Command <b>must</b> be made, and the parties (such as command staff) who are violating these rights should be made aware of their violations.<BR><BR>

				If corrective action is not taken by the staff, Central Command should be alerted to this failure immediately.<BR><BR>
				<ul>
					<li><b>Harassment</b></li>

					<ul>Harassment is unwelcome conduct that is based on species, race, color, religion, sex (including pregnancy), national origin, age, disability, or genetic information. Harassment is against NanoTrasen's corporate policies, and it is therefore Central Command's obligation to address and investigate any harrassment report.<BR><BR>

					Harassment is against Corporate Regulations already, but becomes <b>unlawful</b> to Central Command when enduring the offensive conduct becomes a condition of continued employment, and the conduct is severe or pervasive enough to create a work environment that a reasonable person would consider intimidating, hostile, or abusive. Anti-discrimination laws also prohibit harassment against individuals in retaliation for filing a discrimination charge, testifying, or participating in any way in an investigation, proceeding, or lawsuit under these laws; or opposing employment practices that they reasonably believe discriminate against individuals, in violation of these laws.<BR><BR>

					Petty slights, annoyances, and isolated incidents (unless extremely serious) will not rise to the level of illegality, but may still violate company policy.<BR><BR>

					Offensive conduct may include, but is not limited to, offensive jokes, slurs, epithets or name calling, physical assaults or threats, intimidation, ridicule or mockery, insults or put-downs, offensive objects or pictures, and interference with work performance. Harassment can occur in a variety of circumstances, including, but not limited to, the following:<BR><BR>
						<ul><li>The harasser can be the victim's supervisor, a supervisor in another area, an agent of the employer, a co-worker,or a non-employee.</li>
							<li>The victim does not have to be the person harassed, but can be anyone affected by the offensive conduct.</li>
							<li>Unlawful harassment may occur without economic injury to, or discharge of, the victim.</ul></li><BR>
						</ul>
					Prevention is the best tool to eliminate harassment in the workplace. NanoTrasen encourages all employees to take appropriate steps to prevent and correct harassment. Employees should feel free to raise concerns and be confident that those concerns will be addressed.<BR><BR>

					Employees are encouraged to inform the harasser directly that the conduct is unwelcome and must stop. Employees should also report harassment to Internal Affairs at an early stage to prevent its escalation. Remember that Internal Affairs is not hired to protect the company, and that if someone within the company is complicit in harassment, it is in the long-term benefit of NanoTrasen to take corrective measures up to and including termination of the harasser.</ul><BR>
				</ul>
				<hr>
				<h2>Violations of Standard Operating Procedure</h2>

				If Standard Operating Procedure is being ignored by an individual or group of individuals, it should be brought to the attention of that party's superior. For example, if there are medical staff are not compliant with the NanoTrasen Dress Code, then the Chief Medical Officer should be informed.<BR><BR>

				If a head of staff is involved with the violation, or fails to take corrective action against subordinates, the Colony Director should be alerted to the infraction, noting that the relevant head of staff had already been contacted.<BR><BR>

				If the Colony Director is involved with the violation, or fails to take corrective action against subordinates, Central Command should be informed when possible, noting any previous efforts to bring the problem to the attention of command staff already present.<BR><BR>

				Note that there may be extenuating circumstances in which Standard Operating Procedure is ignored. An Internal Affairs agent should still make note of such an incident, but they should also provide full context as to <i>why</i> Standard Operating Procedure was not followed, whether deliberately or not. The reason for this is that Standard Operating Procedure may be updated to lend guidance on future incidents if NanoTrasen deems it worthwhile to do so.<BR><BR>

				An Internal Affairs Agent may personally recommend additions, edits, and removals to Standard Operating Procedure based on the findings of their investigation.<BR><BR>
				<hr>
				<h2>Violations of Corporate Regulation</h2>

				If Corporate Regulations are being ignored by an individual or group of individuals, it should be brought to the attention of Security.<BR><BR>

				If Security is involved with the violation, or fails to take corrective action against offending parties for at least a medium infraction or worse, the Head of Security should be alerted to the infraction, noting the failure of their subordinates.<BR><BR>

				If the Head of Security is involved with the violation, or fails to take corrective action against offending parties for at least a medium infraction or worse, the Colony Director should be alerted to the infraction, noting the failure of their subordinates.<BR><BR>

				If the Colony Director is involved with the violation, or fails to take corrective action against offending parties for at least a high infraction or worse, Central Command should be alerted immediately.<BR><BR>

				Note that there may be extenuating circumstances in which Corporate Regulation is ignored, and note that the Colony Director is allowed to issue pardons. If a pardon is issued, an Internal Affairs agent should still report the incident to CentCom, but the urgency of doing so is greatly reduced. Any pardons issued should be mentioned in the report, as well as why they were issued.<BR><BR>

				The reason for this is that Corporate Regulations may be updated to account for future incidents if NanoTrasen deems it worthwhile to do so.<BR><BR>

				An Internal Affairs Agent may personally recommend additions, edits, and removals to Corporate Regulations based on the findings of their investigation.<BR><BR>
				<hr>
				<h2>Altering Company Policy, Regulation, and Procedure</h2>

				As mentioned previously, an Internal Affairs Agent is able to suggest changes to documents found on the company wiki, and these changes will be reflected in any physical documents that are distributed to employees.<BR><BR>

				Changes should be made in the event that a contradiction, error, or oversight is discovered among Standard Operating Procedure and Corporate Regulations. These two documents are often updated independently of each other, and sometimes references between these documents do not align as they should. References might be missing, topics may refer to defunct policies, a frequent issue is not accounted for, etc.<BR><BR>

				Bring these problems to the attention of Central Command, and offer your suggestions as to how the wording of these documents can be improved.<BR><BR>

				Note that suggested changes should <b>not</b> be based on one specific post; they should account for stations and facilities all across NanoTrasen's corporate network. Site-specific rules may be employed for a particular location based on the needs and circumstances of that location. Internal Affairs Agents should ask and make note of any such rules that may contradict or add to these otherwise company-wide procedures.<BR><BR>

				For one extreme example, the NSB Adephagia is equipped with state of the art experimental cloning facilities, and so the edition of Corporate Regulations issued to them is written with more lenient punishments for crew fatalities. Be aware of site-specific changes to the company's usual rules.<BR><BR>
				<hr>
				<h2>Applying for Permits</h2>

				Any permits that the crew wishes to apply for can be done through an Internal Affairs Agent, who will guide you through the application process, and then forward the application to the department responsible for processing that application.<BR><BR>
				<ul>
					<li><b>Weapon Permits</b></li>
					<ul>There are two kinds of weapon permits. Temporary permits are issued at the discretion of the Head of Security, and are good for up to one shift. Long-term permits are issued by NanoTrasen, and require both fingerprinting and a background check.</ul><BR>
					<li><b>Medical Prescriptions</b></li>
					<ul>The Chief Medical Officer is in charge of medical prescriptions. Internal Affairs is not a medically qualified entity, and may not play any role in <i>obtaining</i> a medical prescription. Anyone seeking to obtain a prescription should make an appointment with the medical department for an evaluation. However, in the event that an already valid prescription is being denied treatment, then an employee's labor rights are being violated. The Chief Medical Officer, the Colony Director, <i>and</i> Central Command should be contacted immediately and simultaneously, as failure to provide treatment could result in a medical emergency.</ul><BR>
				</ul>
				<hr>
				<h2>Company Events</h2>

				Internal Affairs will often be involved in the planning and execution of company events including (but not limited to) awards ceremonies, training seminars, employee cookouts, weddings, birthday parties, and other special functions.<BR><BR>

				If an employee wishes to reserve company property, or to invite employees to an event that does not take place on company property, Internal Affairs should help plan and coordinate with the heads of staff and Central Command in order to ensure these events run smoothly. Often times, events that have been approved by Central Command will be broadcast on the channel of the NanoTrasen Chatroom App specific to your site of employment.<BR><BR>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the Standard Operating Procedure at the time of its publication. Standing policy is that the most recent amendments to Standard Operating Procedure are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/cr_vol1
	name = "Corporate Regulations Volume 1: Introduction"
	icon_state = "corpreg_se"
	author = "NanoTrasen"
	title = "Corporate Regulations Volume 1: Introduction"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Corporate Regulations Volume One: Introduction</h1>
				<hr>
				<h2>What are Corporate Regulations?</h2>

				Corporate Regulations is the name for the current list of regulations in effect on the station at any given time. It also provides common and uncommon offenses and suggested punishments for them.<BR><BR>

				This is not a general guide to Security. All new officers should review their duty station's official Guide to Security.<BR><BR>

				The following are all sentences you can apply to prisoners during your work as a member of Security.<BR><BR>

				It's important to remember that while the regulations on their own are mostly a suggestion, you are expected to follow them as a guideline. For example, you are not required to give a sentence if the problem can be resolved in an alternative way that the suspect agrees to, such as community service, or peer mediation.<BR><BR>

				To understand how to go about a proper arrest, or other clarifications such a Prisoner Rights, Alert Levels, and more, see Standard Operating Procedure. Note that Standard Operating Procedure (SOP) is not enforced by threat of arrest or fine, so security should not be enforcing it. It is up to heads of staff and Internal Affairs to handle these policies.<BR><BR>
				<hr>
				<h2>Interpretation of the Law</h2>

				A good working knowledge of Corporate Regulations is important for any person on the station. It can be the difference between a shiny pair of handcuffs and sipping drinks in the bar. More in-depth interpretations of Corporate Regulations are required for such positions as the Warden, Head of Personnel, Colony Director, and the Head of Security.<BR><BR>

				For certain crimes, the accused party's intent is important. The difference between <i>assault</i> and <i>attempted murder</i> can be very hard to ascertain. It is important to note though, that <i>assault</i> and <i>attempted murder</i> are mutually exclusive. You cannot be charged with <i>assault</i> and <i>attempted murder</i> from the same crime as the intent of each is different. Likewise, <i>assault with a deadly weapon</i> and <i>assaulting an officer</i> are also crimes that exclude others. Pay careful attention to the requirements of each law and select the one that best fits the crime when deciding sentence.<BR><BR>

				If the crime has a victim involved who chooses <b>not</b> to press charges <i>specific to them</i>, security may <b>not</b> decide to press charges anyway. It doesn't matter why. If someone punches someone else, security can still arrest the assailant, but if the victim decides they would rather talk it out instead of them getting jail time, then security should let them do it. Arresting them anyway falls under wrongful arrest. Note, the victim must <b>choose</b> this option. A murder victim cannot voice their choice and therefore cannot choose to drop charges. <i>(Note that not all killings are murder - see <b>Victim of Willful Peril</b>, below.)</i><BR><BR>

				This does not mean a victim can excuse <b>all</b> crimes committed by the assailant, only the crimes committed <b>directly</b> against them. Security can still charge the assailant for crimes that, while may have happened at the same time as crimes committed against the victim, did not directly involve the victim. This includes crimes against other people and to property belonging to the base/station/etc. The victim cannot speak on behalf of these entities.<BR><BR>

				Victims suffering from non-contiguous memory disorder may be unreliable witnesses. Ask a doctor about Non-Contiguous Memory Disorder for more information.<BR><BR>

				In the case of violent crimes (assault, manslaughter, attempted murder and murder), and theft (petty, or high value) take only the most severe.<BR><BR>

				A single incident has a single sentence, so if, for instance, the prisoner took 3 items off someone, this is a single count of theft. However, if they later steal from another person, then it's two counts of theft. Likewise, a series of broken windows in one hallway is a single count of vandalism, while later damaging another hallway means a second count of vandalism.<BR><BR>

				Keep in mind that people that cause major mayhem (and potentially any other criminals) have probably committed more than one crime. Add the time for each case together.<BR><BR>

				Aiding a criminal makes you an accomplice, and you can be charged with the same crime as the person you aided to commit that crime.<BR><BR>

				As an arresting officer, follow your local Guide to Security to ensure you don't fall foul of legal proceedings.<BR><BR>

				Some crimes may have a fine tied to them, in this case, the detained person may either serve the sentence given to them, or pay a fine. Fines can be processed using an EFTPOS scanner or by paying cash directly from an ATM. All fines should be delivered to the Head of Security for deposit into the Security account. Do not take the money into your personal account, as that is considered theft.<BR><BR>
				<hr>
				<h2>Addendum</h2>

				The Colony Director is not above Corporate Regulations, and can be arrested by Security for breaking it. The only time that the Corporate Regulations can be overridden is when there is an imminent and overwhelming threat to the station, such as during Code Delta evacuations.<BR><BR>

				Pardons are only legitimate if they come from a NanoTrasen higher-up (that is, someone who ranks above the Colony Director). Despite his high ranking, the Colony Director cannot spit in the face of Corporate Regulations, and any attempts to do so are infractions.<BR><BR>

				The time you took for bringing the suspect in and the time you spend questioning are NOT to be calculated into this. This is the pure time someone spends in a cell staring at the wall.<BR><BR>

				You should apply the suggested sentence unless the Head of Security or Colony Director demands otherwise, or the arrested individual has been a continual problem during the shift.<BR><BR>

				If a sentence is 20 minutes or longer, allow the prisoner access to the communal jail area and not confine them to the cell.<BR><BR>

				If further criminal acts are made while imprisoned (such as assaulting another prisoner or breaking windows), the prisoner is to be moved to solitary confinement with charges added to their sentence.<BR><BR>

				If prison time for a single holding accumulates to more than 90 minutes, hold the prisoner until judgment by a tribunal.<BR><BR>

				<i>(( On laggy games first take a look at how quickly the cell timers tick. We don't want people to spend an eternity in jail just for stealing a pair of gloves. ))</i><BR><BR>
				<hr>
				<h2>Commentaries and Clarifications</h2>
				<ul>
					<li><b>Cyborgification</b> The removal of a person's brain for transplanting into a Cyborg Chassis as an alternative to execution. A prisoner who is sentenced to execution must request or consent to this.</li>
					<li><b>Dismissal</b>: Changing ID title to "Dismissed", which has zero access. Requires the judgment of the convicted party's head of staff or the Colony Director to be valid.</li>
					<li><b>Demotion</b>: Can be demoted down to and including Assistant position. Requires the judgment of the convicted party's head of staff or the Colony Director to be valid.</li>
					<li><b>Employee</b>: Employee of NanoTrasen, as defined by the station's commanding officer. All non-employee subjects are not protected by these laws.</li>
					<li><b>Empowering</b>: Illegal acquiring (not via Head of Personnel or Colony Director) of access.</li>
					<li><b>Execution</b>: Prisoner is killed via means of firing squad, lethal injection, or some other means. It is required for the Colony Director to be present (and not an Acting Colony Director), or an execution may not proceed. It is required to offer the prisoner the option of how they prefer to die. They should also be offered a last meal. It is not required to follow these preferences if they are deemed unreasonable or impossible. In all cases of execution, Central Command should be informed of the execution and the crimes leading up to it. (( A PK - aka Permanent Death - may be applicable in this situation.))</li>
					<li><b>Head of Staff</b>: Crew members occupying one of the following positions: Colony Director, Chief Engineer, Head of Personnel, Head of Security, Chief Medical Officer, Research Director.</li>
					<li><b>Imminent Peril</b>: A situation in which there is an apparent and immediate threat of serious injury or death, and it is not possible to escape this threat. An obvious example is shooting someone trying to stab people. A less obvious example is shooting someone who is "helping" (but actually getting in the way of) an engineer trying to stop a supermatter explosion. Lethal force is justified in such situations where any other action <i>or</i> inaction <b>will</b> lead to unnecessary loss of life.</li>
					<li><b>HuJ / Holding Until Judgment</b>: Held (in the brig) until a tribunal is done, or the shift ends. Whichever happens first.</li>
					<li><b>HuT / Holding Until Transfer</b>: Held (in the brig) until the shift ends. This becomes HuJ when a tribunal is being held for the prisoner.</li>
					<li><b>Severe Injury</b>: A state in which the victim is in a critical condition and is having difficulty maintaining consciousness.</li><BR>
				</ul>
				Demotion and dismissal also require the removal of equipment from the previous job. Uniforms, weapons, bombs, PDA cartridges, etc.<BR><BR>

				For the purposes of Cyborg/AI laws, crew members that have been convicted, or are being held in detention, are considered to be below even the AI/Cyborgs in terms of rank.<BR><BR>

				Serving sentences in jail can be replaced with forced labor in some cases.<BR><BR>

				In cases where the final sentence is more than 90 minutes, it is changed to holding until judgment.<BR><BR>

				The standard penalty can be applied without a tribunal by Security Officers.<BR><BR>

				Penalties listed here are guidelines. Tribunals can assign lesser or higher ones, depending on the circumstances.<BR><BR>
				<hr>
				<h2>Tribunals</h2>

				Tribunals are the main way major decisions are made aboard the station There are not often lawyers, and the defendant does not have to be involved. There is not specified length for how long a tribunal must be. The AI may be called in as a replacement Head of Staff if there are not sufficient numbers, and it can be trusted to be accurate. Basically it's the same as the old trial, but without a jury and slightly streamlined.<BR><BR>
				<ul>
					<li><b>Purpose:</b> For crimes or decisions that require more than one person, or crimes where there is no set punishment.</li>
					<li><b>Overview:</b> Three to Six Heads of Staff must discuss this issue and vote on the outcome.</li>
					<li><b>Process:</b> The Colony Director or acting Colony Director should call the Heads of Staff for a tribunal with the situation and proposed outcome. This can be done formally in a meeting room, or informally over radio.</li>
					<li><b>Conviction:</b> The tribunal must vote on the outcome, and the outcome must win by a majority vote (over 50%). If there is a tie, the Colony Director's vote wins.</li>
					<li><b>Sentencing:</b> If the vote passes, the outcome may be enacted, usually by Security. The decision can be appealed once by either the defendant or the Colony Director. Community service may also be offered by the tribunal, but unlike normal community service, a tribunal must vote (over 50%) in agreement upon the terms of an alternative sentence as well as the standard sentence.</li><BR>
				</ul>
				<hr>
				<h2>OOC Notes</h2>
				<ul>
					<li>It's vital to know that the involvement of CentCom means involvement of admins. However, if that happens, admins will try to keep in character. Ergo, the character is <b>not</b> going to magically know attack logs or fingerprints or anything else they don't know IC, because it's like playing a game with cheat codes. It's fun to screw off for a little while, but then it's going to get really boring.</li>
					<ul><li>The above also applies in the case of admins playing normal Security.</li>
						<li>The only exception to the above is in the case of potentially removing a character from the station. Admins are not going to PK someone who they know OOCly didn't actually do the crime.</li>
					</ul>
					<li><b>Corporate Regulations <u>ARE NOT RULES</u> for the server itself!</b> That means, so long as you have a believable in-character motive for breaking these regulations, you won't get banned for it. Conversely, if you're just going around smashing windows for shits and giggles, you're <i>obviously</i> going to get yelled at by an admin. See the actual server rules for more details.</li>
					<ul><li>And yes, that does mean that if you enforce the absolute letter of space law in a way that breaks server rules, particularly "don't be a dick", you're going to get the stink-eye from the admins regardless of how "IC" it is.</li></br>
					</ul>
				</ul>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the NanoTrasen Corporate Regulations at the time of its publication. Standing policy is that the most recent amendments to Corporate Regulations are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}


/obj/item/book/manual/legal/cr_vol2
	name = "Corporate Regulations Volume 2: Infractions (Low)"
	icon_state = "corpreg_se"
	author = "NanoTrasen"
	title = "Corporate Regulations Volume 2: Infractions (Low)"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Low Level Infractions</h1>
				<hr>
				<h2>Definition</h2>

				These infractions carry standard punishments of up to around 10 minutes, and can be set by the arresting officer's discretion, or can be reduced up to and including release at the discretion of the Warden. <b>Suggested Sentence</b> values are listed below the definitions. <b>Maximum Penalties</b> can be issued by authorization of Head of Security*, Colony Director, or equivalent (Acting Colony Director), and do not require tribunals unless stated otherwise. However, it is not advisable to do so for a first offense. <b>Fines</b> are the default punishment for most low level infractions.<BR><BR>

				Note that Security can collect a fine or issue a sentence, but not both for the same infraction. If all applicable fines are paid, the sentence is waived. A Security officer should not waste time searching or processing an individual if the paid fine waives their entire sentence.<BR><BR>
				<ul><i>*Demotions and dismissals for low level infractions cannot be legally enforced by the Head of Security except onto their own Security staff. Contact the Colony Director or CentCom to have such punishments enforced.</i>
				</ul>
				<hr>
				<h2>Infractions List</h2>
				<ul>
					<li>&sect;101</li>
					<ul><li><b>Trespassing</b></li>
						<li><b>Description:</b> To be in an area which a person does not have access to, without permission from those who do have access. Public spaces, such as a lobby, under the control of a specific department are subject to this should the department staff find you have no reason to be there at all or you are disrupting the regular service of that department, and ask you to leave. This includes the Bar, Library, and Chapel.</li>
						<li><b>Notes:</b> Remember that people can either break in, sneak in, or be let in. Always check that the suspect wasn't let in to do a job by someone with access, or were given access on their ID. Trespassing and theft often committed together; both sentences should be applied. Severity is increased if they refuse to leave the area peacefully, more so if they attempt to use important equipment there, so feel free to add other charges if they do.</li>
						<li><b>Suggested Penalty:</b> 3 minutes.</li>
						<li><b>Maximum:</b> Up to 10 minutes. Demotion.</li>
						<li><b>Fine:</b> 200 Thalers.</li></br>
					</ul>
					<li>&sect;102</li>
					<ul><li><b>Petty Theft</b></li>
						<li><b>Description:</b> To take items from areas one does not have access to, or to take items belonging to others or the station as a whole.</li>
						<li><b>Notes:</b> Keeping items which are in short supply where they belong is what is important here. A doctor who takes all the surgical tools and hides them still commits theft, even though he had access. Miners walking around the station in hardsuits while off-duty also qualifies as theft. Items can include anything from toolboxes to metal to insulated gloves. Remember to take the items away from the suspect and return them to where they were stolen from.</li>
						<li><b>Suggested Penalty:</b> 3 minutes. Confiscation and return of stolen item(s). Immediate search.</li>
						<li><b>Maximum:</b> Up to 10 minutes. Demotion.</li>
						<li><b>Fine:</b> N/A</li></br>
					</ul>
					<li>&sect;103</li>
					<ul><li><b>Minor Assault</b></li>
						<li><b>Description:</b> To use, or threaten, physical force against someone, without intent to kill or seriously injure.</li>
						<li><b>Notes:</b> If it causes minor damage and easily treatable damage, it's minor assault. Starting fights with other employees or punching fellow employees counts too, as well as seriously threatening them with it.</li>
						<li><b>Suggested Penalty:</b> 4 minutes.</li>
						<li><b>Maximum:</b> Up to 10 minutes. Demotion.</li>
						<li><b>Fine:</b> 400 Thalers.</li></br>
					</ul>
					<li>&sect;104</li>
					<ul><li><b>Battery</b></li>
						<li><b>Description:</b> To have unwanted physical contact with someone, even where the contact is not violent.</li>
						<li><b>Notes:</b> Bumping into someone in a corridor doesn't really count. Touching someone, when they have explicitly told you not to, does.</li>
						<li><b>Suggested Penalty:</b> 2 minutes.</li>
						<li><b>Maximum:</b> Up to 8 minutes. Demotion.</li>
						<li><b>Fine:</b> 200 Thalers.</li></br>
					</ul>
					<li>&sect;105</li>
					<ul><li><b>Disturbing the Peace</b></li>
						<li><b>Description:</b> Intentionally and publicly engaging in erotic acts, yelling at people for no reason (though don't arrest someone because they are arguing), throwing around stuff where it could hit someone, harassing a person or department without provocation and following them around / refusing to leave, yelling about how terrible NanoTrasen is, etc.</li>
						<li><b>Notes:</b> Running around the station naked (without a nudity permit) while yelling obscenities, openly having sex in a public area while ignoring requests to take it someplace private, or other such degrading displays and activities all count toward this. In the case of drunken crew members, only charge them if they are actually being a nuisance. If absolutely necessary, they can be detained until they sober up.</li>
						<li><b>Suggested Penalty:</b> 5 minutes.</li>
						<li><b>Maximum:</b> Up to 8 minutes. Demotion.</li>
						<li><b>Fine:</b> 250 Thalers.</li></br>
					</ul>
					<li>&sect;106</li>
					<ul><li><b>Suspicious Conduct</b></li>
						<li><b>Description:</b> To possess a suspiciously wide skill set not indicated in employee records, wielding dangerous weapons near other staff, extensive inquiring about critical areas, attempting to conceal identity, attempting to impersonate other staff, or stalking other employees.</li>
						<li><b>Notes:</b> Wearing any gear that fully covers your face when you don't need it falls under this. Doing jobs that aren't yours also fall under this. For example; a xenobiologist working in robotics without the RD's knowing, or a psychiatrist trying to do surgery in place of other perfectly capable doctors. If an individual is working outside their job title or wearing the wrong department's uniform without anyone's knowing, the individual may have ulterior motives and should be investigated. Acting irrationally or threateningly also counts for this. <i>(( Basically, metagamey/powergamey/lolcrazy behavior. You shouldn't know how to do everything, or acting like a nutjob. Someone behaving like this may also be breaking server rules, so contact an admin as well. ))</i></li>
						<li><b>Suggested Penalty:</b> Immediate search.</li>
						<li><b>Maximum:</b> Indefinite detainment for the duration of an investigation. Forced psychiatric examination. Tracking implant.</li>
						<li><b>Fine:</b> N/A</li></br>
					</ul>
					<li>&sect;107</li>
					<ul><li><b>Misuse of Public Radio Channels</b></li>
						<li><b>Description:</b> To continually broadcast unimportant, untrue, or insignificant messages on the public radio frequency.</li>
						<li><b>Notes:</b> This is really only for people who are constantly spamming the radio, such as 'DJs' or Chaplains reading their services over the comms. Screaming fake messages like "halp security is beating me" when they aren't also counts. Extreme false alarms such as yelling "breach in the bar!" when there isn't a breach may also come under <b>Obstruction of Duty (&sect;120).</b></li>
						<li><b>Suggested Penalty:</b> Warning.</li>
						<li><b>Maximum:</b> 5 minutes. Forced psychiatric examination. Ban from using any radio equipment (Injunction).</li>
						<li><b>Fine:</b> 150 Thalers (after warning).</li></br>
					</ul>
					<li>&sect;108</li>
					<ul><li><b>Violation of Injunction</b></li>
						<li><b>Description:</b> To violate the terms of an injunction made by Security or other legal professions.</li>
						<li><b>Notes:</b> Injunctions can be filed for lots of different things, such as a ban on weapons carrying, or the above radio ban. They can be applied by the Head of Security, Colony Director, or equivalent. If they break the law in some other way, apply that sentence too.</li>
						<li><b>Suggested Penalty:</b> 5 minutes.</li>
						<li><b>Maximum:</b> Up to 10 minutes.</li>
						<li><b>Fine:</b> N/A</li></br>
					</ul>
					<li>&sect;109</li>
					<ul><li><b>Harassment</b></li>
						<li><b>Description:</b> To persistently insult, stalk, ridicule, or otherwise intentionally bring stress upon another crew member.</li>
						<li><b>Notes:</b> If a crew member has been following you around or bad mouthing you for some time, and has already been asked to stop, Security may be involved to <i>make</i> it stop, starting with an official (last) warning. If the actions or comments are of a sexual context, do not use this charge and use <b>Sexual Harassment (&sect;110)</b> instead. If harassing comments are proven false, add <b>Slander (&sect;111)</b> to the charges. However, Security should take care to avoid punishing <i>constructive</i> criticism if possible. For example, just calling someone incompetent over and over is viewed as harassment. Explaining how to fix something it is not harassment unless it comes from a source who doesn't have any qualification for saying so (e.g. a janitor bothering an engineer about the best way to power the station). If a crew member believes somebody is doing their job poorly and it is affecting them, they should bring it up with the relevant head of staff, or an Internal Affairs Agent.</li>
						<li><b>Suggested Penalty:</b> Warning.</li>
						<li><b>Maximum:</b> 5 minutes. Forced psychiatric examination.</li>
						<li><b>Fine:</b> 100 Thalers (after warning).</li></br>
					</ul>
					<li>&sect;110</li>
					<ul><li><b>Sexual Harassment</b></li>
						<li><b>Description:</b> To make unwanted sexual advances or obscene remarks towards another employee.</li>
						<li><b>Notes:</b> This is for VERY MINOR things the other person finds offensive that are sexually related. For anything more serious, see <b>Sexual Assault (&sect;308)</b>.
						<li><b>Suggested Penalty:</b> 5 minutes.</li>
						<li><b>Maximum:</b> Up to 15 minutes. Demotion.</li>
						<li><b>Fine:</b> N/A</li></br>
					</ul>
					<li>&sect;111</li>
					<ul><li><b>Slander</b></li>
						<li><b>Description:</b> To spread false rumors in order to damage someone's reputation.</li>
						<li><b>Notes:</b> Lying about anything to make someone else look bad. For example, an engineer trying to pass off the blame of letting the singularity loose to someone else. Since this has to be proven, it's up to a tribunal or appropriate officer.
						<li><b>Suggested Penalty:</b> Warning.</li>
						<li><b>Maximum:</b> 5 minutes.</li>
						<li><b>Fine:</b> 100 Thalers (after warning).</li></br>
					</ul>
					<li>&sect;112</li>
					<ul><li><b>Failure to Execute an Order</b></li>
						<li><b>Description:</b> To ignore or disregard a superior's valid orders.</li>
						<li><b>Notes:</b> If the order is stupid, or causes you to break a law (e.g. "Release the singularity!" or "Steal that RCD for me!") you can ignore it, and probably make a complaint. However, if it's perfectly doable, lawful, and in your job description, you better do it or resign. If not following an order causes severe damage, serious injury, or loss of life, see <i>Failure to Execute an Order with Serious Consequences</i>.</li>
						<li><b>Suggested Penalty:</b> 5 minutes.</li>
						<li><b>Maximum:</b> Up to 10 minutes. Demotion.</li>
						<li><b>Fine:</b> 500 Thalers.</li></br>
					</ul>
					<li>&sect;113</li>
					<ul><li><b>Animal Cruelty</b></li>
						<li><b>Description:</b> To inflict unnecessary suffering or harm upon animals with malicious intent.</li>
						<li><b>Notes:</b> Monkeys appropriately used for experiments or crew well-being (e.g Genetics, Virology, etc.) don't count. Shoving them in washing machines, or throwing them through disposals while still alive falls under this. Using them as food is a grey area; cows are generally fine, but pets probably aren't.</li>
						<li><b>Suggested Penalty:</b> 5 minutes.</li>
						<li><b>Maximum:</b> Up to 15 minutes. Demotion.</li>
						<li><b>Fine:</b> N/A</li></br>
					</ul>
					<li>&sect;114</li>
					<ul><li><b>Vandalism</b></li>
						<li><b>Description:</b> To deliberately damage or deface the station without malicious intent. Damaging robots counts toward this.</li>
						<li><b>Notes:</b> This can range from a minor hull breach, to drawing on the floor with crayons or other substances. You can adjust the time accordingly.
						<li><b>Suggested Penalty:</b> 5 minutes.</li>
						<li><b>Maximum:</b> Up to 10 minutes. Demotion.</li>
						<li><b>Fine:</b> 450 Thalers.</li></br>
					</ul>
					<li>&sect;115</li>
					<ul><li><b>Threat of Murder or Serious Injury</b></li>
						<li><b>Description:</b> To threaten to kill or seriously injure an employee.</li>
						<li><b>Notes:</b> The threat has to somewhat tangible. If it's just people arguing over the radio, it's probably only worth Warning. Someone shouting at someone else while chasing them with a fire extinguisher is probably more valid.
						<li><b>Suggested Penalty:</b> 2 minutes.</li>
						<li><b>Maximum:</b> Up to 10 minutes. Forced psychiatric evaluation. Tracking implant.</li>
						<li><b>Fine:</b> 500 Thalers.</li></br>
					</ul>
					<li>&sect;116</li>
					<ul><li><b>Disrespect to the Dead</b></li>
						<li><b>Description:</b> To abuse bodies of dead or previously dead employees.</li>
						<li><b>Notes:</b> Examples include, the chef using bodies in the morgue as meat, Security beating on a prisoners corpse, or using someone's body for 'experimental surgery'. Preventing a body from being cloned or cyborged also falls under this.
						<li><b>Suggested Penalty:</b> 5 minutes.</li>
						<li><b>Maximum:</b> Up to 10 minutes.</li>
						<li><b>Fine:</b> 400 Thalers.</li></br>
					</ul>
					<li>&sect;117</li>
					<ul><li><b>Excessive use of force in detainment</b></li>
						<li><b>Description:</b> To use more than the required force to subdue a suspect.</li>
						<li><b>Notes:</b> This includes using force on a compliant suspect or prisoner, intentionally injuring a handcuffed suspect or prisoner, using force against an unarmed and compliant suspect, and usage of lethal weapons without there being imminent peril. Investigations into allegations of excessive use of force may be launched by any head of staff, or by Central Command.</li>
						<li><b>Suggested Penalty:</b> 5 minutes.</li>
						<li><b>Maximum:</b> Up to 20 minutes. Demotion.</li>
						<li><b>Fine:</b> 350 Thalers.</li></br>
					</ul>
					<li>&sect;118</li>
					<ul><li><b>Minor Contraband</b></li>
						<li><b>Description:</b> To be in possession of contraband, including drugs, that isn't dangerous to other members of the crew.</li>
						<li><b>Notes:</b> Having a non-lethal weapon you're not normally allowed without any sort of permit counts for this, including violations of any such permits, such as the barman taking their shotgun outside the bar area but all they have are beanbag rounds. For drug charges, this applies if they do not show any intent to distribute, or lack a prescription written and stamped by the Chief Medical Officer. This also includes chameleon items, since you can impersonate important figures. Keep in mind that a chameleon weapon used to threaten crew, even while harmless, is still <b>Assault (&sect;208)</b>. For contraband ''intended'' to be dangerous, see <b>Major Contraband (&sect;212)</b> below.
						<li><b>Suggested Penalty:</b> Confiscation of contraband item(s). Immediate search.</li>
						<li><b>Maximum:</b> Up to 10 minutes. Demotion.</li>
						<li><b>Fine:</b> N/A</li></br>
					</ul>
					<li>&sect;119</li>
					<ul><li><b>Illegal Parking</b></li>
						<li><b>Description:</b> To park a vehicle in such a way that it is a nuisance to crew movement.</li>
						<li><b>Notes:</b> If someone has to exit a vehicle or mech, they are to leave it at the edge of a room or the side of a hallway so as to avoid impeding traffic of other crew. If the vehicle is parked in the middle of the room, it's a violation of this. Mechs count as vehicles. If a hallway or door is completely blocked off because of this, see <b>Illegal Blocking of Areas (&sect;217)</b> below.</li>
						<li><b>Suggested Penalty:</b> Impounding of vehicle until fine is paid.</li>
						<li><b>Maximum:</b> Destruction of vehicle.</li>
						<li><b>Fine:</b> 200 Thalers.</li></br>
					</ul>
					<li>&sect;120</li>
					<ul><li><b>Obstruction of Duty</b></li>
						<li><b>Description:</b> To negatively interfere with the duties of the crew.</li>
						<li><b>Notes:</b> Pushing a security officer trying to make an arrest, ignoring or ripping down caution tape, opening fire airlocks to enter (not escape) a disaster area, dragging injured personnel away from doctors trying to treat them, or any other form of getting in the way; especially during an emergency. Making false or malicious emergency calls that take personnel away from their other duties also comes under this. If someone is injured because of this, see <b>Assault (&sect;208)</b> below. If serious damage occurs because of this, see <b>Sabotage (&sect;213)</b> below. If someone dies because of this, see <b>Manslaughter (&sect;302)</b> below.</li>
						<li><b>Suggested Penalty:</b> Warning.</li>
						<li><b>Maximum:</b> Detainment until duties are completed. Demotion.</li>
						<li><b>Fine:</b> 500 Thalers (after warning).</li></br>
					</ul>
					<li>&sect;121</li>
					<ul><li><b>Rubbernecking</b></li>
						<li><b>Description:</b> Arriving at the scene of an emergency situation with no other intention than to see what happens.</li>
						<li><b>Notes:</b> An example of this is when Security/Engineering/Medical staff are trying to handle a crisis, but other staff who have no legitimate reason to be there start swarming the area to do nothing but gawk at the crisis as it unfolds. This is only a crime once the offending staff are asked to leave, but they ignore the request. If a hallway or door is completely blocked off because of this, see <b>Illegal Blocking of Areas (&sect;217)</b> below. If someone dies because of this, see <b>Manslaughter (&sect;302)</b> below.
						<li><b>Suggested Penalty:</b> Forceful removal from area.</li>
						<li><b>Maximum:</b> Detainment until crisis is resolved. Demotion.</li>
						<li><b>Fine:</b> N/A</li></br>
					</ul>
					<li>&sect;122</li>
					<ul><li><b>Operating Under the Influence</b></li>
						<li><b>Description:</b> To operate heavy machinery or sensitive/dangerous equipment while under the effects of drugs or alcohol.</li>
						<li><b>Notes:</b> If you're too drunk to talk straight, you're too drunk to safely pilot a mech, handle weapons, distribute medicine, manage the supermatter engine, etc.
						<li><b>Suggested Penalty:</b> Detainment until sober.</li>
						<li><b>Maximum:</b> Demotion.</li>
						<li><b>Fine:</b> N/A</li></br>
					</ul>
					<li>&sect;123</li>
					<ul><li><b>Violation of Employee Rights</b></li>
						<li><b>Description:</b> To deliberately deny an employee certain rights, as defined in Standard Operating Procedure.</li>
						<li><b>Notes:</b> This is one of the only cases where Security can punish someone for breaking SOP, but this still requires an Internal Affairs Agent to be pushing the charges for them to be valid. If an Internal Affairs Agent determines that an employee's rights have been violated by another employee, such as denying the victim break time, or subjecting the victim to discriminatory practices, etc, the Internal Affairs Agent can call upon security to fine the offending party. The choice of punishment for this is at the discretion of the Internal Affairs Agent pushing for the charges.
						<li><b>Suggested Penalty:</b> Warning.</li>
						<li><b>Maximum:</b> Demotion.</li>
						<li><b>Fine:</b> 1000 Thalers (after warning).</li></br>
					</ul>
					<li>&sect;124</li>
					<ul><li><b>Minor Negligence</b></li>
						<li><b>Description:</b> To engage in negligent behavior leading to minor injury or damage, without deliberate intent.</li>
						<li><b>Notes:</b> As with <b>Minor Assault</b>, this applies if the damage/hazard caused is minor and easily treatable. For example, a janitor failing to place wet floor signs resulting in crew members slipping, or a bartender failing to remove leftover uranium before serving a Manhattan Project. Running in the halls and trampling smaller crew underfoot also counts if they are injured as a result. For ''deliberate'' behavior, assault or vandalism charges are more applicable.</li>
						<li><b>Suggested Penalty:</b> Warning.</li>
						<li><b>Maximum:</b> Up to 10 minutes. Demotion.</li>
						<li><b>Fine:</b> 100 Thalers (after warning).</li></br>
					</ul>
					<li>&sect;125</li>
					<ul><li><b>Forgery</b></li>
						<li><b>Description:</b> To falsify official documents or orders.</li>
						<li><b>Notes:</b> A good example of this is to claim a superior gave orders to do something when they didn't, such as by faking a fax. Another example is a medical prescription without the proper signage. See also Guide to Paperwork and remember to check all important documents for valid signatures and department stamps.</li>
						<li><b>Suggested Penalty:</b> 5 minutes. Immediate search.</li>
						<li><b>Maximum:</b> Up to 10 minutes. Demotion.</li>
						<li><b>Fine:</b> N/A</li></br>
					</ul>
					<li>&sect;126</li>
					<ul><li><b>Delinquency</b></li>
						<li><b>Description:</b> Failure to pay a fine.</li>
						<li><b>Notes:</b> If a crew member is charged with a minor crime, they are to be given the option to pay a fine, or they are to be given a sentence. However, if they say they are going to pay the fine and then don't, they have ten minutes to change their mind and accept a sentence willingly, or else they become delinquent.</li>
						<li><b>Suggested Penalty:</b> Immediate arrest and sentencing of the maximum penalty for crimes covered by the unpaid fines. For the rest of the shift, their option to pay fines is also revoked, and any further minor crimes will be punished with sentences by default.</li>
						<li><b>Maximum:</b> <b>Resisting Arrest (&sect;202)</b> added to charges. Dismissal.</li>
						<li><b>Fine:</b> N/A</li></br>
					</ul>
					<li>&sect;127</li>
					<ul><li><b>Misconduct</b></li>
						<li><b>Description:</b> To intentionally avoid performing your duties, blatantly or with pretense.</li>
						<li><b>Notes:</b> A direct relative of <b>Failure to Execute an Order (&sect;112)</b>, Misconduct is the conspicuous shirking of an employee's responsibilities even in the absence of a direct order. Without a Head of Security to direct them, On Duty Officers are still expected to patrol and respond to emergency calls, for example. Note that Off Duty crew may not be charged with Misconduct, unless the act of going Off Duty was a blatant attempt to avoid responding to a call, which again falls under <b>Failure to Execute an Order (&sect;112)</b>.
						<li><b>Suggested Penalty:</b> 5 Minutes.</li>
						<li><b>Maximum:</b> Up to 10 Minutes. Demotion.</li>
						<li><b>Fine:</b> 500 Thalers</li></br>
					</ul>
				</ul>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the NanoTrasen Corporate Regulations at the time of its publication. Standing policy is that the most recent amendments to Corporate Regulations are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/cr_vol3
	name = "Corporate Regulations Volume 3: Infractions (Moderate)"
	icon_state = "corpreg_se"
	author = "NanoTrasen"
	title = "Corporate Regulations Volume 3: Infractions (Moderate)"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Medium Level Infractions</h1>

				These Infractions carry standard punishments of up to 30 minutes, though typically around 10-15 minutes, and can be set by the arresting officer's discretion. <b>Suggested Sentence</b> values are beside the Infractions. <b>Maximum Penalties</b> can be issued by authorization of Head of Security*, Colony Director, or equivalent (Acting Colony Director), and do not require tribunals unless stated otherwise. However, it is not advisable to do so for a first offense.<BR><BR>
				<ul><i>* Demotions and dismissals for medium level infractions cannot be legally enforced by the Head of Security except onto their own Security staff. Contact the Colony Director or CentCom to have such punishments enforced.</ul></i>
				<hr>
				<h2>Infractions List</h2>
				<ul>
					<li>&sect;201</li>
					<ul><li><b>Failure to Execute an Order with Serious Consequences</b></li>
						<li><b>Description:</b> To ignore or disregard a superior's valid orders, which then causes serious damage to property or life.</li>
						<li><b>Notes:</b> Like the minor crime, except this one has caused serious damage to the station, or seriously injured someone. Examples are Medical Doctors ignoring the Chief Medical Officer while patients are piling up in medbay, or Engineers ignoring the Chief Engineer and then having the singularity eat part of the station. If this causes loss of life, add &sect;302 to the charges on top of this one.</li>
						<li><b>Suggested Penalty:</b> 15 minutes.</li>
						<li><b>Maximum:</b> 30 minutes. Demotion.</li><br>
					</ul>
					<li>&sect;202</li>
					<ul><li><b>Resisting Arrest</b></li>
						<li><b>Description:</b> To not cooperate with an officer who attempts a proper arrest, or to cause a manhunt by hiding from security.</li>
						<li><b>Notes:</b> Refusing handcuffs is not resisting arrest. Refusing handcuffs ''and'' refusing to come to the brig ''is'' resisting arrest. So is pushing the officer trying to arrest you, or running away. Simply not showing up to the brig when asked doesn't count. Actively hiding or running away is what this law is for. Take into account their reason for not reporting to security immediately as well. For example, a Chief Engineer trying to stop the engine from exploding probably shouldn't be charged with resisting arrest if they ignore the fact that security wants to give them a vandalism fine for breaking a wall earlier. Likewise, if anyone in security has threatened them with ''harm'', not just arrest, they're somewhat justified in hiding. Furthermore, you cannot ''just'' charge someone with resisting arrest alone. If all other charges are dropped or pardoned, so is this one.</li>
						<li><b>Suggested Penalty:</b> 10 minutes.</li>
						<li><b>Maximum:</b> 20 minutes.</li><br>
					</ul>
					<li>&sect;203</li>
					<ul><li><b>Suicide Attempt</b></li>
						<li><b>Description:</b> To attempt or threaten to commit suicide.</li>
						<li><b>Notes:</b> An employee trying or threatening to kill himself for any reason. This includes someone saying "AI OPEN THIS DOOR OR I KILL MYSELF".</li>
						<li><b>Suggested Penalty:</b> Transfer custody to Medical for compulsory psychiatric examination. Confinement in Psychiatric Ward until examined.</li>
						<li><b>Maximum:</b> Demotion. Confinement in Psychiatric Ward. Hold until judgment.</li><br>
					</ul>
					<li>&sect;204</li>
					<ul><li><b>Abuse of Confiscated Equipment</b></li>
						<li><b>Description:</b> To take and use equipment confiscated as evidence.</li>
						<li><b>Notes:</b> Security shouldn't be using evidence for anything but evidence <b>even during emergencies</b>. It's pretty straightforward.</li>
						<li><b>Suggested Penalty:</b> 10 minutes and re-confiscation of equipment.</li>
						<li><b>Maximum:</b> Dismissal.</li><br>
					</ul>
					<li>&sect;205</li>
					<ul><li><b>Illegal Detention, Arrest, or Holding</b></li>
						<li><b>Description:</b> To arrest, brig, or punish an employee without proper cause or reason, or in violation of due process rights such as Habeas Corpus. See also <b>Violation of Employee Rights, (&sect;123)</b></li>
						<li><b>Notes:</b> This is mainly for Security Officers who believe they are THE LAW. Also applies to kidnapping. Excessive/disproportionate time spent processing or questioning may fall under this category for minor crimes.</li>
						<li><b>Suggested Penalty:</b> 15 minutes.</li>
						<li><b>Maximum:</b> Dismissal.</li><br>
					</ul>
					<li>&sect;206</li>
					<ul><li><b>Negligence</b></li>
						<li><b>Description:</b> To fail to perform a job to a satisfactory standard, or to create a dangerous situation without taking proper precautions.</li>
						<li><b>Notes:</b> This can be due to honest, or dishonest mistakes. This is usually because someone ignored Standard Operating Procedure and an accident occurred because of that. The charge also applies to exposing areas to space without placing hazard tape to keep people out, putting excessive power into the grid and reasoning it's the crew's fault if they get shocked, and so on. If someone is killed because of it, add <b>Manslaughter</b> to the charges.</li>
						<li><b>Suggested Penalty:</b> 10 minutes.</li>
						<li><b>Maximum:</b> Demotion.</li><br>
					</ul>
					<li>&sect;207</li>
					<ul><li><b>Infiltration</b></li>
						<li><b>Description:</b> To attempt to, or successfully, enter a high-security area without authorization.</li>
						<li><b>Notes:</b> Areas include: AI core/upload, Armory, Bridge, EVA, Bluespace Gateway, Head of Staff offices, R&D Server Room, Telecomms, Teleporter room, Telescience, Toxins Storage, Vault, and Virology. Asking the AI or a Cyborg to get in doesn't count as getting authorization. (See also: Secure Areas in Standard Operating Procedure.)</li>
						<li><b>Suggested Penalty:</b> 15 minutes.</li>
						<li><b>Maximum:</b> 30 minutes.</li><br>
					</ul>
					<li>&sect;208</li>
					<ul><li><b>Assault</b></li>
						<li><b>Description:</b> To cause severe injury to another employee, or brandishing a deadly weapon with the intent of causing or threatening such an injury.</li>
						<li><b>Notes:</b> Anything beyond a few punches like in "Minor Assault". It has to be bad enough that a few bandages or pills won't fix it. Can be adjusted for severity. Also see "Attempted Murder" if the intent was to kill. This also includes poisoning with drugs, or using hallucinogens. Chameleon weapons, fake weapons, and non-loaded weapons still count as brandishing if the victim cannot reasonably tell that the weapon is harmless.
						<li><b>Suggested Penalty:</b> 10 minutes.</li>
						<li><b>Maximum:</b> 20 minutes. Demotion.</li><br>
					</ul>
					<li>&sect;209</li>
					<ul><li><b>Escaping From Confinement</b></li>
						<li><b>Description:</b> To escape from confinement as someone who was serving a non-life sentence or was awaiting judgment.</li>
						<li><b>Notes:</b> See <b> Escaping From HuT Sentence (&sect;306)</b> for those who were already judged for holding until transfer.</li>
						<li><b>Suggested Penalty:</b> Recapture suspect, and reset their original sentence, and also add an extra 20 minutes. If this pushes the sentence over 90 minutes, hold until judgment.</li>
						<li><b>Maximum:</b> Hold until judgment.</li><br>
					</ul>
					<li>&sect;210</li>
					<ul><li><b>Unlawful Modification of AI/Cyborg Laws</b></li>
						<li><b>Description:</b> To modify the laws of a cyborg or artificial intelligence, without need, proper access, or authority.</li>
						<li><b>Notes:</b> An exception would be a law reset when obviously harmful laws have been uploaded. Only the Colony Director or two Heads of Staff together can authorize a law change outside of this situation.</li>
						<li><b>Suggested Penalty:</b> 20 minutes.</li>
						<li><b>Maximum:</b> Demotion. Hold until judgment.</li><br>
					</ul>
					<li>&sect;210.1</li>
					<ul><li><b>Unauthorized Transfer of AI/Cyborg Hardware</b></li>
						<li><b>Description:</b> To remove the "brain" - MMI, Positronic, or otherwise - with intent to alter its function.</li>
						<li><b>Notes:</b> This is not only a direct cousin of <b>Unlawful Modification of AI/Cyborg Laws (&sect;210)</b>, but of <b>Grand Theft (&sect;215)</b> as well. Cyborgs and the Stationbound AI are the private property of NanoTrasen. Illegally removing the cogitation hardware of a Cyborg or AI and placing it into a Full Body Prosthetic or other "body" - including surgery to revert the MMI process and implant the wetware into a living body - is to be treated as equivalent to grand theft and illegal modification of laws.</li>
						<li><b>Suggested Penalty:</b> 20 minutes and the return of any disassembled Silicon components.</li>
						<li><b>Maximum:</b> Demotion. Hold until judgement.</li><br>
					</ul>
					<li>&sect;211</li>
					<ul><li><b>Sedition</b></li>
						<li><b>Description:</b> To incite rebellion, or rally against the established chain of command.</li>
						<li><b>Notes:</b> This includes attempting to make separate areas of the ship into "Nations" or generally conspiring against the chain of command.</li>
						<li><b>Suggested Penalty:</b> 15 minutes.</li>
						<li><b>Maximum:</b> Demotion. Hold until judgment.</li><br>
					</ul>
					<li>&sect;212</li>
					<ul><li><b>Major Contraband</b></li>
						<li><b>Description:</b> To possess, use, or distribute dangerous contraband items, including drugs.</li>
						<li><b>Notes:</b> The key word is <b>dangerous</b>. The contraband has to be dangerous to someone other than the person using it, such as guns or distributing drugs, or the contraband is designed with the specific purpose of breaking into secure areas (such as an emag, or bluespace harpoon, but ''not'' multitools or insulated gloves, as those have a legitimate intended purpose). Permits written by the Head of Security, Colony Director, or Central Command will override this law. The Chief Medical Officer can also authorize the possession of normally illegal drugs through prescriptions. Research is allowed to possess ''any'' contraband so long as they comply with their Contraband Policy.</li>
						<li><b>Suggested Penalty:</b> 15 minutes, confiscation of said items</li>
						<li><b>Maximum:</b> 20 minutes. Demotion.</li><br>
					</ul>
					<li>&sect;213</li>
					<ul><li><b>Sabotage</b></li>
						<li><b>Description:</b> To hinder the efforts of the crew or station with malicious intent.
						<li><b>Notes:</b> This includes causing hull breaches, sabotaging air supplies, stealing vital equipment, etc. The intent is probably the most important bit here. If the act creates imminent peril for crew, see <b>Terrorism (&sect;304)</b>.</li>
						<li><b>Suggested Penalty:</b> 20 minutes.</li>
						<li><b>Maximum:</b> Hold until judgment.</li><br>
					</ul>
					<li>&sect;214</li>
					<ul><li><b>Exceeding Official Powers</b></li>
						<li><b>Description:</b> To act beyond what is allowed by the Chain of Command.</li>
						<li><b>Notes:</b> This is for any head of staff who abuses the power given to them, such as the Head of Personnel acting like a security officer in a non-emergency, the Colony Director acting as if he is above the law, etc. Heads of Staff trying to order a different department or ignoring the Colony Director also comes under this, as does security staff attempting to give orders to non-security without legal justification. Also covers anyone illegally promoting themselves, such as with a stolen ID.</li>
						<li><b>Suggested Penalty:</b> 15 minutes.</li>
						<li><b>Maximum:</b> 30 minutes. Demotion.</li><br>
					</ul>
					<li>&sect;215</li>
					<ul><li><b>Grand Theft</b></li>
						<li><b>Description:</b> To steal items that are dangerous, of a high value, or of sensitive nature.</li>
						<li><b>Notes:</b> This means weapons, explosives, or ammunition, and also includes items from the High-risk Items list. Security Officers stealing things from the armory is an example.</li>
						<li><b>Suggested Penalty:</b> 15 minutes and confiscation of stolen items.</li>
						<li><b>Maximum:</b> 30 minutes. Demotion.</li><br>
					</ul>
					<li>&sect;216</li>
					<ul><li><b>Organizing a Breakout</b></li>
						<li><b>Description:</b> To attempt, or succeed, in freeing criminals from the brig or other holding areas.</li>
						<li><b>Notes:</b> Breaking brig windows, or hacking into security to free someone. Keep in mind the severity of crimes by the person they are trying to free before you consider more penalties. If they are just breaking out someone who only broke a window, then 15 minutes is probably enough. If they are freeing a person who did something more serious (such as any high severity infraction), then you should hold the suspect until they are judged by tribunal.</li>
						<li><b>Suggested Penalty:</b> 15 minutes.</li>
						<li><b>Maximum:</b> 30 minutes. Demotion. Hold until judgment (if applicable).</li><br>
					</ul>
					<li>&sect;217</li>
					<ul><li><b>Illegal Blocking of Areas</b></li>
						<li><b>Description:</b> To make an area inaccessible for those with appropriate access.
						<li><b>Notes:</b> Bolting doors in public hallways or to those of departments you don't have control over are examples of this. Taping off areas that are larger than needed, or leaving areas sealed long after the need has passed, also counts if it ends up interfering with the crew's normal duties.</li>
						<li><b>Suggested Penalty:</b> 10 minutes.</li>
						<li><b>Maximum:</b> Up to 25 minutes. Demotion.</li><br>
					</ul>
					<li>&sect;218</li>
					<ul><li><b>Failure to Obey Safety Protocol</b></li>
						<li><b>Description:</b> To willfully ignore safety measures keeping crew out of a crisis zone.</li>
						<li><b>Notes:</b> Non-engineers opening fire shutters, civilians breaking down security barriers, or anyone ignoring caution tape without being qualified to handle whatever is behind it, are all examples of this. If someone is killed because of it, add <b>Manslaughter (&sect;302)</b> to the charges. Being trapped inside a dangerous area and just trying to escape doesn't count toward this.</li>
						<li><b>Suggested Penalty:</b> 10 minutes.</li>
						<li><b>Maximum:</b> Detainment until crisis is resolved. Demotion.</li><br>
					</ul>
					<li>&sect;219</li>
					<ul><li><b>Severe Use of Excessive Force</b></li>
						<li><b>Description:</b> Critically injuring someone in defense of yourself or others while they no longer pose a threat, or seriously injuring a suspect while attempting to detain them.</li>
						<li><b>Notes:</b> Severely injuring someone attacking you or others with no obvious threat to life, or panicking and shooting a suspect to near-death.</li>
						<li><b>Suggested Penalty:</b> 10 minutes.</li>
						<li><b>Maximum:</b> 30 minutes. Demotion.</li><br>
					</ul>
					<li>&sect;220</li>
					<ul><li><b>Mistreatment of Prisoners</b></li>
						<li><b>Description:</b> To intentionally act, or cause an act that puts a non-hostile prisoner's well-being in danger.</li>
						<li><b>Notes:</b> Preventing proper treatment from being given to a prisoner, abusing a prisoner, and preventing them from having access to a viable method of communication. In the event that a prisoner dies because of mistreatment, the charge is immediately upgraded to either murder or manslaughter, depending on intent.</li>
						<li><b>Suggested Penalty:</b> 10 minutes.</li>
						<li><b>Maximum:</b> 30 minutes. Demotion.</li><br>
					</ul>
					<li>&sect;221</li>
					<ul><li><b>Violating Employee Privacy</b></li>
						<li><b>Description:</b> To conduct illegal searches and seizures, or to covertly survey crew members by any means aside from cameras. Breach of Medical Confidentiality, release of personal information on people in your care.</li>
						<li><b>Notes:</b> Security using thermals, or hiding radios to eavesdrop on conversations are both examples of this. Unless issued a warrant, spying activities are illegal. The Security specific aspects of this law are ignored during code blue or higher. Personal information of patients and prisoners is always protected.</li>
						<li><b>Suggested Penalty:</b> 10 minutes.</li>
						<li><b>Maximum:</b> 30 minutes. Demotion.</li><br>
					</ul>
					<li>&sect;222</li>
					<ul><li><b>Dereliction of Duty</b></li>
						<li><b>Description:</b> To knowingly and willfully abandon your post while still on duty. To engage in personal activities during an emergency.</li>
						<li><b>Notes:</b> A sister crime to Negligence, this covers everything from Engineers staying in the dorms during a meteor strike to Heads of Staff engaging in sexual activities during an elevated Alert status. Note that on the lower end of the spectrum other members of the Department may have taken responsibility for handling a situation. An Off-Duty employee is exempt from Dereliction charges, unless they went Off-Duty in direct attempt to avoid a call.</li>
						<li><b>Suggested Penalty:</b> 10 minutes.</li>
						<li><b>Maximum:</b> Demotion. Depending on the circumstances, a fax must also be sent to Central Command. Repeat offenses can result in temporary suspension from the position, up to permanent restriction.</li><br>
					</ul>
				</ul>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the NanoTrasen Corporate Regulations at the time of its publication. Standing policy is that the most recent amendments to Corporate Regulations are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/cr_vol4
	name = "Corporate Regulations Volume 4: Infractions (Severe)"
	icon_state = "corpreg_se"
	author = "NanoTrasen"
	title = "Corporate Regulations Volume 4: Infractions (Severe)"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>High Severity Infractions</h1>

				These Infractions generally need to be ruled on by a tribunal as explained further below, and criminals should be held until judgment can be passed. In a few severe circumstances, permanent removal from the station may occur. Central Command must be contacted for permanent removals to be enforced.<BR><BR>
				<hr>
				<h2>Infractions List</h2>
				<ul>
					<li>&sect;301</li>
					<ul><li><b>Murder</b></li>
						<li><b>Description:</b> To kill someone, or attempt to kill someone, with premeditated malicious intent.</li>
						<li><b>Notes:</b> Premeditated and malicious is important for it to be considered murder and not manslaughter. This also covers attempted murder.</li>
						<li><b>Default Sentence:</b> Holding until judgment.</li>
						<li><b>Chosen by Tribunal:</b> Hold until transfer. Permanent removal from the station.</li><br>
					</ul>
					<li>&sect;302</li>
					<ul><li><b>Manslaughter</b></li>
						<li><b>Description:</b> To kill someone, usually unintentionally, without malice or forethought.</li>
						<li><b>Notes:</b> This includes causing death due to negligence, dereliction of duty, or stupidity. Stopping someone trying to escape from a deadly situation also counts towards this (if they die) unless your action can be argued to have protected more lives than inaction. For example, bolting an airlock to a room that's on fire while two people are trying to escape is considered manslaughter ''unless'' bolting that specific door means you've just saved three people on the other side from being incinerated. Manslaughter can also be used as punishment for excessive self-defense that unintentionally results in death.</li>
						<li><b>Default Sentence:</b> Dismissal until judgement.</li>
						<li><b>Chosen by Tribunal:</b> 40 minutes. Possible suspension at the discretion of CentCom.</li><br>
					</ul>
					<li>&sect;303</li>
					<ul><li><b>Mutiny</b></li>
						<li><b>Description:</b> To openly rebel against or attempt to remove command staff with violent intent to remove the command staff from power.</li>
						<li><b>Notes:</b> Motive is important. If someone is just angry at a head of staff and murders them in a fit of rage, that's just regular murder. On the other hand, trying to take over the station through violent means, lethal or not, is mutiny. See <b>Sedition (&sect;211)</b> for less violent mutineers.</li>
						<li><b>Default Sentence:</b> Holding until judgment.</li>
						<li><b>Chosen by Tribunal:</b> Hold until transfer. Permanent removal from the station.</li><br>
					</ul>
					<li>&sect;304</li>
					<ul><li><b>Terrorism</b></li>
						<li><b>Description:</b> To engage in maliciously destructive actions, which seriously threaten the crew or station.</li>
						<li><b>Notes:</b> This includes deliberate arson, hostage taking, use of bombs, release of singularity, etc. In cases of terrorism, Central Command must be informed.</li>
						<li><b>Default Sentence:</b> Holding until judgment.</li>
						<li><b>Chosen by Tribunal:</b> Hold until transfer. Permanent removal from the station by way of execution.</li><br>
					</ul>
					<li>&sect;305</li>
					<ul><li><b>Assaulting a Head of Staff</b></li>
						<li><b>Description:</b> To assault a Head of Staff, causing severe damage.</li>
						<li><b>Notes:</b> Exactly like <b>Assault (&sect;208)</b> but against a Head of Staff.</li>
						<li><b>Default Sentence:</b> 30 minutes, tracking implant.</li>
						<li><b>Chosen by Tribunal:</b> Hold until transfer. Permanent removal from the station.</li><br>
					</ul>
					<li>&sect;306</li>
					<ul><li><b>Escaping From HuT Sentence</b></li>
						<li><b>Description:</b> To attempt or successfully escape from the brig or other holding area when serving a holding until transfer sentence.</li>
						<li><b>Notes:</b> A sentence of Holding until Transfer must already be valid by way of tribunal for this to be valid. Escaping while being held for judgement does not count.</li>
						<li><b>Default Sentence:</b> Permanent removal from the station by way of kill or capture. If captured, put into solitary confinement until transfer.</li>
						<li><b>Chosen by Tribunal:</b> N/A</li><br>
					</ul>
					<li>&sect;307</li>
					<ul><li><b>Terrorist Collaboration</b></li>
						<li><b>Description:</b> To act as an agent of a terrorist or anti-Corporation group.</li>
						<li><b>Notes:</b> Espionage, disclosure of corporate secrets, or any other assistance rendered to outside hostile organizations, or their representatives in hostile activities to the Corporation, committed by a employee of Corporation. As a high crime, suspected terrorist agents must be put through a tribunal unless their level of resistance renders capture efforts infeasible.</li>
						<li><b>Default Sentence:</b> Holding until judgment.</li>
						<li><b>Chosen by Tribunal:</b> Hold until transfer. Permanent removal from the station by way of execution.</li><br>
					</ul>
					<li>&sect;308</li>
					<ul><li><b>Sexual Assault</b></li>
						<li><b>Description:</b> To assault, or attempt to assault, someone else sexually, including rape.</li>
						<li><b>Notes:</b> If the victim dies because of it, add <b>Murder (&sect;301)</b>.<br><i>(( Ignoring OOC complaints about an unwanted vore/erotic roleplay is a ban-worthy offense. Admin-help it if this happens to you. It's against server rules, not just station rules. ))</i></li>
						<li><b>Default Sentence:</b> 30 minutes, tracking implant.</li>
						<li><b>Chosen by Tribunal:</b> Hold until transfer. Permanent removal from the station.</li><br>
					</ul>
					<li>&sect;309</li>
					<ul><li><b>Wrongful Execution</b></li>
						<li><b>Description:</b> To execute a crew member who later turned out to be innocent.</li>
						<li><b>Notes:</b> This only counts when a tribunal was held and the order was given to execute someone based on faulty or poor evidence that is later debunked by additional evidence. If the tribunal process is skipped, or is ordered by an unauthorized party such as the Head of Security or an Acting Colony Director, then <b>Murder (&sect;301)</b> is added to the charges. Any individuals who deliberately produced false evidence are also to be charged with murder. Those who unintentionally provided incorrect evidence are charged with manslaughter. It is also required to contact CentCom if an unlawful execution occurs.</li>
						<li><b>Default Sentence:</b> Dismissal. Possible suspension at the discretion of CentCom.
						<li><b>Chosen by Tribunal:</b> N/A</li><br>
					</ul>
				</ul>
				<hr>
				<h1>Special Infractions</h1>

				These Infractions do not fit into any other category, as their sentences vary greatly from case-to-case.<BR><BR>
				<hr>
				<h2>Special Infractions List:</h2>
				<ul>
					<li>&sect;401</li>
					<ul><li><b>Inducement</b></li>
						<li><b>Description:</b> To intentionally provoke, bribe, trick, or incite a crew member to commit a crime they otherwise would not have with the intention of getting them arrested.</li>
						<li><b>Notes:</b> Examples include (but are not limited to) a security officer acting in an unprofessional manner and then attempting to press "harassment" charges on a crew member that lose their temper at such treatment, bribing an engineer to break into a place and retrieve objects, tricking a crew member into attacking another crew member, or simply provoking a crew member until they attack just to claim self defense afterwards. Likewise, security officers that threaten suspects with physical violence who then try to charge them with resisting arrest when they flee or fight back. The rule of thumb is that if the suspect would not have committed the crime were it not for another crew member's involvement or escalation, then the act is liable to count as inducement.</li>
						<li><b>Suggested Penalty:</b> Up to equal punishment with the crime that was or would have been committed.</li><br>
					</ul>
					<li>&sect;402</li>
					<ul><li><b>Piracy</b></li>
						<li><b>Description:</b> To rob a visiting vessel of goods and/or injure its crew while aboard said vessel.</li>
						<li><b>Notes:</b> NanoTrasen, although not the official governing body in this region of space, is required to punish acts of piracy in accordance to Admiralty law.</li>
						<li><b>Suggested Penalty:</b> In addition to the same charges you'd normally give for a criminal act against the station or its crew, a fax must also be sent to Central Command, who will review the infraction to determine further punishment, up to and including termination of the offending employee's contract.</li><br>
					</ul>
					<li>&sect;403</li>
					<ul><li><b>Slavery</b></li>
						<li><b>Description:</b> Keeping a sentient being in detainment without proper remuneration or appreciation for services rendered.</li>
						<li><b>Notes:</b> Consult Admiralty law for more details. It is being noted here to warn against ''forcing'' prisoners to participate in community service, as community service is meant to be optional. Changing the terms of a community service sentence without prior agreement with the prisoner, thus keeping them in confinement, is also slavery.</li>
						<li><b>Suggested Penalty:</b> Demotion. Furthermore, a fax must also be sent to Central Command, who will review the infraction to determine further punishment, up to and including termination of the offending employee's contract.</li><br>
					</ul>
				</ul>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the NanoTrasen Corporate Regulations at the time of its publication. Standing policy is that the most recent amendments to Corporate Regulations are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}

/obj/item/book/manual/legal/cr_vol5
	name = "Corporate Regulations Volume 5: Supplementals"
	icon_state = "corpreg_se"
	author = "NanoTrasen"
	title = "Corporate Regulations Volume 5: Supplementals"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Modifiers & Special Situations</h1>

				These may reduce or increase your sentence depending on circumstances relating to the crimes committed.<BR><BR>
				<hr>
				<h2>Modifiers List</h2>
				<ul>
					<ul><li><b>Community Service</b></li>
						<li><b>Description:</b> At the discretion of the arresting officer, the Warden, the Head of Security, or the Colony Director, community service may be offered as an alternative to standard penalties ''excluding'' psychiatric evaluations or holding until judgement/transfer. If a prisoner elects to carry out the offered task(s) assigned to them, then the normal punishment is waived, including any fines. Bare in mind, there is no specific limit on what may be appropriate for community service, but it should <u>always</u> be optional. Officers who offer something ''too'' punitive shouldn't be surprised if prisoners just elect to complete their original sentence rather than to participate in an even more punishing form of community service.</li>
						<li><b>Effect:</b> Up to and including immediate release.</li><br>
					</ul>
						<li><b>Cooperation with prosecution or security</b></li>
						<li><b>Description:</b> Being helpful to the members of security, revealing things during questioning or providing names of accomplices.</li>
						<li><b>Effect:</b> Up to -25%. In the case of revealing accomplices, up to -50%.</li><br>
					</ul>
					<ul><li><b>Entrapment</b></li>
						<li><b>Description:</b> To have been criminally charged with a crime that the defendant was induced to commit by another crew member, which the defendant otherwise would not (or could not) have committed it otherwise. See <b>Inducement (&sect;401)</b> above for more details.</li>
						<li><b>Effect:</b> Relevant charges reduced or dropped.</li><br>
					</ul>
					<ul><li><b>Falsely charged</b></li>
						<li><b>Description:</b> To be improperly charged with violations of corporate regulations wherein reasonable doubt is cast upon the charges by other security staff, their superiors, or an Internal Affairs Agent (usually after consulting Central Command). One example is Security arresting someone for Sabotage after knocking out a wall, but the Chief Engineer had issued the suspect a written demolition permit to knock out that exact wall. A more obvious example is just giving clearly invalid charges to a suspect, such as charging someone with Grand Theft but there is no evidence that anything was stolen.</li>
						<li><b>Effect:</b> Up to and including immediate release. Possible disciplinary action against security staff who are directly responsible. See also <b>Violation of Employee Rights, (§123)</b> and <b>Illegal Detention, Arrest, or Holding (§205)</b>.</li><br>
					</ul>
					<ul><li><b>Immediate threat to the prisoner</b></li>
						<li><b>Description:</b> The singularity eats something near the brig, an explosion goes off, etc.</li>
						<li><b>Effect:</b> Officer must relocate the prisoner(s) to a safe location. Otherwise, immediate release. HuJ and HuT sentences must be reapplied after danger has passed.</li><br>
					<ul>
					<ul><li><b>Medical reasons</b></li>
						<li><b>Description:</b> Prisoners are entitled to medical attention if sick or injured.</li>
						<li><b>Effect:</b> Medical personnel can be called, or the prisoner can be escorted to the Medbay. The time spent away from the brig still counts toward the sentence duration.</li><br>
					</ul>
					<ul><li><b>Privacy Violated</b></li>
						<li><b>Description:</b> To have been criminally charged where evidence against you was gathered through illegal means. This includes the use of thermals/xray, unwarranted searches, or any other such violation of privacy. For instance, if a security officer trumps up a vandalism charge as an excuse to search someone, even if that crew member ''is'' in possession of contraband, the contraband goods may be inadmissible as evidence given that the search was illegal.</li>
						<li><b>Effect:</b> Relevant charges reduced or dropped.</li><br>
					</ul>
					<ul><li><b>Repeat Offenders</b></li>
						<li><b>Description:</b> Some people just don't get it and immediately start causing problems again when released. This only applies for repeat offenses of ''the same offense''. This way, even if the person is just doing something minor that's only worth a 2 minute sentence, then that 2 minutes becomes 4, then the next time 4 becomes 8, then 8 becomes 16, and so on until you pass 90 minutes, at which point they are automatically held until judgment. Note that if they make an unrelated offense, it doesn't count toward this. You can't double a sentence for stealing because the same individual was caught vandalizing earlier. That's not how repeat offenses work. That's a different offense entirely.</li>
						<li><b>Effect:</b> For the first repeat of an offense, apply the "additional penalties" excluding execution/demotion, which must be authorized by the relevant head(s) of staff. For repeat offenses beyond that, multiply the prior sentence by 2. Ergo, 10 minutes becomes 20, then 20 becomes 40, and so on until more 90 minutes or more is accumulated. At that point, it's automatically HuT.</li><br>
					</ul>
					<ul><li><b>Self Defense</b></li>
						<li><b>Description:</b> Assault and even homicide can be justified if it was in direct response to imminent peril (or at least the reasonable belief that one exists). For this to be considered valid, there must at least be an ''attempt'' to retreat from the threat. Self defense can only be used when retreat is no longer possible.</li>
						<li><b>Effect:</b> Up to and including immediate release.</li><br>
					</ul>
					<ul><li><b>Surrender</b></li>
						<li><b>Description:</b> Coming to the brig, confessing what you've done and taking the punishment. Getting arrested without putting a fuss is not surrender. For this, you have to actually come to the brig yourself.</li>
						<li><b>Effect:</b> Up to -25%, and should be taken into account when determining the severity of crimes.</li><br>
					</ul>
					<ul><li><b>Victim of Willfull Peril</b></li>
						<li><b>Description:</b> Some individuals may offer themselves to science or indulge in dangerous thrills that, while not inherently suicidal (meaning they ''want'' to be cloned), nor dangerous to other members of the crew, are their own fault none the less. If the victim of an assault, manslaughter, or even murder charge is reasonably believed to have willfully and deliberately allowed themselves to be harmed, then this should be taken into account when dealing with the suspect. If this is later proven false by hard evidence, the original charges may be re-applied later.<br><i>(( For the purposes of the server, this is here to say willing vore isn't a crime. ''Unwilling'' vore still is. It's more interesting if there's some risk to being predator, and more immersive if predators actually make efforts to evade security. ))</i></li>
						<li><b>Effect:</b> Up to and including immediate release.</li><br>
					</ul>
				</ul>
				<hr>
				<h2>Juvenile Infractions</h2>

				These infractions carry substandard punishment of no more than 5 minutes detention and 100 Thalers, as they were once included for tightly-run stations but quickly fell ignored due to their vague content and alphabetical section header. <small>(If an infraction has a V, you know what it's for.)</small> Some interpretations of these laws may call for a 'search' or a 'minor punishment' that is so loosely defined it has to be an employee violation somewhere, but maybe that's the point. There's a large number of these that have been swapped in and out of officiality over the years and may be subject to abuse and miscommunication. Listed below are some printed examples in the index of the old version of Corporate Regulations, in case your nosy HoS asks.<BR><BR>

				The <b>Maximum Sentence</b> can be requested from the Head of Security, Colony Director, or (Acting Colony Director), though why you would do this over a few Thalers is beyond NanoTrasen's caring capacity.<BR><BR>

				<i>(This is obviously a scene law to be abused by security to initiate scenes. If you seriously bust someone's balls over this for non-scene reasons we will jobban you. If they are not interested, just give them a warning. Don't push it, buddy.)</i><BR><BR>
				<i>(This goes for HoS too, no demoting people for obvious scenes as this is scene-breaking.)</i><BR><BR>
				<hr>
				<h2>Infractions List</h2>
				<ul>
					<li>§V.001.1</li>
					<ul><li><b>Loitering</b></li>
						<li><b>Description:</b> Taking up space in such a manner that is disruptive, irritating, asymmetrical or generally disrupts the decorum of the occupied space.</li>
						<li><b>Notes:</b>Access is not a factor in loitering. Any unnecessary standing, sitting, leaning, posing, face-making, and moonwalking should be handled with the upmost severity.</li>
						<li><b>Suggested Penalty:</b> 2 minutes.</li>
						<li><b>Maximum:</b> Up to 5 minutes</li>
						<li><b>Fine:</b> 20 Thalers</li><br>
					</ul>
					<li>§V.004.2</li>
					<ul><li><b>Excessive Skimpiness</b></li>
						<li><b>Description:</b> Wearing clothing or possessing fur that is alluring and distracting for at least 3 core races. This includes miniskirts, pasties, #1 fur cut depths on erogenous zones, rave gear, combat boots, unlit cigarettes on lips larger than 1 cubic centimeter, holding the Corporate Regulations over one's groin...</li>
						<li><b>Notes:</b>It goes on a while.</li>
						<li><b>Suggested Penalty:</b>Slap on the <s>rear</s> wrist</li>
						<li><b>Maximum:</b> Up to 3 minutes</li>
						<li><b>Fine:</b> 10 Thalers</li><br>
					</ul>
					<li>§V.008.9</li>
					<ul><li><b>Recycling Incorrectly</b></li>
						<li><b>Description:</b> To place any physical or gaseous material in any container that is not considered 'reusable' in one of the 7 coded 'reusable containers'</li>
						<li><b>Notes:</b>Usable containers are listed on page 947 of the "Corporate Regulations Unchained" supplementary material available in the library for 100 Thalers</li>
						<li><b>Suggested Penalty:</b> Trash detail</li>
						<li><b>Maximum:</b> Up to 5 minutes</li>
						<li><b>Fine:</b> 50 Thalers</li><br>
					</ul>
					<li>§V.009.7</li>
					<ul><li><b>Staring at Fluorescent Lighting Without A License</b></li>
						<li><b>Description:</b> Staring at fluorescent lighting without a license is dangerous for several crewmembers, often resulting in time wasted eye-rubbing and lolligagging (See §V.001.1)</li>
						<li><b>Notes:</b>Mothmen may acquire a license free of charge from security at any time.</li>
						<li><b>Suggested Penalty:</b> Circadian Recalibration with a 'dark room'</li>
						<li><b>Maximum:</b> Forced application of Welding Goggles</li>
						<li><b>Fine:</b> 10 Thalers</li><br>
					</ul>
				</ul>
				<i>*(The above table is merely a few examples to get your brain turning. Feel free to use your imagination and 'expand' the regulations. Nobody's going to care to look up juvenile infractions. There's no shame in being creative or communicative with your partner!)</i><BR><BR>
				<hr>
				<I><center><small><b>DISCLAIMER:</b> The above document is the most modern representation of the NanoTrasen Corporate Regulations at the time of its publication. Standing policy is that the most recent amendments to Corporate Regulations are the most legally valid. Therefore, in the event that this volume, or any affiliate, conflicts with the most up to date doctrine, the relevant information contained in this volume, or any affiliate, is considered void in the face of the most up to date procedure.</small></center></I>

				</body>
			</html>
			"}
