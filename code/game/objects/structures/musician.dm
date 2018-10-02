<<<<<<< HEAD
//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/datum/song
	var/name = "Untitled"
	var/list/lines = new()
	var/tempo = 5

/obj/structure/device/piano
	name = "space minimoog"
	icon = 'icons/obj/musician.dmi'
	icon_state = "minimoog"
	anchored = 1
	density = 1
	var/datum/song/song
	var/playing = 0
	var/help = 0
	var/edit = 1
	var/repeat = 0

/obj/structure/device/piano/New()
	if(prob(50))
		name = "space minimoog"
		desc = "This is a minimoog, like a space piano, but more spacey!"
		icon_state = "minimoog"
	else
		name = "space piano"
		desc = "This is a space piano, like a regular piano, but always in tune! Even if the musician isn't."
		icon_state = "piano"

/obj/structure/device/piano/verb/rotate()
	set name = "Rotate Piano"
	set category = "Object"
	set src in oview(1)

	if(istype(usr,/mob/living/simple_animal/mouse))
		return
	else if(!usr || !isturf(usr.loc))
		return
	else if(usr.stat || usr.restrained())
		return
	else if (istype(usr,/mob/observer/ghost) && !config.ghost_interaction)
		return
	else
		src.set_dir(turn(src.dir, 90))
		return

