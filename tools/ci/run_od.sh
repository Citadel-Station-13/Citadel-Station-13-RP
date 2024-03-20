#!/bin/bash
set -eo pipefail
dotnet OpenDream/bin/DMCompiler/DMCompiler.dll --suppress-unimplemented citadel.dme
