#!/usr/bin/env python3
import re, sys, csv, time, datetime, statistics
from pathlib import Path

pat = re.compile(r'^\[(?P<epoch>\d+(?:\.\d+)?)\].*?icmp_seq=(?P<seq>\d+).*?time=(?P<ms>\d+(?:\.\d+)?)\s*ms')

def ts_rfc3339(epoch_float):
    return datetime.datetime.utcfromtimestamp(float(epoch_float)).isoformat(timespec='microseconds') + 'Z'

def main(infile, outfile):
    rows = []
    with open(infile, 'r', errors='ignore') as f:
        for line in f:
            m = pat.search(line)
            if m:
                epoch = float(m.group('epoch'))
                seq = int(m.group('seq'))
                ms = float(m.group('ms'))
                rows.append((epoch, ts_rfc3339(epoch), seq, ms))

    if not rows:
        print(f"[WARN] No ping samples parsed from {infile}")
        return

    Path(outfile).parent.mkdir(parents=True, exist_ok=True)
    with open(outfile, 'w', newline='') as out:
        w = csv.writer(out)
        w.writerow(['epoch','timestamp_utc','seq','rtt_ms'])
        w.writerows(rows)

    # quick summary to stdout
    rtts = [r[3] for r in rows]
    print(f"[PING] {len(rows)} samples | min {min(rtts):.3f} ms | avg {sum(rtts)/len(rtts):.3f} ms | max {max(rtts):.3f} ms | stdev {statistics.pstdev(rtts):.3f} ms")
    print(f"[PING] CSV -> {outfile}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("usage: parse_ping.py <ping.log> <out.csv>")
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])
