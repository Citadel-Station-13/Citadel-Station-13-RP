/**
 * A department is a collection of jobs.
 * It can only belong to one faction, or belong to none.
 * 
 * A job can be in one or more departments, but only one department may be its primary department.
 * A job can manage multiple departments.
 * A department can be managed by one or more jobs.
 * 
 * todo: refactor
 */
/datum/department
	abstract_type = /datum/department
	var/name = "NOPE"		// Name used in UIs, and the index for the department assoc list in SSjob.
	/// id - must be unique globally.
	var/identifier
	/// faction - typepath or id, what faction we belong to
	var/faction
	var/short_name = "NO"	// Shorter name, used for things like external Topic() responses.
	var/color = "#000000"	// Color to use in UIs to represent this department.
	var/list/jobs = list()	// Assoc list. Key is the job title, and the value is a reference to the job datum. Populated by SSjob subsystem.
	var/list/primary_jobs = list() // Same as above, but only jobs with their 'primary' department are put here. Primary being the first department in their list.
	var/sorting_order = 0	// Used to sort departments, e.g. Command always being on top.
	var/visible = TRUE		// If false, it should not show up on things like the manifest or ID computer.
	var/assignable = TRUE	// Similar for above, but only for ID computers and such. Used for silicon department.
	var/centcom_only = FALSE
	/// starting pay modifier
	var/economy_payscale = ECONOMY_PAYSCALE_DEPT_DEFAULT