/obj/structure/device/piano/proc/playnote(var/note as text)
	//world << "Note: [note]"
	var/soundfile
	/*BYOND loads resource files at compile time if they are ''. This means you can't really manipulate them dynamically.
	Tried doing it dynamically at first but its more trouble than its worth. Would have saved many lines tho.*/
	switch(note)
		if("Cn1")	soundfile = 'sound/piano/Cn1.ogg'
		if("C#1")	soundfile = 'sound/piano/C#1.ogg'
		if("Db1")	soundfile = 'sound/piano/Db1.ogg'
		if("Dn1")	soundfile = 'sound/piano/Dn1.ogg'
		if("D#1")	soundfile = 'sound/piano/D#1.ogg'
		if("Eb1")	soundfile = 'sound/piano/Eb1.ogg'
		if("En1")	soundfile = 'sound/piano/En1.ogg'
		if("E#1")	soundfile = 'sound/piano/E#1.ogg'
		if("Fb1")	soundfile = 'sound/piano/Fb1.ogg'
		if("Fn1")	soundfile = 'sound/piano/Fn1.ogg'
		if("F#1")	soundfile = 'sound/piano/F#1.ogg'
		if("Gb1")	soundfile = 'sound/piano/Gb1.ogg'
		if("Gn1")	soundfile = 'sound/piano/Gn1.ogg'
		if("G#1")	soundfile = 'sound/piano/G#1.ogg'
		if("Ab1")	soundfile = 'sound/piano/Ab1.ogg'
		if("An1")	soundfile = 'sound/piano/An1.ogg'
		if("A#1")	soundfile = 'sound/piano/A#1.ogg'
		if("Bb1")	soundfile = 'sound/piano/Bb1.ogg'
		if("Bn1")	soundfile = 'sound/piano/Bn1.ogg'
		if("B#1")	soundfile = 'sound/piano/B#1.ogg'
		if("Cb2")	soundfile = 'sound/piano/Cb2.ogg'
		if("Cn2")	soundfile = 'sound/piano/Cn2.ogg'
		if("C#2")	soundfile = 'sound/piano/C#2.ogg'
		if("Db2")	soundfile = 'sound/piano/Db2.ogg'
		if("Dn2")	soundfile = 'sound/piano/Dn2.ogg'
		if("D#2")	soundfile = 'sound/piano/D#2.ogg'
		if("Eb2")	soundfile = 'sound/piano/Eb2.ogg'
		if("En2")	soundfile = 'sound/piano/En2.ogg'
		if("E#2")	soundfile = 'sound/piano/E#2.ogg'
		if("Fb2")	soundfile = 'sound/piano/Fb2.ogg'
		if("Fn2")	soundfile = 'sound/piano/Fn2.ogg'
		if("F#2")	soundfile = 'sound/piano/F#2.ogg'
		if("Gb2")	soundfile = 'sound/piano/Gb2.ogg'
		if("Gn2")	soundfile = 'sound/piano/Gn2.ogg'
		if("G#2")	soundfile = 'sound/piano/G#2.ogg'
		if("Ab2")	soundfile = 'sound/piano/Ab2.ogg'
		if("An2")	soundfile = 'sound/piano/An2.ogg'
		if("A#2")	soundfile = 'sound/piano/A#2.ogg'
		if("Bb2")	soundfile = 'sound/piano/Bb2.ogg'
		if("Bn2")	soundfile = 'sound/piano/Bn2.ogg'
		if("B#2")	soundfile = 'sound/piano/B#2.ogg'
		if("Cb3")	soundfile = 'sound/piano/Cb3.ogg'
		if("Cn3")	soundfile = 'sound/piano/Cn3.ogg'
		if("C#3")	soundfile = 'sound/piano/C#3.ogg'
		if("Db3")	soundfile = 'sound/piano/Db3.ogg'
		if("Dn3")	soundfile = 'sound/piano/Dn3.ogg'
		if("D#3")	soundfile = 'sound/piano/D#3.ogg'
		if("Eb3")	soundfile = 'sound/piano/Eb3.ogg'
		if("En3")	soundfile = 'sound/piano/En3.ogg'
		if("E#3")	soundfile = 'sound/piano/E#3.ogg'
		if("Fb3")	soundfile = 'sound/piano/Fb3.ogg'
		if("Fn3")	soundfile = 'sound/piano/Fn3.ogg'
		if("F#3")	soundfile = 'sound/piano/F#3.ogg'
		if("Gb3")	soundfile = 'sound/piano/Gb3.ogg'
		if("Gn3")	soundfile = 'sound/piano/Gn3.ogg'
		if("G#3")	soundfile = 'sound/piano/G#3.ogg'
		if("Ab3")	soundfile = 'sound/piano/Ab3.ogg'
		if("An3")	soundfile = 'sound/piano/An3.ogg'
		if("A#3")	soundfile = 'sound/piano/A#3.ogg'
		if("Bb3")	soundfile = 'sound/piano/Bb3.ogg'
		if("Bn3")	soundfile = 'sound/piano/Bn3.ogg'
		if("B#3")	soundfile = 'sound/piano/B#3.ogg'
		if("Cb4")	soundfile = 'sound/piano/Cb4.ogg'
		if("Cn4")	soundfile = 'sound/piano/Cn4.ogg'
		if("C#4")	soundfile = 'sound/piano/C#4.ogg'
		if("Db4")	soundfile = 'sound/piano/Db4.ogg'
		if("Dn4")	soundfile = 'sound/piano/Dn4.ogg'
		if("D#4")	soundfile = 'sound/piano/D#4.ogg'
		if("Eb4")	soundfile = 'sound/piano/Eb4.ogg'
		if("En4")	soundfile = 'sound/piano/En4.ogg'
		if("E#4")	soundfile = 'sound/piano/E#4.ogg'
		if("Fb4")	soundfile = 'sound/piano/Fb4.ogg'
		if("Fn4")	soundfile = 'sound/piano/Fn4.ogg'
		if("F#4")	soundfile = 'sound/piano/F#4.ogg'
		if("Gb4")	soundfile = 'sound/piano/Gb4.ogg'
		if("Gn4")	soundfile = 'sound/piano/Gn4.ogg'
		if("G#4")	soundfile = 'sound/piano/G#4.ogg'
		if("Ab4")	soundfile = 'sound/piano/Ab4.ogg'
		if("An4")	soundfile = 'sound/piano/An4.ogg'
		if("A#4")	soundfile = 'sound/piano/A#4.ogg'
		if("Bb4")	soundfile = 'sound/piano/Bb4.ogg'
		if("Bn4")	soundfile = 'sound/piano/Bn4.ogg'
		if("B#4")	soundfile = 'sound/piano/B#4.ogg'
		if("Cb5")	soundfile = 'sound/piano/Cb5.ogg'
		if("Cn5")	soundfile = 'sound/piano/Cn5.ogg'
		if("C#5")	soundfile = 'sound/piano/C#5.ogg'
		if("Db5")	soundfile = 'sound/piano/Db5.ogg'
		if("Dn5")	soundfile = 'sound/piano/Dn5.ogg'
		if("D#5")	soundfile = 'sound/piano/D#5.ogg'
		if("Eb5")	soundfile = 'sound/piano/Eb5.ogg'
		if("En5")	soundfile = 'sound/piano/En5.ogg'
		if("E#5")	soundfile = 'sound/piano/E#5.ogg'
		if("Fb5")	soundfile = 'sound/piano/Fb5.ogg'
		if("Fn5")	soundfile = 'sound/piano/Fn5.ogg'
		if("F#5")	soundfile = 'sound/piano/F#5.ogg'
		if("Gb5")	soundfile = 'sound/piano/Gb5.ogg'
		if("Gn5")	soundfile = 'sound/piano/Gn5.ogg'
		if("G#5")	soundfile = 'sound/piano/G#5.ogg'
		if("Ab5")	soundfile = 'sound/piano/Ab5.ogg'
		if("An5")	soundfile = 'sound/piano/An5.ogg'
		if("A#5")	soundfile = 'sound/piano/A#5.ogg'
		if("Bb5")	soundfile = 'sound/piano/Bb5.ogg'
		if("Bn5")	soundfile = 'sound/piano/Bn5.ogg'
		if("B#5")	soundfile = 'sound/piano/B#5.ogg'
		if("Cb6")	soundfile = 'sound/piano/Cb6.ogg'
		if("Cn6")	soundfile = 'sound/piano/Cn6.ogg'
		if("C#6")	soundfile = 'sound/piano/C#6.ogg'
		if("Db6")	soundfile = 'sound/piano/Db6.ogg'
		if("Dn6")	soundfile = 'sound/piano/Dn6.ogg'
		if("D#6")	soundfile = 'sound/piano/D#6.ogg'
		if("Eb6")	soundfile = 'sound/piano/Eb6.ogg'
		if("En6")	soundfile = 'sound/piano/En6.ogg'
		if("E#6")	soundfile = 'sound/piano/E#6.ogg'
		if("Fb6")	soundfile = 'sound/piano/Fb6.ogg'
		if("Fn6")	soundfile = 'sound/piano/Fn6.ogg'
		if("F#6")	soundfile = 'sound/piano/F#6.ogg'
		if("Gb6")	soundfile = 'sound/piano/Gb6.ogg'
		if("Gn6")	soundfile = 'sound/piano/Gn6.ogg'
		if("G#6")	soundfile = 'sound/piano/G#6.ogg'
		if("Ab6")	soundfile = 'sound/piano/Ab6.ogg'
		if("An6")	soundfile = 'sound/piano/An6.ogg'
		if("A#6")	soundfile = 'sound/piano/A#6.ogg'
		if("Bb6")	soundfile = 'sound/piano/Bb6.ogg'
		if("Bn6")	soundfile = 'sound/piano/Bn6.ogg'
		if("B#6")	soundfile = 'sound/piano/B#6.ogg'
		if("Cb7")	soundfile = 'sound/piano/Cb7.ogg'
		if("Cn7")	soundfile = 'sound/piano/Cn7.ogg'
		if("C#7")	soundfile = 'sound/piano/C#7.ogg'
		if("Db7")	soundfile = 'sound/piano/Db7.ogg'
		if("Dn7")	soundfile = 'sound/piano/Dn7.ogg'
		if("D#7")	soundfile = 'sound/piano/D#7.ogg'
		if("Eb7")	soundfile = 'sound/piano/Eb7.ogg'
		if("En7")	soundfile = 'sound/piano/En7.ogg'
		if("E#7")	soundfile = 'sound/piano/E#7.ogg'
		if("Fb7")	soundfile = 'sound/piano/Fb7.ogg'
		if("Fn7")	soundfile = 'sound/piano/Fn7.ogg'
		if("F#7")	soundfile = 'sound/piano/F#7.ogg'
		if("Gb7")	soundfile = 'sound/piano/Gb7.ogg'
		if("Gn7")	soundfile = 'sound/piano/Gn7.ogg'
		if("G#7")	soundfile = 'sound/piano/G#7.ogg'
		if("Ab7")	soundfile = 'sound/piano/Ab7.ogg'
		if("An7")	soundfile = 'sound/piano/An7.ogg'
		if("A#7")	soundfile = 'sound/piano/A#7.ogg'
		if("Bb7")	soundfile = 'sound/piano/Bb7.ogg'
		if("Bn7")	soundfile = 'sound/piano/Bn7.ogg'
		if("B#7")	soundfile = 'sound/piano/B#7.ogg'
		if("Cb8")	soundfile = 'sound/piano/Cb8.ogg'
		if("Cn8")	soundfile = 'sound/piano/Cn8.ogg'
		if("C#8")	soundfile = 'sound/piano/C#8.ogg'
		if("Db8")	soundfile = 'sound/piano/Db8.ogg'
		if("Dn8")	soundfile = 'sound/piano/Dn8.ogg'
		if("D#8")	soundfile = 'sound/piano/D#8.ogg'
		if("Eb8")	soundfile = 'sound/piano/Eb8.ogg'
		if("En8")	soundfile = 'sound/piano/En8.ogg'
		if("E#8")	soundfile = 'sound/piano/E#8.ogg'
		if("Fb8")	soundfile = 'sound/piano/Fb8.ogg'
		if("Fn8")	soundfile = 'sound/piano/Fn8.ogg'
		if("F#8")	soundfile = 'sound/piano/F#8.ogg'
		if("Gb8")	soundfile = 'sound/piano/Gb8.ogg'
		if("Gn8")	soundfile = 'sound/piano/Gn8.ogg'
		if("G#8")	soundfile = 'sound/piano/G#8.ogg'
		if("Ab8")	soundfile = 'sound/piano/Ab8.ogg'
		if("An8")	soundfile = 'sound/piano/An8.ogg'
		if("A#8")	soundfile = 'sound/piano/A#8.ogg'
		if("Bb8")	soundfile = 'sound/piano/Bb8.ogg'
		if("Bn8")	soundfile = 'sound/piano/Bn8.ogg'
		if("B#8")	soundfile = 'sound/piano/B#8.ogg'
		if("Cb9")	soundfile = 'sound/piano/Cb9.ogg'
		if("Cn9")	soundfile = 'sound/piano/Cn9.ogg'
		else		return

	//hearers(15, src) << sound(soundfile)
	var/turf/source = get_turf(src)
	for(var/mob/M in hearers(15, source))
		M.playsound_local(source, file(soundfile), 100, falloff = 5)


