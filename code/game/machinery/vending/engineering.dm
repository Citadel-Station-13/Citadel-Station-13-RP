/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_deny = "tool-deny"
	//req_access = list(ACCESS_ENGINEERING_MAINT) //Maintenance access
	products = list(
		/obj/item/stack/cable_coil/random = 10,
		/obj/item/tool/crowbar = 5,
		/obj/item/weldingtool = 3,
		/obj/item/tool/wirecutters = 5,
		/obj/item/tool/wrench = 5,
		/obj/item/atmos_analyzer = 5,
		/obj/item/t_scanner = 5,
		/obj/item/tool/screwdriver = 5,
		/obj/item/flashlight/glowstick = 3,
		/obj/item/flashlight/glowstick/red = 3,
		/obj/item/flashlight/glowstick/blue = 3,
		/obj/item/flashlight/glowstick/orange = 3,
		/obj/item/flashlight/glowstick/yellow = 3,
		/obj/item/reagent_containers/spray/windowsealant = 5,
	)
	contraband = list(
		/obj/item/weldingtool/hugetank = 2,
		/obj/item/clothing/gloves/fyellow = 2,
	)
	premium = list(
		/obj/item/clothing/gloves/yellow = 1,
	)
	req_log_access = ACCESS_ENGINEERING_CE
	has_logs = 1

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_deny = "engivend-deny"
	req_access = list(ACCESS_ENGINEERING_ENGINE)
	products = list(
		/obj/item/geiger_counter = 4,
		/obj/item/clothing/glasses/meson = 2,
		/obj/item/multitool = 4,
		/obj/item/cell/high = 10,
		/obj/item/airlock_electronics = 10,
		/obj/item/module/power_control = 10,
		/obj/item/circuitboard/airalarm = 10,
		/obj/item/circuitboard/firealarm = 10,
		/obj/item/circuitboard/status_display = 2,
		/obj/item/circuitboard/ai_status_display = 2,
		/obj/item/circuitboard/newscaster = 2,
		/obj/item/circuitboard/machine/holopad = 2,
		/obj/item/circuitboard/intercom = 4,
		/obj/item/circuitboard/security/telescreen/entertainment = 4,
		/obj/item/stock_parts/motor = 2,
		/obj/item/stock_parts/spring = 2,
		/obj/item/stock_parts/gear = 2,
		/obj/item/circuitboard/atm,
		/obj/item/circuitboard/guestpass,
		/obj/item/circuitboard/keycard_auth,
		/obj/item/circuitboard/photocopier,
		/obj/item/circuitboard/fax,
		/obj/item/circuitboard/request,
		/obj/item/circuitboard/microwave,
		/obj/item/circuitboard/washing,
		/obj/item/circuitboard/scanner_console,
		/obj/item/circuitboard/sleeper_console,
		/obj/item/circuitboard/body_scanner,
		/obj/item/circuitboard/sleeper,
		/obj/item/circuitboard/dna_analyzer,
		/obj/item/clothing/glasses/omnihud/eng = 6,
	)
	contraband = list(
		/obj/item/cell/potato = 3,
	)
	premium = list(
		/obj/item/storage/belt/utility = 3,
	)
	product_records = list()
	req_log_access = ACCESS_ENGINEERING_CE
	has_logs = 1

/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself station repair."
	icon_state = "engi"
	icon_deny = "engi-deny"
	req_access = list(ACCESS_ENGINEERING_ENGINE)
	products = list(
		/obj/item/clothing/under/rank/chief_engineer = 4,
		/obj/item/clothing/under/rank/engineer = 4,
		/obj/item/clothing/shoes/orange = 4,
		/obj/item/clothing/head/hardhat = 4,
		/obj/item/storage/belt/utility = 4,
		/obj/item/clothing/glasses/meson = 4,
		/obj/item/clothing/gloves/yellow = 4,
		/obj/item/tool/screwdriver = 12,
		/obj/item/tool/crowbar = 12,
		/obj/item/tool/wirecutters = 12,
		/obj/item/multitool = 12,
		/obj/item/tool/wrench = 12,
		/obj/item/t_scanner = 12,
		/obj/item/stack/cable_coil/heavyduty = 8,
		/obj/item/cell = 8,
		/obj/item/weldingtool = 8,
		/obj/item/clothing/head/welding = 8,
		/obj/item/light/tube = 10,
		/obj/item/clothing/suit/fire = 4,
		/obj/item/stock_parts/scanning_module = 5,
		/obj/item/stock_parts/micro_laser = 5,
		/obj/item/stock_parts/matter_bin = 5,
		/obj/item/stock_parts/manipulator = 5,
		/obj/item/stock_parts/console_screen = 5,
	)
	// There was an incorrect entry (cablecoil/power).  I improvised to cablecoil/heavyduty.
	// Another invalid entry, /obj/item/circuitry.  I don't even know what that would translate to, removed it.
	// The original products list wasn't finished.  The ones without given quantities became quantity 5.  -Sayu
	req_log_access = ACCESS_ENGINEERING_CE
	has_logs = 1

/obj/machinery/vending/tool/adherent
	name = "\improper Adherent Tool Dispenser"
	desc = "This looks like a heavily modified vending machine. It contains technology that doesn't appear to be human in origin."
	product_ads = "\[C#\]\[Cb\]\[Db\]. \[Ab\]\[A#\]\[Bb\]. \[E\]\[C\]\[Gb\]\[B#\]. \[C#\].;\[Cb\]\[A\]\[F\]\[Cb\]\[C\]\[E\]\[Cb\]\[E\]\[Fb\]. \[G#\]\[C\]\[Ab\]\[A\]\[C#\]\[B\]. \[Eb\]\[choral\]. \[E#\]\[C#\]\[Ab\]\[E\]\[C#\]\[Fb\]\[Cb\]\[F#\]\[C#\]\[Gb\]."
	icon_state = "adh-tool"
	icon_deny = "adh-tool-deny"
	icon_vend = "adh-tool-vend"
	vend_delay = 5
	products = list(/obj/item/weldingtool/electric/crystal = 5,
					/obj/item/tool/wirecutters/crystal = 5,
					/obj/item/tool/screwdriver/crystal = 5,
					/obj/item/tool/crowbar/crystal = 5,
					/obj/item/tool/wrench/crystal = 5,
					/obj/item/multitool/crystal = 5,
					/obj/item/storage/belt/utility/crystal = 5,
					/obj/item/storage/toolbox/crystal = 5)

/obj/machinery/vending/tool/adherent/vend(datum/stored_item/vending_product/, mob/living/carbon/user)
	if (emagged || istype(user) && user.species.name == SPECIES_ADHERENT)
		return ..()
	to_chat(user, SPAN_WARNING("\The [src] emits a discordant chime."))

