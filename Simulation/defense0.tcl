# Create a simulator object
set ns [new Simulator]
set counter 0
set th_normal 100
set th_suspicious 300
set rights 0
#Isp info
array set a [list a 100 b 20 c 200]
array set visited [list a 0 b 0 c 0]
array set resource [list a 100 b 150 c 1000]

# Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red

# open the trace file
set tracefile1 [open out.tr w]
$ns trace-all $tracefile1

# Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile

# Define a 'finish' procedure
proc finish {} {
	global ns tracefile1 namfile
	$ns flush-trace
	close $tracefile1
	close $namfile
	exec nam out.nam &
	exit 0
}

set lamda 50.0
set mu   20.0

set iat_udp [new RandomVariable/Exponential]
$iat_udp set avg_ [expr 1.0/$lamda]

set iat_tcp [new RandomVariable/Exponential]
$iat_tcp set avg_ [expr 1.0/$lamda]

set pktsize [new RandomVariable/Exponential]
$pktsize set avg_ [expr 10000.0/$mu]

set prob [new RandomVariable/Uniform]


# Create 6 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]


# Create links between nodes
$ns duplex-link $n0 $n2 0.2Mb 100ms DropTail
$ns duplex-link $n1 $n2 0.5Mb 100ms DropTail
$ns duplex-link $n2 $n3 0.2Mb 100ms DropTail
$ns duplex-link $n2 $n4 0.2Mb 200ms DropTail
$ns duplex-link $n2 $n5 0.2Mb 200ms DropTail
$ns duplex-link $n2 $n6 0.2Mb 200ms DropTail
$ns duplex-link $n7 $n2 0.2Mb 100ms DropTail
$ns duplex-link $n8 $n2 0.2Mb 100ms DropTail


# Setting node positions
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n2 $n4 orient right-up
$ns duplex-link-op $n2 $n5 orient right-down
$ns duplex-link-op $n2 $n6 orient up
$ns duplex-link-op $n7 $n2 orient up
$ns duplex-link-op $n8 $n2 orient right


# Set Queue positions
$ns simplex-link-op $n2 $n3 queuePos 0.5
$ns duplex-link-op $n0 $n2 queuePos 0.5
$ns duplex-link-op $n1 $n2 queuePos 0.5

# Set Queue Sizes
$ns queue-limit $n0 $n2 20
$ns queue-limit $n1 $n2 20
$ns queue-limit $n2 $n3 10
#$ns queue-limit $n3 $n4 5

# Labelling

$ns at 0.0 "$n2 label Victim_Client"
$ns at 0.0 "$n3 label Isp1"
$ns at 0.0 "$n0 label Attacker1"
$ns at 0.0 "$n1 label Attacker2"
$ns at 0.0 "$n4 label Isp2"
$ns at 0.0 "$n5 label Isp3"
$ns at 0.0 "$n6 label Garbage"
$ns at 0.0 "$n7 label client_1"
$ns at 0.0 "$n8 label client_2"

# Shape

$n2 shape hexagon
$n3 shape square


# Defining a Random Uniform Generator
proc Random_Generator_Uniform {} {
	set MyRng4 [new RNG]
	$MyRng4 seed 0
	set r4 [new RandomVariable/Uniform]
	$r4 use-rng $MyRng4
	$r4 set min_ 0
	$r4 set max_ 4
	puts stdout "Testing Uniform Random Variable inside function"
	global x
	set x [$r4 value]
	return x
}

proc Random_Generator_Exponential {} {
	set MyRng5 [new RNG]
	$MyRng5 seed 0
	set r5 [new RandomVariable/Exponential]
	$r5 use-rng $MyRng5
	$r5 set avg_ 100
	puts stdout "Testing Exponantial Random Variable inside function"
	global y
	set y [$r5 value]
	return y
}

# Setup a TCP connection
set tcp [new Agent/UDP]
$ns attach-agent $n0 $tcp
set sink [new Agent/Null]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1
#$tcp set packetsize_ 552

