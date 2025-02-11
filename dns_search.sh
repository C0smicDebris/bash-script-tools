#!/bin/bash

while true; do
    read -p "Enter the domain you want to search (or press Enter to exit): " domain
    if [[ -z "$domain" ]]; then
        echo "Exiting..."
        exit 0
    fi

    while true; do
        echo "Select the type(s) of record to search (separate choices with spaces):"
        echo "1) SPF"
        echo "2) DMARC"
        echo "3) DKIM"
        read -p "Enter your choice(s) (e.g., 1 2 for SPF and DMARC): " choices

        for choice in $choices; do
            case $choice in
                1)
                    echo "SPF SETTINGS:"
                    nslookup -type=txt "$domain"
                    ;;
                2)
                    echo "DMARC SETTINGS:"
                    nslookup -type=txt "_dmarc.$domain"
                    opendmarc-check "$domain"
                    ;;
                3)
                    echo "DKIM SETTINGS:"
                    dig txt "selector1._domainkey.$domain"
                    ;;
                *)
                    echo "Invalid choice: $choice, skipping."
                    ;;
            esac
        done

        read -p "Would you like to search for another record for the same domain? (y/n): " same_domain
        if [[ "$same_domain" != "y" ]]; then
            break
        fi
    done

done
