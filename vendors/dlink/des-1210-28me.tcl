send_error "\r\n$switchIp is DES-1210-28/ME. Continue getting config"
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
                                send "upload cfg_toTFTP $serverIp /configs-auto/$switchIp-new config_id 1\r\n"
                                expect {
                                    "Success" {
                                        send_error "\r\n$switchIp Upload config successful"
                                        sleep 3
                                        exit
                                    }
                                    timeout { send_error "\r\n\t$switchIp Upload config timeout!!!"; exit }
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
