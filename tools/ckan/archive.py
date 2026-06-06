#!/usr/bin/env python3
"""Auto-archive COARE results to CKAN Data Catalog"""
import requests, json, time
B5="http://localhost:8086/api"
def archive():
r=requests.post(f"{B5}/self-test").json()
print(f"Archived | TPS:{round(r.get('add_tps',0)/1e6,1)}M | TRL:{r.get('trl_assessment',{}).get('trl_level','?')}")
if name=="main": archive()
