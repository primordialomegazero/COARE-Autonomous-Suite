#!/bin/bash
# COARE ALERT SYSTEM — Auto-Notifications on Issues

ALERT_FILE="/tmp/coare_alerts.log"
WEBHOOK_URL="${COARE_WEBHOOK_URL:-}"  # Optional: Slack/Discord webhook

send_alert() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%d%H%MZ%b%y')
    
    # Log to file
    echo "[$timestamp] [$level] $message" >> "$ALERT_FILE"
    
    # Console output with color
    case $level in
        CRITICAL) echo -e "\033[31m[CRITICAL]\033[0m $message" ;;
        WARNING)  echo -e "\033[33m[WARNING]\033[0m $message" ;;
        INFO)     echo -e "\033[32m[INFO]\033[0m $message" ;;
    esac
    
    # Webhook (if configured)
    if [ -n "$WEBHOOK_URL" ]; then
        curl -s -X POST "$WEBHOOK_URL" \
            -H "Content-Type: application/json" \
            -d "{\"text\":\"[$level] $message\",\"timestamp\":\"$timestamp\"}" \
            > /dev/null 2>&1
    fi
}

# Monitor COARE Suite health
while true; do
    HTTP=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9000/health 2>/dev/null)
    
    if [ "$HTTP" = "200" ]; then
        SCORE=$(curl -s http://localhost:9000/api/self-test 2>/dev/null | python3 -c "import sys,json;print(json.load(sys.stdin).get('overall_score',0))" 2>/dev/null)
        
        if [ "$SCORE" -lt 70 ]; then
            send_alert "CRITICAL" "COARE Suite score dropped to $SCORE/100"
        elif [ "$SCORE" -lt 90 ]; then
            send_alert "WARNING" "COARE Suite score degraded: $SCORE/100"
        fi
    elif [ "$HTTP" = "000" ]; then
        send_alert "CRITICAL" "COARE Suite is DOWN — attempting restart..."
        docker restart coare-suite 2>/dev/null
    else
        send_alert "WARNING" "COARE Suite returned HTTP $HTTP"
    fi
    
    sleep 60
done
