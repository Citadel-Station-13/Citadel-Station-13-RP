/var/global/account_hack_attempted = 0

/datum/gm_action/money_hacker
	name = "bank account hacker"
	departments = list(DEPARTMENT_EVERYONE)
	reusable = TRUE
	var/datum/economy_account/affected_account
	var/active
	var/activeFor
	var/end_time

/datum/gm_action/money_hacker/set_up()
	active = TRUE
	end_time = world.time + 6000
	affected_account = SSeconomy.pull_account_lottery(FALSE, TRUE)
	if(affected_account)
		account_hack_attempted = 1

/datum/gm_action/money_hacker/announce()
	var/message = "A brute force hack has been detected (in progress since [stationtime2text()]). The target of the attack is: Financial account #[affected_account.account_id], \
	without intervention this attack will succeed in approximately 10 minutes. Required intervention: temporary suspension of affected accounts until the attack has ceased. \
	Notifications will be sent as updates occur.<br>"
	var/my_department = "[station_name()] firewall subroutines"

	for(var/obj/machinery/message_server/MS in GLOB.machines)
		if(!MS.active) continue
		MS.send_rc_message("Head of Personnel's Desk", my_department, message, "", "", 2)


/datum/gm_action/money_hacker/start()
	..()
	spawn(0)
		while(active)
			sleep(1)
			activeFor++
			if(world.time >= end_time)
				length = activeFor
			else
				length = activeFor + 10

/datum/gm_action/money_hacker/end()
	active = FALSE
	var/message
	if(affected_account && !affected_account.security_lock)
		//hacker wins
		message = "The hack attempt has succeeded."

		//subtract the money
		var/lost = affected_account.balance * 0.8 + (rand(2,4) - 2) / 10
		var/datum/economy_transaction/hack_transaction = new(-lost)
		hack_transaction.audit_peer_name_as_unsafe_html = pick("","yo brotha from anotha motha","el Presidente","chieF smackDowN","Nobody")
		hack_transaction.audit_purpose_as_unsafe_html = pick("Ne$ ---ount fu%ds init*&lisat@*n","PAY BACK YOUR MUM","Funds withdrawal","pWnAgE","l33t hax","liberationez","Hit","Nothing")
		// var/date1 = "31 December, 1999"
		// var/date2 = "[num2text(rand(1,31))] [pick("January","February","March","April","May","June","July","August","September","October","November","December")], [rand(1000,3000)]"
		// T.date = pick("", GLOB.current_date_string, date1, date2,"Nowhen")
		// var/time1 = rand(0, 99999999)
		// var/time2 = "[round(time1 / 36000)+12]:[(time1 / 600 % 60) < 10 ? add_zero(time1 / 600 % 60, 1) : time1 / 600 % 60]"
		// T.time = pick("", stationtime2text(), time2, "Never")
		// T.source_terminal = pick("","[pick("Biesel","New Gibson")] GalaxyNet Terminal #[rand(111,999)]","your mums place","nantrasen high CommanD","Angessa's Pearl","Nowhere")
		hack_transaction.audit_terminal_as_unsafe_html = "Oh No!"
		hack_transaction.execute_system_transaction(affected_account)

	else
		//crew wins
		message = "The attack has ceased, the affected accounts can now be brought online."

	var/my_department = "[station_name()] firewall subroutines"

	for(var/obj/machinery/message_server/MS in GLOB.machines)
		if(!MS.active) continue
		MS.send_rc_message("Head of Personnel's Desk", my_department, message, "", "", 2)

/datum/gm_action/money_hacker/get_weight()
	return 30 * length(SSeconomy.account_lookup)