set tcp2 [new Agent/UDP]
$ns attach-agent $n0 $tcp2
set sink2 [new Agent/Null]
$ns attach-agent $n5 $sink2
$ns connect $tcp2 $sink2
$tcp2 set fid_ 1

set tcp4 [new Agent/UDP]
$ns attach-agent $n0 $tcp4
set sink4 [new Agent/Null]
$ns attach-agent $n3 $sink4
$ns connect $tcp4 $sink4
$tcp4 set fid_ 1

set tcp6 [new Agent/UDP]
$ns attach-agent $n0 $tcp6
set sink6 [new Agent/Null]
$ns attach-agent $n2 $sink6
$ns connect $tcp6 $sink6
$tcp6 set fid_ 1

set tcp8 [new Agent/UDP]
$ns attach-agent $n2 $tcp8
set sink8 [new Agent/Null]
$ns attach-agent $n6 $sink8
$ns connect $tcp8 $sink8
$tcp8 set fid_ 1

set tcp10 [new Agent/UDP]
$ns attach-agent $n7 $tcp10
set sink10 [new Agent/Null]
$ns attach-agent $n2 $sink10
$ns connect $tcp10 $sink10
$tcp10 set fid_ 1

set tcp12 [new Agent/UDP]
$ns attach-agent $n7 $tcp12
set sink12 [new Agent/Null]
$ns attach-agent $n3 $sink12
$ns connect $tcp12 $sink12
$tcp12 set fid_ 1

set tcp14 [new Agent/UDP]
$ns attach-agent $n7 $tcp14
set sink14 [new Agent/Null]
$ns attach-agent $n4 $sink14
$ns connect $tcp14 $sink14
$tcp14 set fid_ 1

set tcp16 [new Agent/UDP]
$ns attach-agent $n7 $tcp16
set sink16 [new Agent/Null]
$ns attach-agent $n5 $sink16
$ns connect $tcp16 $sink16
$tcp16 set fid_ 1

set tcp18 [new Agent/UDP]
$ns attach-agent $n8 $tcp18
set sink18 [new Agent/Null]
$ns attach-agent $n6 $sink18
$ns connect $tcp18 $sink18
$tcp18 set fid_ 1



#Setup a FTP over TCP connection
#set pareto [new Application/Traffic/Pareto]
#$pareto attach-agent $tcp
#$pareto set PacketSize_ 1000
#$pareto set burst_time 0.98
#$pareto set idle_time 0.01
#$pareto set rate_ 1000
#$pareto set shape_ 2

# Setup a UDP connection
set tcp1 [new Agent/UDP]
$ns attach-agent $n1 $tcp1
set sink1 [new Agent/Null]
$ns attach-agent $n4 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 2

set tcp3 [new Agent/UDP]
$ns attach-agent $n1 $tcp3
set sink3 [new Agent/Null]
$ns attach-agent $n5 $sink3
$ns connect $tcp3 $sink3
$tcp3 set fid_ 2

set tcp5 [new Agent/UDP]
$ns attach-agent $n1 $tcp5
set sink5 [new Agent/Null]
$ns attach-agent $n3 $sink5
$ns connect $tcp5 $sink5
$tcp5 set fid_ 2

set tcp7 [new Agent/UDP]
$ns attach-agent $n1 $tcp7
set sink7 [new Agent/Null]
$ns attach-agent $n2 $sink7
$ns connect $tcp7 $sink7
$tcp7 set fid_ 2

set tcp9 [new Agent/UDP]
$ns attach-agent $n2 $tcp9
set sink9 [new Agent/Null]
$ns attach-agent $n6 $sink9
$ns connect $tcp9 $sink9
$tcp9 set fid_ 2

set tcp11 [new Agent/UDP]
$ns attach-agent $n8 $tcp11
set sink11 [new Agent/Null]
$ns attach-agent $n2 $sink11
$ns connect $tcp11 $sink11
$tcp11 set fid_ 2

