// no point making 50 separate files for holidays with no special behaviour
// if there's anything other than "its on a specific day and it makes a roundstart message" it should go in its own file
/datum/holiday/simple
	abstract_type = /datum/holiday/simple
	priority = 1
	announce = TRUE

/datum/holiday/simple/new_years
	name = HOLIDAY_NEW_YEAR
	desc = "The day of the new solar year on Sol."
	begin_day = 1
	begin_month = 1

/datum/holiday/simple/skrell_royals
	name = HOLIDAY_SKRELL_ROYALS
	desc = "Vertalliq-Qerr, translated to mean 'Festival of the Royals', is a \
					Skrell holiday that celebrates the Qerr-Katish and all they have provided for the rest of Skrell society, \
					it often features colourful displays and skilled performers take this time to show off some of their more \
					fancy displays."
	begin_day = 12
	begin_month = 1

/datum/holiday/simple/groundhog
	name = HOLIDAY_GROUNDHOG
	desc = "An unoffical holiday based on ancient folklore that originated on Earth, \
					that involves the worship of an almighty groundhog, that could control the weather based on if it casted a shadow."
	begin_day = 2
	begin_month = 2

/datum/holiday/simple/valentines
	name = HOLIDAY_VALENTINES
	desc = "An old holiday that revolves around romance and love."
	begin_day = 14
	begin_month = 2

/datum/holiday/simple/random_kindness
	name = HOLIDAY_RANDOM_KINDNESS
	desc = "An unoffical holiday that challenges everyone to perform \
					acts of kindness to their friends, co-workers, and strangers, for no reason."
	begin_day = 17
	begin_month = 1

/datum/holiday/simple/skrell_mourning
	name = HOLIDAY_SKRELL_MOURNING
	desc = "Qixm-tes, or 'Day of mourning', is a Skrell holiday where Skrell gather at places \
					of worship and sing a song of mourning for all those who have died in service to their empire."
	begin_day = 3
	begin_month = 3

/datum/holiday/simple/pi
	name = HOLIDAY_PI
	desc = "An unoffical holiday celebrating the mathematical constant Pi.  It is celebrated on \
					March 14th, as the digits form 3 14, the first three significant digits of Pi.  Observance of Pi Day generally \
					involve eating (or throwing) pie, due to a pun.  Pies also tend to be round, and thus relatable to Pi."
	begin_day = 14
	begin_month = 3

/datum/holiday/simple/st_patrick
	name = HOLIDAY_ST_PATRICK
	desc = "An old holiday originating from Earth, Sol, celebrating the color green, \
					shamrocks, attending parades, and drinking alcohol."
	begin_day = 17
	begin_month = 3

/datum/holiday/simple/april_fools
	name = HOLIDAY_APRIL_FOOLS
	desc = "An old holiday that endevours one to pull pranks and spread hoaxes on their friends."
	begin_day = 1
	begin_month = 4

/datum/holiday/simple/earth
	name = HOLIDAY_EARTH
	desc = "A holiday of enviromentalism, that originated on it's namesake, Earth."
	begin_day = 22
	begin_month = 4

/datum/holiday/simple/workers
	name = HOLIDAY_WORKERS
	desc = "This holiday celebrates the work of laborers and the working class."
	begin_day = 1
	begin_month = 5

/datum/holiday/simple/remembrance
	name = HOLIDAY_REMEMBRANCE
	desc = "Remembrance Day (or, as it is more informally known, Armistice Day) is a confederation-wide holiday \
					mostly observed by its member states since late 2520. Officially, it is a day of remembering the men and women who died in various armed conflicts \
					throughout human history. Unofficially, however, it is commonly treated as a holiday honoring the victims of the Human-Unathi war. \
					Observance of this day varies throughout human space, but most common traditions are the act of bringing flowers to graves,\
					attending parades, and the wearing of poppies (either paper or real) in one's clothing."
	begin_day = 18
	begin_month = 5

/datum/holiday/simple/skrell_celebration
	name = HOLIDAY_SKRELL_CELEBRATION
	desc = "A Skrellian holiday that translates to 'Day of Celebration', Skrell communities \
					gather for a grand feast and give gifts to friends and close relatives."
	begin_day = 28
	begin_month = 5

/datum/holiday/simple/sapient_rights
	name = HOLIDAY_SAPIENT_RIGHTS
	desc = "This holiday celebrates the passing of the Declaration of Sapient Rights by OriCon, which guarantees the \
					same protections humans are granted to all sapient, living species."
	begin_day = 6
	begin_month = 6

