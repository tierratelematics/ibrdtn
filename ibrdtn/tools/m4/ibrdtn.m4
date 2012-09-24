AC_DEFUN([LOCAL_CHECK_IBRDTN],
[
	ibrdtn=notfound
	
	AC_ARG_WITH([ibrcommon],
		AS_HELP_STRING([--with-ibrcommon=PATH], [set the ibrcommon source path]), [ibrcommon_path=${withval}]
	)
	
	AS_IF([test -z "${ibrcommon_path}" -a -e "$(pwd)/../configure.in" -a -d "$(pwd)/../ibrcommon"], [
		# set relative path
		ibrcommon_path="$(pwd)/../ibrcommon"
		ibrdtn_LIBS="${ibrdtn_LIBS} -L${ibrcommon_path}/ibrcommon/.libs"
		ibrdtn_CFLAGS="${ibrdtn_CFLAGS} -I${ibrcommon_path}"
	])

	AC_ARG_WITH([ibrdtn],
		AS_HELP_STRING([--with-ibrdtn=PATH], [set the ibrdtn source path]), [ibrdtn_path=${withval}]
	)
	
	# check if we are in the dev environment
	AS_IF([test -z "${ibrdtn_path}" -a -e "$(pwd)/../configure.in" -a -d "$(pwd)/../ibrdtn"], [
		# set relative path
		ibrdtn_path="$(pwd)/../ibrdtn"
	])
	
	AS_IF([test -n "${ibrdtn_path}"], [
		# allow the pattern PKG_CONFIG_PATH
		m4_pattern_allow([^PKG_CONFIG_PATH$])
		
		# export the relative path of ibrdtn
		export PKG_CONFIG_PATH="${ibrdtn_path}"
		
		# check for the svn version of ibrdtn
		if pkg-config --atleast-version=$LOCAL_IBRDTN_VERSION ibrdtn; then
			# read LIBS options for ibrdtn
			ibrdtn_LIBS="-L${ibrdtn_path}/ibrdtn/.libs ${ibrdtn_LIBS} $(pkg-config --libs ibrdtn)"
			
			# read CFLAGS options for ibrdtn
			ibrdtn_CFLAGS="-I${ibrdtn_path} ${ibrdtn_CFLAGS} $(pkg-config --cflags ibrdtn)"
			
			# some output
			echo "using ibrdtn library in ${ibrdtn_path}"
			echo " with CFLAGS: $ibrdtn_CFLAGS"
			echo " with LIBS: $ibrdtn_LIBS"
			
			# set ibrdtn as available
			ibrdtn=yes
		fi
	])

	AS_IF([test "x$ibrdtn" = "xnotfound"], [
		# check for ibrdtn library
		PKG_CHECK_MODULES([ibrdtn], [ibrdtn >= $LOCAL_IBRDTN_VERSION], [
			echo "using ibrdtn with CFLAGS: $ibrdtn_CFLAGS"
			echo "using ibrdtn with LIBS: $ibrdtn_LIBS"
		], [
			echo "ibrdtn library not found!"
			exit 1
		])
	])
])