set tcp13 [new Agent/UDP]
$ns attach-agent $n8 $tcp13
set sink13 [new Agent/Null]
$ns attach-agent $n3 $sink13
$ns connect $tcp13 $sink13
$tcp13 set fid_ 2

set tcp15 [new Agent/UDP]
$ns attach-agent $n8 $tcp15
set sink15 [new Agent/Null]
$ns attach-agent $n4 $sink15
$ns connect $tcp15 $sink15
$tcp15 set fid_ 2

set tcp17 [new Agent/UDP]
$ns attach-agent $n8 $tcp17
set sink17 [new Agent/Null]
$ns attach-agent $n5 $sink17
$ns connect $tcp17 $sink17
$tcp17 set fid_ 2

set tcp19 [new Agent/UDP]
$ns attach-agent $n8 $tcp19
set sink19 [new Agent/Null]
$ns attach-agent $n6 $sink19
$ns connect $tcp19 $sink19
$tcp19 set fid_ 2



#set poisson [new Application/Traffic/Exponential]
#$poisson attach-agent $tcp1
#$poisson set interval_ 0.005
#$poisson set PacketSize_ 100
#$poisson set burst_time 0.0
#$poisson set idle_time 0.01
#$poisson set rate_ 100000000
#$poisson set maxpkts_ 100

#puzzle

proc puzzle {} {

set c [ expr {int(rand()*20)} ]

return $c

}

#return isp with min cost
set flag z
set min 9999
set preRes 0
proc minIsp {} {
	global array a
	global array visited
	global array resource
	global flag
	global min
	global counter
	global preRes

	foreach {key value} [array get a] {
    	puts "$key => $value visited status $visited($key)"

 	if { $value <= $min } {
		
		if { $visited($key) eq 0 } {

			if { $counter <= $resource($key) } {
 				set flag $key
				set min $value
				set preRes "z"
				puts "packet -> $counter sending to $key"
			} else { 
				set preRes $key
				set counter 0
				
			}
		}	
		
	}
	}
	if { $preRes ne "z" } {
	set visited($preRes) 1
	set min 9999
	}
	
	#set visited($flag) 1
	
	
}

	
		

set limit_flag 0
proc sendpacket_udp {} {
	global ns tcp iat_udp pktsize prob tcp2
        global ns tcp iat_udp pktsize prob tcp4
	global ns tcp iat_udp pktsize prob tcp6
	global ns tcp iat_udp pktsize prob tcp8
	global ns tcp iat_udp pktsize prob tcp10
	global ns tcp iat_udp pktsize prob tcp12
	global ns tcp iat_udp pktsize prob tcp14
	global ns tcp iat_udp pktsize prob tcp16
	global ns tcp iat_udp pktsize prob tcp18
	global counter
	incr counter
	incr counter
	global flag
	#puts $flag
	global th_normal
	global th_suspicious
	global limit_flag
	global rights
	set time [$ns now]
	set vrbl [ expr [$prob value] ]
	$ns at [ expr $time + [$iat_udp value]] "sendpacket_udp"
	set bytes [expr round ([$pktsize value])]
	if { $counter < $th_normal && $limit_flag eq 0 } {
		$tcp6 send $bytes
		$tcp10 send $bytes
		puts " sink udp_packet -> $counter to victim"
	} elseif { $counter < $th_suspicious && $limit_flag eq 0} {
		set x [ puzzle ] 

		if { $x eq 7 && $rights eq 0 } {
			puts " sending rights allotted "
			puts " sink udp_packet -> $counter  to victim "
			$tcp6 send $bytes
			$tcp10 send $bytes
			set rights 1
		} elseif { $rights eq 0 } {
			incr counter -1
			$tcp8 send $bytes
			$tcp18 send $bytes
			puts " drop udp_packet -> $counter to garbage"
		} else {
			puts " sink udp_packet -> $counter  to victim "
			$tcp6 send $bytes
			$tcp10 send $bytes
		}
			
 
	} else {
		incr limit_flag 
		if { $limit_flag eq 1 } {
			set counter 0 
		}
		minIsp
	if { $flag eq "a" } {
		puts "sending udp_packet  = $counter  to Isp1"		
		$tcp send $bytes
		$tcp12 send $bytes
	} elseif { $flag eq "b" } {
		#puts "2"
		puts "sending udp_packet  = $counter  to Isp2"
		$tcp2 send $bytes
		$tcp14 send $bytes
	} else {
		#puts "3"
		puts "sending udp_packet  = $counter  to Isp3"
		$tcp4 send $bytes
		$tcp16 send $bytes
	} 
	}
}