/datum/holiday/simple/blood_donor
	name = HOLIDAY_BLOOD_DONOR
	desc = "This holiday was created to raise awareness of the need for safe blood and blood products, \
					and to thank blood donors for their voluntary, life-saving gifts of blood."
	begin_day = 14
	begin_month = 6

/datum/holiday/simple/civil_servants
	name = HOLIDAY_CIVIL_SERVANTS
	desc = "Civil Servant's Day is a holiday observed in OCG member states that honors civil servants everywhere,\
					(especially those who are members of the armed forces and the emergency services), or have been or have been civil servants in the past."
	begin_day = 20
	begin_month = 6

/datum/holiday/simple/doctors
	name = HOLIDAY_DOCTORS
	desc = "A holiday that recognizes the services of physicians, commonly celebrated \
					in healthcare organizations and facilities."
	begin_day = 1
	begin_month = 7

/datum/holiday/simple/friendship
	name = HOLIDAY_FRIENDSHIP
	desc = "An unoffical holiday that recognizes the value of friends and companionship.  Indeed, not having someone watch \
					your back while in space can be dangerous, and the cold, isolating nature of space makes friends all the more important."
	begin_day = 30
	begin_month = 7

/datum/holiday/simple/vore
	name = HOLIDAY_VORE
	desc = "A holiday representing the innate desire in all/most/some/a few of us to devour each other or be devoured."
	begin_day = 8
	begin_month = 8

/datum/holiday/simple/forgiveness
	name = HOLIDAY_FORGIVENESS
	desc = "A time to forgive and be forgiven."
	begin_day = 27
	begin_month = 8

/datum/holiday/simple/skrell_dead
	name = HOLIDAY_SKRELL_DEAD
	desc = "Translated to 'Night of the dead', it is a Skrell holiday where Skrell \
					communities hold parties in order to remember loved ones who passed, unlike Qixm-tes, this applies to everyone \
					and is a joyful celebration."
	begin_day = 17
	begin_month = 9

/datum/holiday/simple/pirate
	name = HOLIDAY_PIRATE
	desc = "Ahoy, matey!  Tis unoffical holiday be celebratin' the jolly \
					good humor of speakin' like the pirates of old."
	begin_day = 19
	begin_month = 9

/datum/holiday/simple/stupid_question
	name = HOLIDAY_STUPID_QUESTION
	desc = "Known as Ask A Stupid Question Day, it is an unoffical holiday \
					created by teachers in Sol, very long ago, to encourage students to ask more questions in the classroom."
	begin_day = 28
	begin_month = 9

/datum/holiday/simple/boss
	name = HOLIDAY_BOSS
	desc = "Boss' Day has traditionally been a day for employees to thank their bosses for the difficult work that they do \
					throughout the year. This day was created for the purpose of strengthening the bond between employer and employee."
	begin_day = 16
	begin_month = 10

/datum/holiday/simple/kindness
	name = HOLIDAY_KINDNESS
	desc = "Kindness Day is an unofficial holiday to highlight good deeds in the \
					community, focusing on the positive power and the common thread of kindness which binds humanity and \
					friends together."
	begin_day = 13
	begin_month = 11

/datum/holiday/simple/human_rights
	name = HOLIDAY_HUMAN_RIGHTS
	desc = "An old holiday created by an intergovernmental organization known back than as the United Nations, \
					human rights were not recognized globally at the time, and the holiday was made in honor of the Universal Declaration of Human Rights.  \
					These days, OriCon ensures that past efforts were not in vain, and continues to honor this holiday across the galaxy."
	begin_day = 10
	begin_month = 12

/datum/holiday/simple/skrell_landing
	name = HOLIDAY_SKRELL_LANDING
	desc = "A Skrellian holiday that celebrates the Skrell's first landing on one of \
					their moons.  It's often celebrated with grand festivals."
	begin_day = 22
	begin_month = 12

/datum/holiday/simple/new_years_eve
	name = HOLIDAY_NEW_YEAR_EVE
	desc = "The eve of the New Year for Sol.  It is traditionally celebrated by counting down to midnight, as that is \
					when the new year begins.  Other activities include planning for self-improvement over the new year, attending New Year's parties, or \
					watching a timer count to zero, a large object descending, and fireworks exploding in the sky, in person or on broadcast."
	begin_day = 31
	begin_month = 12
