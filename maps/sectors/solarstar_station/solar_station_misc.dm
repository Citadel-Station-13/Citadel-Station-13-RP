/obj/overmap/entity/visitable/sector/solar_station
	name = "Lythios 43 Star"
	desc = "The star of the system."
	scanner_desc = @{"[i]Stellar Body[/i]: Lythios 43 Star
[i]Class[/i]: Star
[i]Habitability[/i]: One solar research station detected.
[i]Registration[/i]: "HFS Denounced by the brother", previously known as "Kwar'Lih"
[i]Class[/i] Monitoring solar station, science and engineering use.
[i]Transponder[/i]: Transmitting (CIV), Hadii's Folly governement IFF
[b]Notice[/b]: Automated control and maintenance, Deck -1 delerict. Deck 0 usable. SDF note : Deck -1 possibly used has rest point for hostile. Do not fly to close to the sun. Do not drop trash in it. Do not not fly a surviving fleet in it.
[i]Population[/i]: N/A
[i]Controlling Goverment[/i]: Hadii's Folly Confederation of Freeholds, use authorised for neutral and allied faction and corporation.
[b]Relationship with NT[/b]: Nanotrasen Client Government.
[b]Relevant Contracts[/b]: Use to recharge vessels in power, and studies of the Lythios 43 star."}

	icon_state = "sun"
	color = "#ffeb85"

	initial_restricted_waypoints = list(
		"GCSS Vevalia Salvage Shuttle" = list ("solar_salvage"),
	)

/obj/effect/shuttle_landmark/solar_station_salvage
	name = "Guardian Company Salvage Docking spot"
	landmark_tag = "solar_salvage"
	base_turf = /turf/space/basic
	base_area = /area/space

/obj/item/radio/phone/laptop
	icon = 'icons/obj/computer.dmi'
	icon_state = "laptop"
	anchored = FALSE
	broadcasting = FALSE
	listening = TRUE
	name = "Radio Computer"
	desc = "A laptop with a mic, connected to the entertainement frequency."
	frequency = FREQ_ENTERTAINMENT
	anchored = TRUE
	can_be_unanchored = TRUE
