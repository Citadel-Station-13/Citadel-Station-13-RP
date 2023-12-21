/datum/unit_test/priority_queue/Run()
	var/datum/priority_queue/queue = new /datum/priority_queue(/proc/cmp_numeric_asc)
	for(var/i in 1 to 1000)
		queue.enqueue(rand(1, 100000))
	var/last = queue.dequeue()
	while(length(queue.array))
		var/next = queue.dequeue()
		if(next < last)
			TEST_FAIL("Priority queue out of order. next [next] last [last] queue [json_encode(queue.array)]")
			return
		last = next
