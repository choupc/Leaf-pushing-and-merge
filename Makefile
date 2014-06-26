all: bps
bps: bps.c rdtsc.h
	gcc bps.c -g -o bps

clean:
	rm bps
