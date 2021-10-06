/client/proc/_winclone(window_name, clone_name)
	winclone(src, window_name, clone_name)

/client/proc/_winexists(control_id)
	return winexists(src, control_id)

/client/proc/_winget(control_id, params)
	return winget(src, control_id, params)

/client/proc/_winset(control_id, params)
	winset(src, control_id, params)

/client/proc/_winshow(window, show)
	winshow(src, window, show)
