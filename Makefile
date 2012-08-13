# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

all: light-attachment.stl

clean:
	rm *.stl *.stl.deps

%.stl: %.scad
	openscad -m make -o $@ -d $@.deps $<
