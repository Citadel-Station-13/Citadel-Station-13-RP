/*
This file is for jamming single-line procs into Polaris procs.
It will prevent runtimes and allow their code to run if VOREStation's fails.
It will also log when we mess up our code rather than making it vague.

Call it at the top of a stock proc with...

if(attempt_vr(object,proc to call,args)) return

...if you are replacing an entire proc.

The proc you're attemping should return nonzero values on success.
*/

/proc/attempt_vr(callon, procname, list/args=null)
	return call(callon,procname)(arglist(args))