/obj/structure/device/piano/proc/playsong()
	do
		var/cur_oct[7]
		var/cur_acc[7]
		for(var/i = 1 to 7)
			cur_oct[i] = "3"
			cur_acc[i] = "n"

		for(var/line in song.lines)
			//world << line
			for(var/beat in splittext(lowertext(line), ","))
				//world << "beat: [beat]"
				var/list/notes = splittext(beat, "/")
				for(var/note in splittext(notes[1], "-"))
					//world << "note: [note]"
					if(!playing || !anchored)//If the piano is playing, or is loose
						playing = 0
						return
					if(lentext(note) == 0)
						continue
					//world << "Parse: [copytext(note,1,2)]"
					var/cur_note = text2ascii(note) - 96
					if(cur_note < 1 || cur_note > 7)
						continue
					for(var/i=2 to lentext(note))
						var/ni = copytext(note,i,i+1)
						if(!text2num(ni))
							if(ni == "#" || ni == "b" || ni == "n")
								cur_acc[cur_note] = ni
							else if(ni == "s")
								cur_acc[cur_note] = "#" // so shift is never required
						else
							cur_oct[cur_note] = ni
					playnote(uppertext(copytext(note,1,2)) + cur_acc[cur_note] + cur_oct[cur_note])
				if(notes.len >= 2 && text2num(notes[2]))
					sleep(song.tempo / text2num(notes[2]))
				else
					sleep(song.tempo)
		if(repeat > 0)
			repeat-- //Infinite loops are baaaad.
	while(repeat > 0)
	playing = 0
	updateUsrDialog()

