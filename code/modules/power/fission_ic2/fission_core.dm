/datum/ic2_core //the actual 'reactor' - processes, handles processing of components, etc

//reactor process loop:
//pulses are sent out and tallied
//heat is generated based on the pulses/cells/etc. heat is spread around to neighbors (if a fuel cell has neighbors) or the /datum/ic2_core itself if a fuel cell has no neighbors. heat will try to spread intelligently based on %age
//heat is then moved around, including to atmosphere if possible via atmospheric heat exchanger.
//finally, stuff melts etc
