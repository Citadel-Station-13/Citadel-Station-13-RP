//CANATMOSPASS
#define ATMOS_PASS_YES 1
#define ATMOS_PASS_NO 0
#define ATMOS_PASS_PROC -1 //ask CanAtmosPass()
#define ATMOS_PASS_DENSITY -2 //just check density

#define CANATMOSPASS(A, O) ( A.CanAtmosPass == ATMOS_PASS_PROC ? A.CanAtmosPass(O) : ( A.CanAtmosPass == ATMOS_PASS_DENSITY ? !A.density : A.CanAtmosPass ) )
#define CANVERTICALATMOSPASS(A, O) ( A.CanAtmosPassVertical == ATMOS_PASS_PROC ? A.CanAtmosPass(O, TRUE) : ( A.CanAtmosPassVertical == ATMOS_PASS_DENSITY ? !A.density : A.CanAtmosPassVertical ) )

//CANZONEPASS
#define ZONE_PASS_YES 1
#define ZONE_PASS_NO 0
#define ZONE_PASS_PROC -1
#define ZONE_PASS_DENSITY -2

#define CANZONEPASS(A, O) (A.CanZonePass == ZONE_PASS_PROC? A.CanZonePass(O) : (A.CanZonePass == ZONE_PASS_DENSITY? !A.density : (A.CanZonePass == ZONE_PASS_HORIZONTAL? TRUE : A.CanZonePass)))
#define CANVERTICALZONEPASS(A, O) (A.CanZonePassVertical == ZONE_PASS_PROC? A.CanZonePass(O, TRUE) : (A.CanZonePassVertical == ZONE_PASS_DENSITY? !A.density  A.CanZonePassVertical))
