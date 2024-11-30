// todo: enum system like bitfields
/// KEY: must be unique, may be arbitrary; not a string, as it's used in typepath generation
/// CONSTRAINTS: list(/type = list(varname, ...), ...)
/// ENUMS: list of ENUM().
#define DEFINE_ENUM(KEY, CONSTRAINTS, ENUMS)
/// NAME: must be a string
/// VALUE: the actual enum value, whatever it is
#define ENUM(NAME, VALUE) ##NAME = ##VALUE
