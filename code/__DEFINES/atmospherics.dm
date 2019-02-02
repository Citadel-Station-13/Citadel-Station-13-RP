
//CANATMOSPASS
#define ATMOS_PASS_YES 1
#define ATMOS_PASS_NO 0
#define ATMOS_PASS_PROC -1 //ask CanAtmosPass()
#define ATMOS_PASS_DENSITY -2 //just check density

#define CANATMOSPASS(A, O) ( A.CanAtmosPass == ATMOS_PASS_PROC ? A.CanAtmosPass(O) : ( A.CanAtmosPass == ATMOS_PASS_DENSITY ? !A.density : A.CanAtmosPass ) )
#define CANVERTICALATMOSPASS(A, O) ( A.CanAtmosPassVertical == ATMOS_PASS_PROC ? A.CanAtmosPass(O, TRUE) : ( A.CanAtmosPassVertical == ATMOS_PASS_DENSITY ? !A.density : A.CanAtmosPassVertical ) )
