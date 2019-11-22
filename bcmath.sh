#!/bin/bash
# This script is a file wrapper for the function wrapper
# for the cli 'bc'
# The 'math' function can be stripped and used by itself

# Use uncommented next line to add bash completion
# complete -W "-h --help -s 0 1 2 3 4 5 6 7 8 9 + - * / ( )" bcmath

# ⟬⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟭
# ⟬ Basic wrapper for the math cli 'bc'              ⟭
# ⟬ @USAGE: bcmath <PARAM> operation                 ⟭
# ⟬ 	bcmath -s4 "25/3" = 8.3333                   ⟭
# ⟬ 	bcmath "3*(2+3)" = 15                        ⟭
# ⟬     bcmath 3\*\(2+3\) = 15                       ⟭
# ⟬     bcmath "3 * (2 + 3)" = 15                    ⟭
# ⟬ @PARAM    	@DESCRIPTION                         ⟭
# ⟬ -h,--help	This help message                    ⟭
# ⟬ -s[n]		Decimal scale length         ⟭
# ⟬                                                  ⟭
# ⟬ @ERRORLEVEL: 1,2,3                               ⟭
# ⟬ 1		bc was not found	             ⟭
# ⟬ 2		Incorrect scale length 	             ⟭
# ⟬ 3		Incorrect mathematical operation     ⟭
# ⟬⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟡⟭
function bcmath(){
	which bc > /dev/null || return 1
	local item char scale params="$*" array=("$@") 
	for item in "$@"; do
		case "${item}" in
			-h|--help)	cat << EOF

	Basic wrapper for the math cli 'bc'

 	@USAGE:	bcmath <PARAM> operation
	 	bcmath -s4 "25/3" = 8.3333
 		bcmath "3*(2+3)" = 15
		bcmath 3\*\(2+3\) = 15
		bcmath "3 * (2 + 3)" = 15

	@PARAM		@DESCRIPTION		
	-h,--help	This help message
	-s[n]		Decimal scale length

	@ERRORLEVEL: 	1,2,3
	1		bc was not found
	2		Incorrect scale length
	3		Incorrect mathematical operation

EOF
					return 0;;
				-s*)	if [[ "${item}" =~ ^-s[0-9]*$ ]]; then
						scale="${item//-s/}"
						shift
					else
						return 2
					fi;;
		esac
	done
	while read -n1 char; do
		if ! (	[[ "${char}" =~ ^-?[0-9]*?\.?[0-9]*?$ ]] ||
			[[ "${char}" =~ ^[\+]?[\-]?[\/]?[\*]?[\(]?[\)]?$ ]] ||
			[[ "${char}" == " " ]]); then
			return 3
		fi
	done < <(echo -n "$*")
	[[ -n "${scale}" ]] || scale=2
	echo "scale=${scale};$*" | bc
	return 0
}
bcmath "$@" && exit 0 || exit $? # excecute and return ERRORLEVEL 
