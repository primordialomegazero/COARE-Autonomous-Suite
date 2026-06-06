#!/usr/bin/env python3
"""AUTO-ARCHIVE — Autonomous CKAN Data Cataloger"""
import requests, json, time, os

COARE = "http://localhost:9000/api"

def archive_loop():
    count = 0
    while True:
        try:
            r = requests.get(f"{COARE}/self-test").json()
            score = r.get('overall_score', 0)
            status = r.get('overall_status', 'UNKNOWN')
            security = r.get('security', {}).get('score', 0)
            
            count += 1
            print(f"[{count:04d}] Archived | Score:{score}/100 | Status:{status} | Security:{security}/100")
            
            with open(f"/tmp/coare_archive_{count:04d}.json", 'w') as f:
                json.dump(r, f)
            
        except Exception as e:
            print(f"[ERROR] {e}")
        
        time.sleep(300)

if __name__ == "__main__":
    print("AUTO-ARCHIVE — COARE Autonomous Data Cataloger")
    print("Archiving every 5 minutes...")
    archive_loop()
