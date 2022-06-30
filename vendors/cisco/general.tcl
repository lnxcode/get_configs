send_error "\r\n$switchIp is Cisco. Continue getting config"
expect {
        "Username:" { 
            send "$username\r"
            expect {
                -re {.*[Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd].*} {
                    send "$password\r"
                    send_error "$password"
                    expect {
                        ">" {
                            send "en\r"
                            expect {                             
                                -re {.*[Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd]:} {
                                    send "$enable\r"
                                    expect "#" {
                                        if {[fork]!=0} exit
                                        disconnect
                                        send_error "\r\n$switchIp Upload config fork"
                                        set timeout 120
                                        send "copy running-config tftp://$serverIp/configs-auto/$switchIp-new\r"
                                        expect {
                                            "\[$serverIp\]?" {
                                                send "\r"
                                                expect {
                                                    "\[$switchIp-new\]?" {
                                                        send "\r"
                                                        expect {
                                                            "bytes copied" {
                                                                send_error "\r\n$switchIp Upload config successful"
                                                                sleep 3
                                                                exit
                                                            }
                                                            timeout { send_error "\r\n\t$switchIp Uploading config timeout!!!"; exit }
                                                        }
                                                    }
                                                    timeout { send_error "\r\n\t$switchIp Sent \\r timeout!!!"; exit }
                                                }
                                            }
                                            timeout { send_error "\r\n\t$switchIp Sent \\r timeout!!!"; exit }
                                        }
                                    }
                                }
                                timeout { send_error "\r\n\t$switchIp enable password timeout!!!"; exit }
                            }
                        }
                        timeout { send_error "\r\n\t$switchIp PassowrdCisco timeout!!!"; exit }
                    }
                }
                timeout { send_error "\r\n\t$switchIp Password timeout!!!"; exit}
            }
        }
        timeout { send_error "\r\n\t$switchIp User login timeout!!!"; exit}
}
