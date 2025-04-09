//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/proc/sdql_new(type, ...)
	return new type(arglist(args.Copy(2)))
