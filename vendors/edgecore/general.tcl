send_error "\r\n$switchIp is Edgecore. Continue getting config"
expect {
        "Username:" {
            send "$username\r"
            expect {
                -re {.*[Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd].*} {
                    send "$password\r"
                    expect {
                        "#" {
                            if {[fork]!=0} exit
                            disconnect
                            send_error "\r\n$switchIp Upload config fork"
                            set timeout 60
                            send "copy running-config tftp\r"
                            expect {
                                "IP address:" {
                                    send "$serverIp\r"
                                    expect {
                                        "file name:" {
                                            send "/configs-auto/$switchIp-new\r"
                                            expect {
                                                "Success." {
                                                    send_error "\r\n$switchIp Upload config successful"
                                                    sleep 3
                                                    exit
                                                }
                                                "Error." {
                                                    send_error "\r\n$switchIp Upload config Error!!!"
                                                    sleep 3
                                                    exit
                                                }
                                                timeout { send_error "\r\n\t$switchIp Uploading config timeout!!!"; exit }
                                            }
                                        }
                                        timeout { send_error "\r\n\t$switchIp Sent \\r timeout!!!"; exit }
                                    }
                                }
                                timeout { send_error "\r\n\t$switchIp Uploading config timeout!!!"; exit }
                            }
                        }
                        timeout { send_error "\r\n\t$switchIp Sent password timeout!!!"; exit }
                    }
                }
                timeout { send_error "\r\n\t$switchIp Password timeout!!!"; exit}
            }
        }
        timeout { send_error "\r\n\t$switchIp User login timeout!!!"; exit}
}
