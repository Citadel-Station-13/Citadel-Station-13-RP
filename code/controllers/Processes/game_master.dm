/datum/controller/process/game_master/setup()
	name = "\improper GM controller"
	schedule_interval = 600 // every 60 seconds

/datum/controller/process/game_master/doWork()
	GLOB.game_master.process()