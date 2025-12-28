/datum/map/sector/halloween_ball
    id = "halloween_ball"
    name = "Sector - Halloween Ball"
    width = 192
    height = 192
    levels = list(
        /datum/map_level/sector/halloween_ball,
    )

/datum/map_level/sector/halloween_ball
    id = "halloween_ball"
    name = "Sector - Halloween Ball"
    display_name = "NT Resort Facility"
    path = "maps/sectors/halloween_ball/halloween_ball.dmm"
    base_turf = /turf/simulated/floor/outdoors/snow
    base_area = /area/sector/halloween_ball

/area/sector/halloween_ball
    name = "Main Ball Facility"
    icon_state = "yellow"
    requires_power = FALSE
    dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/sector/halloween_ball/dorms
    name = "Igloo Inn"
    icon_state = "blue"

/area/sector/halloween_ball/club
    name = "Twenty Below"
    icon_state = "purple"

/area/sector/halloween_ball/exterior
    name = "Lythios Exterior"
    icon_state = "red"
    dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

/area/sector/halloween_ball/gateway
    name = "Ball Gateway"
    icon_state = "green"

/area/sector/halloween_ball/bar
    name = "Ball Bar"
    icon_state = "green"
