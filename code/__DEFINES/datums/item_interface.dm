//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#define ITEM_AUTO_BINDS_SINGLE_INTERFACE_TO_VAR(TYPEPATH, VARNAME) \
##TYPEPATH/interface_attached(datum/item_interface/interface) { \
	ASSERT(isnull(src.##VARNAME)); \
	src.##VARNAME = interface; \
	return ..(); \
}; \
##TYPEPATH/interface_detached(datum/item_interface/interface) { \
	ASSERT(src.##VARNAME == interface); \
	src.##VARNAME = null; \
	return ..(); \
};
