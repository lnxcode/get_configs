send_error "\r\n$switchIp is DGS-3120-24. Continue getting config"
expect {
        "UserName:" {
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
                                send "upload cfg_toTFTP $serverIp dest_file /configs-auto/$switchIp-new\r\n"
                                expect {
                                    "Upload configuration" {
                                        expect {
                                            "Done" {
                                                send_error "\r\n$switchIp Upload config successful"
                                                sleep 3
                                                exit
                                            }
                                            timeout { send_error "\r\n\t$switchIp Uploading config timeout!!!"; exit }
                                        }
                                    }
                                }
                                timeout { send_error "\r\n\t$switchIp Uploading configuration timeout!!!"; exit }
                        }
                        timeout { send_error "\r\n\t$switchIp Sent password timeout!!!"; exit }
                    }
                }
                timeout { send_error "\r\n\t$switchIp Password timeout!!!"; exit}
            }
        }
        timeout { send_error "\r\n\t$switchIp User login timeout!!!"; exit}
}
