/// Runtimes if the passed in list is not sorted.
/proc/assert_sorted(list/list, name, cmp = /proc/cmp_numeric_asc)
	var/last_value = list[1]

	for (var/index in 2 to list.len)
		var/value = list[index]

		if (call(cmp)(value, last_value) < 0)
			stack_trace("[name] is not sorted. value at [index] ([value]) is in the wrong place compared to the previous value of [last_value] (when compared to by [cmp])")

		last_value = value
