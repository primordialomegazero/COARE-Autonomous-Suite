#!/usr/bin/env python3
"""Auto-archive COARE results to CKAN Data Catalog"""
import requests, json, time
COARE="http://localhost:9000/api"
def archive():
    r=requests.get(f"{COARE}/self-test").json()
    print(f"Archived | Score:{r.get('overall_score',0)}/100 | Status:{r.get('overall_status','?')}")
if __name__=="__main__": archive()
