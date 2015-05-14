jack/headphone)
        case "$3" in
            plug)
                logger "headphone plugged"
                alsaucm -c bdw-rt5677 set _verb HiFi set _enadev Headphone
                ;;
            unplug)
                logger "headphone unplugged"
                alsaucm -c bdw-rt5677 set _verb HiFi set _disdev Headphone
                ;;
            *)
                logger "ACPI action undefined: $3"
                ;;
        esac
        ;;
