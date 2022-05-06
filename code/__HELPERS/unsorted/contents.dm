///Gets all contents of contents and returns them all in a list.
/atom/proc/GetAllContents(var/T)
	var/list/processing_list = list(src)
	var/i = 0
	var/lim = 1
	if(T)
		. = list()
		while(i < lim)
			var/atom/A = processing_list[++i]
			//Byond does not allow things to be in multiple contents, or double parent-child hierarchies, so only += is needed
			//This is also why we don't need to check against assembled as we go along
			processing_list += A.contents
			lim = processing_list.len
			if(istype(A,T))
				. += A
	else
		while(i < lim)
			var/atom/A = processing_list[++i]
			processing_list += A.contents
			lim = processing_list.len
		return processing_list

/atom/proc/GetAllContentsIgnoring(list/ignore_typecache)
	if(!length(ignore_typecache))
		return GetAllContents()
	var/list/processing = list(src)
	. = list()
	var/i = 0
	var/lim = 1
	while(i < lim)
		var/atom/A = processing[++i]
		if(!ignore_typecache[A.type])
			processing += A.contents
			lim = processing.len
			. += A
