#!/bin/bash

# Check if the nginx service is active
if ! systemctl is-active --quiet nginx; then
    echo "Nginx is down! Attempting to restart..."

    # Try to restart the service
    sudo systemctl restart nginx

    # Verify if it came back up
    if systemctl is-active --quiet nginx; then
        echo "Nginx restarted successfully."
        # Optional: Add a command here to send a Slack/Discord notification
    else
        echo "CRITICAL: Nginx failed to restart!"
    fi
else
    echo "Nginx is running smoothly."
fi