/obj/structure/device/piano/attack_hand(var/mob/user as mob)
	if(!anchored)
		return

	usr.machine = src
	var/dat = "<HEAD><TITLE>Piano</TITLE></HEAD><BODY>"

	if(song)
		if(song.lines.len > 0 && !(playing))
			dat += "<A href='?src=\ref[src];play=1'>Play Song</A><BR><BR>"
			dat += "<A href='?src=\ref[src];repeat=1'>Repeat Song: [repeat] times.</A><BR><BR>"
		if(playing)
			dat += "<A href='?src=\ref[src];stop=1'>Stop Playing</A><BR>"
			dat += "Repeats left: [repeat].<BR><BR>"
	if(!edit)
		dat += "<A href='?src=\ref[src];edit=2'>Show Editor</A><BR><BR>"
	else
		dat += "<A href='?src=\ref[src];edit=1'>Hide Editor</A><BR>"
		dat += "<A href='?src=\ref[src];newsong=1'>Start a New Song</A><BR>"
		dat += "<A href='?src=\ref[src];import=1'>Import a Song</A><BR><BR>"
		if(song)
			var/calctempo = (10/song.tempo)*60
			dat += "Tempo : <A href='?src=\ref[src];tempo=10'>-</A><A href='?src=\ref[src];tempo=1'>-</A> [calctempo] BPM <A href='?src=\ref[src];tempo=-1'>+</A><A href='?src=\ref[src];tempo=-10'>+</A><BR><BR>"
			var/linecount = 0
			for(var/line in song.lines)
				linecount += 1
				dat += "Line [linecount]: [line] <A href='?src=\ref[src];deleteline=[linecount]'>Delete Line</A> <A href='?src=\ref[src];modifyline=[linecount]'>Modify Line</A><BR>"
			dat += "<A href='?src=\ref[src];newline=1'>Add Line</A><BR><BR>"
		if(help)
			dat += "<A href='?src=\ref[src];help=1'>Hide Help</A><BR>"
			dat += {"
					Lines are a series of chords, separated by commas (,), each with notes seperated by hyphens (-).<br>
					Every note in a chord will play together, with chord timed by the tempo.<br>
					<br>
					Notes are played by the names of the note, and optionally, the accidental, and/or the octave number.<br>
					By default, every note is natural and in octave 3. Defining otherwise is remembered for each note.<br>
					Example: <i>C,D,E,F,G,A,B</i> will play a C major scale.<br>
					After a note has an accidental placed, it will be remembered: <i>C,C4,C,C3</i> is <i>C3,C4,C4,C3</i><br>
					Chords can be played simply by seperating each note with a hyphon: <i>A-C#,Cn-E,E-G#,Gn-B</i><br>
					A pause may be denoted by an empty chord: <i>C,E,,C,G</i><br>
					To make a chord be a different time, end it with /x, where the chord length will be length<br>
					defined by tempo / x: <i>C,G/2,E/4</i><br>
					Combined, an example is: <i>E-E4/4,/2,G#/8,B/8,E3-E4/4</i>
					<br>
					Lines may be up to 50 characters.<br>
					A song may only contain up to 50 lines.<br>
					"}
		else
			dat += "<A href='?src=\ref[src];help=2'>Show Help</A><BR>"
	dat += "</BODY></HTML>"
	user << browse(dat, "window=piano;size=700x300")
	onclose(user, "piano")

/obj/structure/device/piano/Topic(href, href_list)

	if(!in_range(src, usr) || issilicon(usr) || !anchored || !usr.canmove || usr.restrained())
		usr << browse(null, "window=piano;size=700x300")
		onclose(usr, "piano")
		return

	if(href_list["newsong"])
		song = new()
	else if(song)
		if(href_list["repeat"]) //Changing this from a toggle to a number of repeats to avoid infinite loops.
			if(playing) return //So that people cant keep adding to repeat. If the do it intentionally, it could result in the server crashing.
			var/tempnum = input("How many times do you want to repeat this piece? (max:10)") as num|null
			if(tempnum > 10)
				tempnum = 10
			if(tempnum < 0)
				tempnum = 0
			repeat = round(tempnum)

		else if(href_list["tempo"])
			song.tempo += round(text2num(href_list["tempo"]))
			if(song.tempo < 1)
				song.tempo = 1

		else if(href_list["play"])
			if(song)
				playing = 1
				spawn() playsong()

		else if(href_list["newline"])
			var/newline = html_encode(input("Enter your line: ", "Piano") as text|null)
			if(!newline)
				return
			if(song.lines.len > 50)
				return
			if(lentext(newline) > 50)
				newline = copytext(newline, 1, 50)
			song.lines.Add(newline)

		else if(href_list["deleteline"])
			var/num = round(text2num(href_list["deleteline"]))
			if(num > song.lines.len || num < 1)
				return
			song.lines.Cut(num, num+1)

		else if(href_list["modifyline"])
			var/num = round(text2num(href_list["modifyline"]),1)
			var/content = html_encode(input("Enter your line: ", "Piano", song.lines[num]) as text|null)
			if(!content)
				return
			if(lentext(content) > 50)
				content = copytext(content, 1, 50)
			if(num > song.lines.len || num < 1)
				return
			song.lines[num] = content

		else if(href_list["stop"])
			playing = 0

		else if(href_list["help"])
			help = text2num(href_list["help"]) - 1

		else if(href_list["edit"])
			edit = text2num(href_list["edit"]) - 1

		else if(href_list["import"])
			var/t = ""
			do
				t = html_encode(input(usr, "Please paste the entire song, formatted:", text("[]", src.name), t)  as message)
				if (!in_range(src, usr))
					return

				if(lentext(t) >= 3072)
					var/cont = input(usr, "Your message is too long! Would you like to continue editing it?", "", "yes") in list("yes", "no")
					if(cont == "no")
						break
			while(lentext(t) > 3072)

			//split into lines
			spawn()
				var/list/lines = splittext(t, "\n")
				var/tempo = 5
				if(copytext(lines[1],1,6) == "BPM: ")
					tempo = 600 / text2num(copytext(lines[1],6))
					lines.Cut(1,2)
				if(lines.len > 50)
					usr << "Too many lines!"
					lines.Cut(51)
				var/linenum = 1
				for(var/l in lines)
					if(lentext(l) > 50)
						usr << "Line [linenum] too long!"
						lines.Remove(l)
					else
						linenum++
				song = new()
				song.lines = lines
				song.tempo = tempo
				updateUsrDialog()

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/structure/device/piano/attackby(obj/item/O as obj, mob/user as mob)
	if (istype(O, /obj/item/weapon/wrench))
		if (anchored)
			playsound(src.loc, O.usesound, 50, 1)
			user << "<span class='notice'>You begin to loosen \the [src]'s casters...</span>"
			if (do_after(user, 40 * O.toolspeed))
				user.visible_message( \
					"[user] loosens \the [src]'s casters.", \
					"<span class='notice'>You have loosened \the [src]. Now it can be pulled somewhere else.</span>", \
					"You hear ratchet.")
				src.anchored = 0
		else
			playsound(src.loc, O.usesound, 50, 1)
			user << "<span class='notice'>You begin to tighten \the [src] to the floor...</span>"
			if (do_after(user, 20 * O.toolspeed))
				user.visible_message( \
					"[user] tightens \the [src]'s casters.", \
					"<span class='notice'>You have tightened \the [src]'s casters. Now it can be played again</span>.", \
					"You hear ratchet.")
				src.anchored = 1
	else
		..()
=======
//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

#define MUSICIAN_HEARCHECK_MINDELAY 4
#define INSTRUMENT_MAX_LINE_LENGTH 300
#define INSTRUMENT_MAX_LINE_NUMBER 50

/datum/song
	var/name = "Untitled"
	var/list/lines = new()
	var/tempo = 5			// delay between notes

	var/playing = 0			// if we're playing
	var/help = 0			// if help is open
	var/edit = 1			// if we're in editing mode
	var/repeat = 0			// number of times remaining to repeat
	var/max_repeats = 10	// maximum times we can repeat

	var/instrumentDir = "piano"		// the folder with the sounds
	var/instrumentExt = "ogg"		// the file extension
	var/obj/instrumentObj = null	// the associated obj playing the sound
	var/last_hearcheck = 0
	var/list/hearing_mobs

/datum/song/New(dir, obj, ext = "ogg")
	instrumentDir = dir
	instrumentObj = obj
	instrumentExt = ext

/datum/song/Destroy()
	instrumentObj = null
	return ..()


// note is a number from 1-7 for A-G
// acc is either "b", "n", or "#"
// oct is 1-8 (or 9 for C)
/datum/song/proc/playnote(note, acc as text, oct)
	// handle accidental -> B<>C of E<>F
	if(acc == "b" && (note == 3 || note == 6)) // C or F
		if(note == 3)
			oct--
		note--
		acc = "n"
	else if(acc == "#" && (note == 2 || note == 5)) // B or E
		if(note == 2)
			oct++
		note++
		acc = "n"
	else if(acc == "#" && (note == 7)) //G#
		note = 1
		acc = "b"
	else if(acc == "#") // mass convert all sharps to flats, octave jump already handled
		acc = "b"
		note++

	// check octave, C is allowed to go to 9
	if(oct < 1 || (note == 3 ? oct > 9 : oct > 8))
		return

	// now generate name
	var/soundfile = "sound/instruments/[instrumentDir]/[ascii2text(note+64)][acc][oct].[instrumentExt]"
	soundfile = file(soundfile)
	// make sure the note exists
	if(!fexists(soundfile))
		return
	// and play
	var/turf/source = get_turf(instrumentObj)
	if((world.time - MUSICIAN_HEARCHECK_MINDELAY) > last_hearcheck)
		LAZYCLEARLIST(hearing_mobs)
		for(var/mob/M in hearers(15, source))
			if(!M.client || !(M.is_preference_enabled(/datum/client_preference/instrument_toggle)))
				continue
			LAZYSET(hearing_mobs, M, TRUE)
		last_hearcheck = world.time
	var/sound/music_played = sound(soundfile)
	for(var/i in hearing_mobs)
		var/mob/M = i
		M.playsound_local(source, null, 100, falloff = 5, S = music_played)

/datum/song/proc/updateDialog(mob/user)
	instrumentObj.updateDialog()		// assumes it's an object in world, override if otherwise

/datum/song/proc/shouldStopPlaying(mob/user)
	if(instrumentObj)
		if(!instrumentObj.Adjacent(user) || user.stat)
			return 1
		return !instrumentObj.anchored		// add special cases to stop in subclasses
	else
		return 1

/datum/song/proc/playsong(mob/user)
	while(repeat >= 0)
		var/cur_oct[7]
		var/cur_acc[7]
		for(var/i = 1 to 7)
			cur_oct[i] = 3
			cur_acc[i] = "n"

		for(var/line in lines)
			for(var/beat in splittext(lowertext(line), ","))
				var/list/notes = splittext(beat, "/")
				for(var/note in splittext(notes[1], "-"))
					if(!playing || shouldStopPlaying(user))//If the instrument is playing, or special case
						playing = 0
						return
					if(lentext(note) == 0)
						continue
					var/cur_note = text2ascii(note) - 96
					if(cur_note < 1 || cur_note > 7)
						continue
					for(var/i=2 to lentext(note))
						var/ni = copytext(note,i,i+1)
						if(!text2num(ni))
							if(ni == "#" || ni == "b" || ni == "n")
								cur_acc[cur_note] = ni
							else if(ni == "s")
								cur_acc[cur_note] = "#" // so shift is never required
						else
							cur_oct[cur_note] = text2num(ni)
					playnote(cur_note, cur_acc[cur_note], cur_oct[cur_note])
				if(notes.len >= 2 && text2num(notes[2]))
					sleep(sanitize_tempo(tempo / text2num(notes[2])))
				else
					sleep(tempo)
		repeat--
	playing = 0
	repeat = 0
	updateDialog(user)

/datum/song/proc/interact(mob/user)
	var/dat = ""
	if(lines.len > 0)
		dat += "<H3>Playback</H3>"
		if(!playing)
			dat += {"<A href='?src=\ref[src];play=1'>Play</A> <SPAN CLASS='linkOn'>Stop</SPAN><BR><BR>
				Repeat Song:
				[repeat > 0 ? "<A href='?src=\ref[src];repeat=-10'>-</A><A href='?src=\ref[src];repeat=-1'>-</A>" : "<SPAN CLASS='linkOff'>-</SPAN><SPAN CLASS='linkOff'>-</SPAN>"]
				 [repeat] times
				[repeat < max_repeats ? "<A href='?src=\ref[src];repeat=1'>+</A><A href='?src=\ref[src];repeat=10'>+</A>" : "<SPAN CLASS='linkOff'>+</SPAN><SPAN CLASS='linkOff'>+</SPAN>"]
				<BR>"}
		else
			dat += {"<SPAN CLASS='linkOn'>Play</SPAN> <A href='?src=\ref[src];stop=1'>Stop</A><BR>
				Repeats left: <B>[repeat]</B><BR>"}
	if(!edit)
		dat += "<BR><B><A href='?src=\ref[src];edit=2'>Show Editor</A></B><BR>"
	else
		var/bpm = round(600 / tempo)
		dat += {"<H3>Editing</H3>
			<B><A href='?src=\ref[src];edit=1'>Hide Editor</A></B>
			 <A href='?src=\ref[src];newsong=1'>Start a New Song</A>
			 <A href='?src=\ref[src];import=1'>Import a Song</A><BR><BR>
			Tempo: <A href='?src=\ref[src];tempo=[world.tick_lag]'>-</A> [bpm] BPM <A href='?src=\ref[src];tempo=-[world.tick_lag]'>+</A><BR><BR>"}
		var/linecount = 0
		for(var/line in lines)
			linecount += 1
			dat += "Line [linecount]: <A href='?src=\ref[src];modifyline=[linecount]'>Edit</A> <A href='?src=\ref[src];deleteline=[linecount]'>X</A> [line]<BR>"
		dat += "<A href='?src=\ref[src];newline=1'>Add Line</A><BR><BR>"
		if(help)
			dat += {"<B><A href='?src=\ref[src];help=1'>Hide Help</A></B><BR>
					Lines are a series of chords, separated by commas (,), each with notes seperated by hyphens (-).<br>
					Every note in a chord will play together, with chord timed by the tempo.<br>
					<br>
					Notes are played by the names of the note, and optionally, the accidental, and/or the octave number.<br>
					By default, every note is natural and in octave 3. Defining otherwise is remembered for each note.<br>
					Example: <i>C,D,E,F,G,A,B</i> will play a C major scale.<br>
					After a note has an accidental placed, it will be remembered: <i>C,C4,C,C3</i> is <i>C3,C4,C4,C3</i><br>
					Chords can be played simply by seperating each note with a hyphon: <i>A-C#,Cn-E,E-G#,Gn-B</i><br>
					A pause may be denoted by an empty chord: <i>C,E,,C,G</i><br>
					To make a chord be a different time, end it with /x, where the chord length will be length<br>
					defined by tempo / x: <i>C,G/2,E/4</i><br>
					Combined, an example is: <i>E-E4/4,F#/2,G#/8,B/8,E3-E4/4</i>
					<br>
					Lines may be up to 50 characters.<br>
					A song may only contain up to 50 lines.<br>
					"}
		else
			dat += "<B><A href='?src=\ref[src];help=2'>Show Help</A></B><BR>"
	var/datum/browser/popup = new(user, "instrument", instrumentObj.name, 700, 500)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(instrumentObj.icon, instrumentObj.icon_state))
	popup.open()

/datum/song/Topic(href, href_list)
	if(!instrumentObj.Adjacent(usr) || usr.stat)
		usr << browse(null, "window=instrument")
		usr.unset_machine()
		return
	instrumentObj.add_fingerprint(usr)
	if(href_list["newsong"])
		lines = new()
		tempo = sanitize_tempo(5) // default 120 BPM
		name = ""
	else if(href_list["import"])
		var/t = ""
		do
			t = html_encode(input(usr, "Please paste the entire song, formatted:", text("[]", name), t)  as message)
			if(!in_range(instrumentObj, usr))
				return
			if(lentext(t) >= INSTRUMENT_MAX_LINE_LENGTH*INSTRUMENT_MAX_LINE_NUMBER)
				var/cont = input(usr, "Your message is too long! Would you like to continue editing it?", "", "yes") in list("yes", "no")
				if(cont == "no")
					break
		while(lentext(t) > INSTRUMENT_MAX_LINE_LENGTH*INSTRUMENT_MAX_LINE_NUMBER)
		//split into lines
		spawn()
			lines = splittext(t, "\n")
			if(copytext(lines[1],1,6) == "BPM: ")
				tempo = sanitize_tempo(600 / text2num(copytext(lines[1],6)))
				lines.Cut(1,2)
			else
				tempo = sanitize_tempo(5) // default 120 BPM
			if(lines.len > INSTRUMENT_MAX_LINE_NUMBER)
				usr << "Too many lines!"
				lines.Cut(INSTRUMENT_MAX_LINE_NUMBER+1)
			var/linenum = 1
			for(var/l in lines)
				if(lentext(l) > INSTRUMENT_MAX_LINE_LENGTH)
					usr << "Line [linenum] too long!"
					lines.Remove(l)
				else
					linenum++
			updateDialog(usr)		// make sure updates when complete
	else if(href_list["help"])
		help = text2num(href_list["help"]) - 1
	else if(href_list["edit"])
		edit = text2num(href_list["edit"]) - 1
	if(href_list["repeat"]) //Changing this from a toggle to a number of repeats to avoid infinite loops.
		if(playing)
			return //So that people cant keep adding to repeat. If the do it intentionally, it could result in the server crashing.
		repeat += round(text2num(href_list["repeat"]))
		if(repeat < 0)
			repeat = 0
		if(repeat > max_repeats)
			repeat = max_repeats
	else if(href_list["tempo"])
		tempo = sanitize_tempo(tempo + text2num(href_list["tempo"]))
	else if(href_list["play"])
		playing = 1
		spawn()
			playsong(usr)
	else if(href_list["newline"])
		var/newline = html_encode(input("Enter your line: ", instrumentObj.name) as text|null)
		if(!newline || !in_range(instrumentObj, usr))
			return
		if(lines.len > INSTRUMENT_MAX_LINE_NUMBER)
			return
		if(lentext(newline) > INSTRUMENT_MAX_LINE_LENGTH)
			newline = copytext(newline, 1, INSTRUMENT_MAX_LINE_LENGTH)
		lines.Add(newline)
	else if(href_list["deleteline"])
		var/num = round(text2num(href_list["deleteline"]))
		if(num > lines.len || num < 1)
			return
		lines.Cut(num, num+1)
	else if(href_list["modifyline"])
		var/num = round(text2num(href_list["modifyline"]),1)
		var/content = html_encode(input("Enter your line: ", instrumentObj.name, lines[num]) as text|null)
		if(!content || !in_range(instrumentObj, usr))
			return
		if(lentext(content) > INSTRUMENT_MAX_LINE_LENGTH)
			content = copytext(content, 1, INSTRUMENT_MAX_LINE_LENGTH)
		if(num > lines.len || num < 1)
			return
		lines[num] = content
	else if(href_list["stop"])
		playing = 0
	updateDialog(usr)
	return

/datum/song/proc/sanitize_tempo(new_tempo)
	new_tempo = abs(new_tempo)
	return max(round(new_tempo, world.tick_lag), world.tick_lag)

// subclass for handheld instruments, like violin
/datum/song/handheld

/datum/song/handheld/updateDialog(mob/user)
	instrumentObj.interact(user)

/datum/song/handheld/shouldStopPlaying()
	if(instrumentObj)
		return !isliving(instrumentObj.loc)
	else
		return 1

//////////////////////////////////////////////////////////////////////////
/obj/structure/device/piano
	name = "space piano"
	desc = "This is a space piano; just like a regular piano, but always in tune! Even if the musician isn't."
	icon = 'icons/obj/musician.dmi'
	icon_state = "piano"
	anchored = 1
	density = 1
	var/datum/song/song

/obj/structure/device/piano/minimoog
	name = "space minimoog"
	icon_state = "minimoog"
	desc = "This is a minimoog; just like a space piano, but more spacey!"

/obj/structure/device/piano/New()
	..()
	song = new("piano", src)

	if(prob(50))
		name = "space minimoog"
		desc = "This is a minimoog, like a space piano, but more spacey!"
		icon_state = "minimoog"
	else
		name = "space piano"
		desc = "This is a space piano, like a regular piano, but always in tune! Even if the musician isn't."
		icon_state = "piano"

/obj/structure/device/piano/Destroy()
	qdel(song)
	song = null
	..()

/obj/structure/device/piano/verb/rotate()
	set name = "Rotate Piano"
	set category = "Object"
	set src in oview(1)

	if(istype(usr,/mob/living/simple_animal/mouse))
		return
	else if(!usr || !isturf(usr.loc))
		return
	else if(usr.stat || usr.restrained())
		return
	else if (istype(usr,/mob/observer/ghost) && !config.ghost_interaction)
		return
	else
		src.set_dir(turn(src.dir, 90))
		return

/obj/structure/device/piano/attack_hand(mob/user)
	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return 1
	interact(user)

/obj/structure/device/piano/interact(mob/user)
	if(!user || !anchored)
		return

	user.set_machine(src)
	song.interact(user)

/obj/structure/device/piano/attackby(obj/item/O as obj, mob/user as mob)
	if(O.is_wrench())
		if(anchored)
			playsound(src.loc, O.usesound, 50, 1)
			user << "<span class='notice'>You begin to loosen \the [src]'s casters...</span>"
			if (do_after(user, 40 * O.toolspeed))
				user.visible_message( \
					"[user] loosens \the [src]'s casters.", \
					"<span class='notice'>You have loosened \the [src]. Now it can be pulled somewhere else.</span>", \
					"You hear ratchet.")
				src.anchored = 0
		else
			playsound(src.loc, O.usesound, 50, 1)
			user << "<span class='notice'>You begin to tighten \the [src] to the floor...</span>"
			if (do_after(user, 20 * O.toolspeed))
				user.visible_message( \
					"[user] tightens \the [src]'s casters.", \
					"<span class='notice'>You have tightened \the [src]'s casters. Now it can be played again</span>.", \
					"You hear ratchet.")
				src.anchored = 1
	else
		..()
>>>>>>> b8f240f... Merge pull request #4282 from VOREStation/sync-09272018
