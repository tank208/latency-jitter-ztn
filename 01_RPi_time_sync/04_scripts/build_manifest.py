#!/usr/bin/env python3
"""
build_manifest.py
Generates a JSON manifest linking experiment logs, parsed results,
and metadata for each test run.

Usage:
    python3 build_manifest.py /home/pi/test_metadata /path/to/logs
"""

import os, sys, json, re, datetime

def find_latest_metadata(meta_dir):
    """Return the path of the most recent metadata file."""
    metas = [os.path.join(meta_dir, f) for f in os.listdir(meta_dir) if f.startswith("metadata_")]
    if not metas:
        return None
    return max(metas, key=os.path.getmtime)

def extract_run_id(filename):
    """Parse timestamps like 20251030_203201 from filenames."""
    m = re.search(r'(\d{8}_\d{6})', filename)
    return m.group(1) if m else None

def build_manifest(meta_dir, log_dir):
    run_id = datetime.datetime.utcnow().strftime("%Y%m%d_%H%M%S")
    manifest = {
        "manifest_created": run_id,
        "entries": []
    }

    latest_meta = find_latest_metadata(meta_dir)

    for root, _, files in os.walk(log_dir):
        for f in files:
            if f.endswith((".log", ".csv", ".txt")):
                path = os.path.join(root, f)
                entry = {
                    "filename": f,
                    "path": os.path.abspath(path),
                    "run_id": extract_run_id(f),
                    "size_bytes": os.path.getsize(path),
                    "last_modified": datetime.datetime.utcfromtimestamp(os.path.getmtime(path)).isoformat() + "Z",
                    "metadata": latest_meta if latest_meta else "none"
                }
                manifest["entries"].append(entry)

    manifest_name = os.path.join(log_dir, f"manifest_{run_id}.json")
    with open(manifest_name, "w") as out:
        json.dump(manifest, out, indent=4)

    print(f"[INFO] Manifest written to {manifest_name}")
    print(f"[INFO] Linked metadata: {latest_meta}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: build_manifest.py <metadata_dir> <log_dir>")
        sys.exit(1)
    build_manifest(sys.argv[1], sys.argv[2])

