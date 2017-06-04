set groups SDP security policies from-zone sdp-trusted to-zone sdp-public policy SDP-to-Pheuture match source-address testbed2
set groups SDP security policies from-zone sdp-trusted to-zone sdp-public policy SDP-to-Pheuture match destination-address Pheuture_IP
set groups SDP security policies from-zone sdp-trusted to-zone sdp-public policy SDP-to-Pheuture match application any
set groups SDP security policies from-zone sdp-trusted to-zone sdp-public policy SDP-to-Pheuture then permit tunnel ipsec-vpn ike_Pheuture_vpn
set groups SDP security policies from-zone sdp-trusted to-zone sdp-public policy SDP-to-Pheuture then permit tunnel pair-policy Pheuture-to-SDP
set groups SDP security policies from-zone sdp-public to-zone sdp-trusted policy Pheuture-to-SDP match source-address Pheuture_IP
set groups SDP security policies from-zone sdp-public to-zone sdp-trusted policy Pheuture-to-SDP match destination-address testbed2
set groups SDP security policies from-zone sdp-public to-zone sdp-trusted policy Pheuture-to-SDP match application any
set groups SDP security policies from-zone sdp-public to-zone sdp-trusted policy Pheuture-to-SDP then permit tunnel ipsec-vpn ike_Pheuture_vpn
set groups SDP security policies from-zone sdp-public to-zone sdp-trusted policy Pheuture-to-SDP then permit tunnel pair-policy SDP-to-Pheuture
set groups SDP security zones security-zone sdp-public address-book address Pheuture_IP1 111.118.180.237/32
set groups SDP security zones security-zone sdp-public address-book address-set Pheuture_IP address Pheuture_IP1
set security ike proposal Pheuture_P1_proposal description "Pheuture Phase1 proposal"
set security ike proposal Pheuture_P1_proposal authentication-method pre-shared-keys
set security ike proposal Pheuture_P1_proposal dh-group group2
set security ike proposal Pheuture_P1_proposal authentication-algorithm sha1
set security ike proposal Pheuture_P1_proposal encryption-algorithm 3des-cbc
set security ike proposal Pheuture_P1_proposal lifetime-seconds 28800
set security ike policy Pheuture_P1_policy mode main
set security ike policy Pheuture_P1_policy description Pheuture_Phase1_policy
set security ike policy Pheuture_P1_policy proposals Pheuture_P1_proposal
set security ike policy Pheuture_P1_policy pre-shared-key ascii-text "PjHqf5FDitu0Bye"
set security ike gateway Pheuture_gateway ike-policy Pheuture_P1_policy
set security ike gateway Pheuture_gateway address 111.118.180.238
set security ike gateway Pheuture_gateway external-interface ge-6/0/20.115
set security ipsec proposal Pheuture_P2_proposal description "Pheuture Phase2 Proposal"
set security ipsec proposal Pheuture_P2_proposal protocol esp
set security ipsec proposal Pheuture_P2_proposal authentication-algorithm hmac-sha1-96
set security ipsec proposal Pheuture_P2_proposal encryption-algorithm 3des-cbc
set security ipsec proposal Pheuture_P2_proposal lifetime-seconds 3600
set security ipsec policy Pheuture_P2_policy description "Pheuture P2 Policy"
set security ipsec policy Pheuture_P2_policy perfect-forward-secrecy keys group2
set security ipsec policy Pheuture_P2_policy proposals Pheuture_P2_proposal
set security ipsec vpn ike_Pheuture_vpn ike gateway Pheuture_gateway
set security ipsec vpn ike_Pheuture_vpn ike ipsec-policy Pheuture_P2_policy
set security ipsec vpn ike_Pheuture_vpn establish-tunnels immediately
