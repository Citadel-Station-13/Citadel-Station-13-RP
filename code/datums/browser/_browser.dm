/datum/browser
	var/mob/user
	var/title
	var/window_id // window_id is used as the window name for browse and onclose
	var/width = 0
	var/height = 0
	var/datum/weakref/ref = null
	var/window_options = "can_close=1;can_minimize=1;can_maximize=0;can_resize=1;titlebar=1;" // window option is set using window_id
	var/stylesheets[0]
	var/scripts[0]
	var/head_elements
	var/body_elements
	var/head_content = ""
	var/content = ""

/datum/browser/New(nuser, nwindow_id, ntitle = 0, nwidth = 0, nheight = 0, atom/nref = null)
	user = nuser
	RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(user_deleted))
	window_id = nwindow_id
	if (ntitle)
		title = format_text(ntitle)
	if (nwidth)
		width = nwidth
	if (nheight)
		height = nheight
	if (nref)
		ref = WEAKREF(nref)

/datum/browser/proc/user_deleted(datum/source)
	SIGNAL_HANDLER
	user = null

/datum/browser/proc/add_head_content(nhead_content)
	head_content = nhead_content

/datum/browser/proc/set_window_options(nwindow_options)
	window_options = nwindow_options

/datum/browser/proc/set_title_image(ntitle_image)
	//title_image = ntitle_image

/datum/browser/proc/add_stylesheet(name, file)
	if(istype(name, /datum/asset/spritesheet))
		var/datum/asset/spritesheet/sheet = name
		stylesheets["spritesheet_[sheet.name].css"] = "data/spritesheets/[sheet.name]"
	else
		var/asset_name = "[name].css"

		stylesheets[asset_name] = file

		if (!SSassets.cache[asset_name])
			SSassets.transport.register_asset(asset_name, file)

/datum/browser/proc/add_script(name, file)
	scripts["[ckey(name)].js"] = file
	SSassets.transport.register_asset("[ckey(name)].js", file)

/datum/browser/proc/set_content(ncontent)
	content = ncontent

/datum/browser/proc/add_content(ncontent)
	content += ncontent

/datum/browser/proc/get_header()
	var/datum/asset/simple/namespaced/common/common_asset = get_asset_datum(/datum/asset/simple/namespaced/common)
	var/file
	head_content += "<link rel='stylesheet' type='text/css' href='[common_asset.get_url_mappings()["common.css"]]'>"
	for (file in stylesheets)
		head_content += "<link rel='stylesheet' type='text/css' href='[SSassets.transport.get_asset_url(file)]'>"


	for (file in scripts)
		head_content += "<script type='text/javascript' src='[SSassets.transport.get_asset_url(file)]'></script>"

	return {"<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge'>
		[head_content]
	</head>
	<body scroll=auto>
		<div class='uiWrapper'>
			[title ? "<div class='uiTitleWrapper'><div class='uiTitle'><tt>[title]</tt></div></div>" : ""]
			<div class='uiContent'>
	"}
//" This is here because else the rest of the file looks like a string in notepad++.
/datum/browser/proc/get_footer()
	return {"
			</div>
		</div>
	</body>
</html>"}

/datum/browser/proc/get_content()
	return {"
	[get_header()]
	[content]
	[get_footer()]
	"}


/datum/browser/proc/open(use_onclose = TRUE)
	if(isnull(window_id))	//null check because this can potentially nuke goonchat
		WARNING("Browser [title] tried to open with a null ID")
		to_chat(user, "<span class='userdanger'>The [title] browser you tried to open failed a sanity check! Please report this on github!</span>")
		return
	var/window_size = ""
	if(width && height)
		window_size = "size=[width]x[height];"
	var/datum/asset/simple/namespaced/common/common_asset = get_asset_datum(/datum/asset/simple/namespaced/common)
	common_asset.send(user)
	if(stylesheets.len)
		SSassets.transport.send_assets(user, stylesheets)
	if(scripts.len)
		SSassets.transport.send_assets(user, scripts)
	user << browse(get_content(), "window=[window_id];[window_size][window_options]")
	if(use_onclose)
		setup_onclose()

/datum/browser/proc/setup_onclose()
	set waitfor = 0 //winexists sleeps, so we don't need to.
	for (var/i in 1 to 10)
		if (user?.client && winexists(user, window_id))
			var/atom/send_ref
			if(ref)
				send_ref = ref.resolve()
				if(!send_ref)
					ref = null
			onclose(user, window_id, send_ref)
			break

/datum/browser/proc/close()
	if(!isnull(window_id))//null check because this can potentially nuke goonchat
		user << browse(null, "window=[window_id]")
	else
		WARNING("Browser [title] tried to close with a null ID")