proc sendpacket_tcp {} {
	global ns tcp1 iat_tcp tcp3 prob
	global ns tcp1 iat_tcp tcp5 prob
	global ns tcp1 iat_tcp tcp7 prob
	global ns tcp1 iat_tcp tcp9 prob
	global ns tcp1 iat_tcp tcp11 prob
	global ns tcp1 iat_tcp tcp13 prob
	global ns tcp1 iat_tcp tcp15 prob
	global ns tcp1 iat_tcp tcp17 prob
	global ns tcp1 iat_tcp tcp19 prob
	
	global counter
	incr counter
	incr counter
	global rights
	global flag
	global th_normal
	global th_suspicious
	global limit_flag
	
	set vrbl [ expr [$prob value] ]
	set time [$ns now]
	$ns at [ expr $time + [$iat_tcp value]] "sendpacket_tcp"
	set bytes 512
	if { $counter < $th_normal && $limit_flag eq 0 } {
		puts " sink tcp_packet -> $counter to victim"
		$tcp7 send $bytes
		$tcp11 send $bytes
	} elseif  { $counter < $th_suspicious && $limit_flag eq 0} {
		
		set x [ puzzle ] 

		if { $x eq 7 && $rights eq 0 } {
			puts " sending rights allotted "
			puts " sink tcp_packet -> $counter to victim"
			$tcp7 send $bytes
			$tcp11 send $bytes
			set rights 1
			
		} elseif { $rights eq 0 } { 
			puts " drop tcp_packet -> $counter to garbage"
			incr counter -1
			$tcp9 send $bytes
			$tcp19 send $bytes
		
		} else {
			puts " sink tcp_packet -> $counter to victim"
			$tcp7 send $bytes
			$tcp11 send $bytes
		}
 
	} else {
		incr limit_flag 
		if { $limit_flag eq 1 } {
			set counter 0 
		}
		minIsp
	
	if { $flag eq "a" } {
		#puts "1"
		puts "sending tcp_packet  = $counter  to Isp1"
		$tcp1 send $bytes
		$tcp13 send $bytes
	} elseif { $flag eq "b" } {
		#puts "2"
		puts "sending tcp_packet  = $counter  to Isp2"
		$tcp3 send $bytes
		$tcp15 send $bytes
	} else {
		#puts "3"
		puts "sending tcp_packet  = $counter  to Isp3"
		$tcp5 send $bytes
		$tcp17 send $bytes
	} 
}
}


#$ns rtproto DV

# If a link stops working
#$ns rtmodel-at 0.3 down $n4 $n5
#$ns rtmodel-at 2.0 up $n4 $n5
#$ns rtmodel-at 2.0 down $n3 $n4
#$ns rtmodel-at 3.5 up $n3 $n4

#Schedule events for the CBR and FTP agents
#$ns at 0.0 "$poisson start"
#$ns at 0.0 "pareto start"
#$ns at 10.0 "$pareto stop"
#$ns at 10.0 "$poisson stop"

$ns at 0.0001 "sendpacket_udp"
$ns at 2.0001 "sendpacket_tcp"

#Call the finish procedure after 5 seconds of simulation time
$ns at 10.0 "finish"



#Run the simulation
$ns run



