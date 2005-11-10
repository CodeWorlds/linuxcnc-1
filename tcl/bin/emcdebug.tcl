#!/bin/sh
# we need to find the tcl dir, it was exported from emc.run \
export EMC2_TCL_DIR
# the next line restarts using iosh \
exec $EMC2_EMCSH "$0" "$@"

# emcdebug.tcl
# Sets value of EMC_DEBUG, so you can turn on/off what you want dumped
# Needs emcsh to run-- this is sourced by tkemc, but it can be run
# standalone. Make sure directory containing emcsh is in your path,
# or edit the exec line above with the path to emcsh.

# check if any emc commands exist, and quit if not
if {! [string length [info commands emc_plat]]} {
    error "emcdebug needs to run from \"emcsh\""
}

proc distributeDebug {} {
    global debug_invalid
    global debug_config
    global debug_defaults
    global debug_versions
    global debug_task_issue
    global debug_io_points
    global debug_nml
    global debug_motion_time
    global debug_interp
    global debug_rcs
    global debug_traj
    global debug_interp_list

    # get the debug level from the EMC
    set emc_debug_level [emc_debug]

    # set the initial check boxes to correspond to current debug settings

    set debug_invalid [expr $emc_debug_level % 2]

    set emc_debug_level [expr $emc_debug_level >> 1]
    set debug_config [expr $emc_debug_level % 2]

    set emc_debug_level [expr $emc_debug_level >> 1]
    set debug_defaults [expr $emc_debug_level % 2]

    set emc_debug_level [expr $emc_debug_level >> 1]
    set debug_versions [expr $emc_debug_level % 2]

    set emc_debug_level [expr $emc_debug_level >> 1]
    set debug_task_issue [expr $emc_debug_level % 2]

    set emc_debug_level [expr $emc_debug_level >> 1]
    set debug_io_points [expr $emc_debug_level % 2]

    set emc_debug_level [expr $emc_debug_level >> 1]
    set debug_nml [expr $emc_debug_level % 2]

    set emc_debug_level [expr $emc_debug_level >> 1]
    set debug_motion_time [expr $emc_debug_level % 2]

    set emc_debug_level [expr $emc_debug_level >> 1]
    set debug_interp [expr $emc_debug_level % 2]

    set emc_debug_level [expr $emc_debug_level >> 1]
    set debug_rcs [expr $emc_debug_level % 2]

    set emc_debug_level [expr $emc_debug_level >> 1]
    set debug_traj [expr $emc_debug_level % 2]

    set emc_debug_level [expr $emc_debug_level >> 1]
    set debug_interp_list [expr $emc_debug_level % 2]
}

proc collectDebug {} {
    global debug_invalid
    global debug_config
    global debug_defaults
    global debug_versions
    global debug_task_issue
    global debug_io_points
    global debug_nml
    global debug_motion_time
    global debug_interp
    global debug_rcs
    global debug_traj
    global debug_interp_list

    set emc_debug_level $debug_interp_list

    set emc_debug_level [expr $emc_debug_level << 1]
    set emc_debug_level [expr $emc_debug_level + $debug_traj]

    set emc_debug_level [expr $emc_debug_level << 1]
    set emc_debug_level [expr $emc_debug_level + $debug_rcs]

    set emc_debug_level [expr $emc_debug_level << 1]
    set emc_debug_level [expr $emc_debug_level + $debug_interp]

    set emc_debug_level [expr $emc_debug_level << 1]
    set emc_debug_level [expr $emc_debug_level + $debug_motion_time]

    set emc_debug_level [expr $emc_debug_level << 1]
    set emc_debug_level [expr $emc_debug_level + $debug_nml]

    set emc_debug_level [expr $emc_debug_level << 1]
    set emc_debug_level [expr $emc_debug_level + $debug_io_points]

    set emc_debug_level [expr $emc_debug_level << 1]
    set emc_debug_level [expr $emc_debug_level + $debug_task_issue]

    set emc_debug_level [expr $emc_debug_level << 1]
    set emc_debug_level [expr $emc_debug_level + $debug_versions]

    set emc_debug_level [expr $emc_debug_level << 1]
    set emc_debug_level [expr $emc_debug_level + $debug_defaults]

    set emc_debug_level [expr $emc_debug_level << 1]
    set emc_debug_level [expr $emc_debug_level + $debug_config]

    set emc_debug_level [expr $emc_debug_level << 1]
    set emc_debug_level [expr $emc_debug_level + $debug_invalid]

    emc_debug $emc_debug_level
}

proc popdownDebug {w} {
    destroy $w
    if {$w == "."} {
        exit
    }
}

proc popupDebug {{w .debugwindow}} {
    global debug_invalid
    global debug_config
    global debug_defaults
    global debug_versions
    global debug_task_issue
    global debug_io_points
    global debug_nml
    global debug_motion_time
    global debug_interp
    global debug_rcs
    global debug_traj
    global debug_interp_list

    # trap "." as window name, and erase it, so that widgets
    # don't begin with two dots. We'll refer to the passed-in
    # name "w" here; in code following this setup we'll use the
    # modified name "lw"
    if {$w == "."} {
	# we're running standalone
        set lw ""
        wm title $w "EMC Debug"
    } else {
	# we were sourced into tkemc, and run as a popup
        set lw $w
        if {[winfo exists $w]} {
            wm deiconify $w
            raise $w
            focus $w
            return
        }
        toplevel $w
        wm title $w "EMC Debug"
    }

    # use "lw" as name of top level from now on

    # set the debug variables so that they're initially checked properly
    distributeDebug

    checkbutton $lw.b1 -text "Invalid INI file entries" -variable debug_invalid -relief flat
    checkbutton $lw.b2 -text "Configuration information" -variable debug_config -relief flat
    checkbutton $lw.b3 -text "Use of defaults" -variable debug_defaults -relief flat
    checkbutton $lw.b4 -text "Version information" -variable debug_versions -relief flat
    checkbutton $lw.b5 -text "Command issuing" -variable debug_task_issue -relief flat
    checkbutton $lw.b6 -text "IO points" -variable debug_io_points -relief flat
    checkbutton $lw.b7 -text "NML" -variable debug_nml -relief flat
    checkbutton $lw.b8 -text "Motion time" -variable debug_motion_time -relief flat
    checkbutton $lw.b9 -text "Interpreter" -variable debug_interp -relief flat
    checkbutton $lw.b10 -text "RCS" -variable debug_rcs -relief flat
    checkbutton $lw.b11 -text "Trajectory level" -variable debug_traj -relief flat
    checkbutton $lw.b12 -text "Interpreter list" -variable debug_interp_list -relief flat

    pack $lw.b1 $lw.b2 $lw.b3 $lw.b4 $lw.b5 $lw.b6 $lw.b7 $lw.b8 $lw.b9 $lw.b10 $lw.b11 $lw.b12 -side top -pady 2 -anchor w

    frame $lw.buttons
    button $lw.buttons.ok -text OK -default active -command "collectDebug; popdownDebug $w"
    button $lw.buttons.cancel -text Cancel -command "popdownDebug $w"
    pack $lw.buttons -side bottom -fill x -pady 2m
    pack $lw.buttons.ok $lw.buttons.cancel -side left -expand 1
    bind $w <Return> "emc_debug [collectDebug] ; popdownDebug $w"
}

# if we're not running inside tkemc, then pop us up in root window
if {! [info exists tkemc]} {
    popupDebug .
}
