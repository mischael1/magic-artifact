#!/usr/bin/env python3
import sys
import struct

if len(sys.argv) < 2:
    print("Usage: python analyze_audio.py <file.raw>")
    sys.exit(1)

filename = sys.argv[1]

with open(filename, 'rb') as f:
    data = f.read()
    
print(f"File: {filename}")
print(f"Size: {len(data)} bytes ({len(data)//2} samples)")

# Анализируем RMS энергию
samples = []
for i in range(0, min(len(data)-1, 10000), 2):
    s1 = data[i]
    s2 = data[i+1]
    sample = ((s2 << 8) | s1)
    if sample > 32767:
        sample -= 65536
    samples.append(sample)

if samples:
    rms = sum(s*s for s in samples) / len(samples)
    rms = rms ** 0.5
    max_val = max(abs(s) for s in samples)
    print(f"RMS: {rms:.1f}")
    print(f"Max: {max_val}")
    print(f"First 20 samples: {samples[:20]}")
    
    if rms < 50:
        print("\nWARNING: Audio is very quiet (almost silence)")
    else:
        print("\nAudio level seems OK")
