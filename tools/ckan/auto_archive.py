#!/usr/bin/env python3
"""AUTO-ARCHIVE — Autonomous CKAN Data Cataloger"""
import requests, json, time, os

B5 = "http://localhost:8086/api"

def archive_loop():
    count = 0
    while True:
        try:
            r = requests.post(f"{B5}/self-test").json()
            tps = round(r.get('add_tps',0)/1e6,1)
            trl = r.get('trl_assessment',{}).get('trl_level','?')
            log = r.get('immutable_log',{}).get('n',0)
            
            count += 1
            print(f"[{count:04d}] Archived | TPS:{tps}M | TRL:{trl} | Log:{log} entries")
            
            # Save to local archive
            with open(f"/tmp/coare_archive_{count:04d}.json", 'w') as f:
                json.dump(r, f)
            
        except Exception as e:
            print(f"[ERROR] {e}")
        
        time.sleep(300)  # Every 5 minutes

if __name__ == "__main__":
    print("AUTO-ARCHIVE — COARE Autonomous Data Cataloger")
    print("Archiving every 5 minutes...")
    archive_loop()
