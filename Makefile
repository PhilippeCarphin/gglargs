include colors.mk

all: build/gglargs build/cclargs

build/%.o: cclargs_src/%.c
	$(call make_echo_color,green,"Build C object $@")
	@gcc -c $< -o $@

build/cclargs: build/cclargs_lite.o
	$(call make_echo_color_bold,green,"Linking C executable $@")
	@gcc $< -o $@
	@echo "Built target $@"

build/gglargs: gglargs.go cmd/gglargs/main.go
	$(call make_echo_color_bold,green,"Building go executable $@")
	@go build ./cmd/gglargs
	@mv gglargs $@
	@echo "Built target $@"

test: gotest demo

gotest:
	$(call make_echo_color_bold,cyan,"Test: Running GO unit tests")
	@go test ./...
	@echo "Built target $@"

demo: build/gglargs build/cclargs
	$(call make_echo_color_bold,cyan,"Test: Comparng output of cclargs and gglargs for ord_soumet")
	$(call make_echo_color,white,"Doing ord_soumets cclargs call")
	@./test_files/ord_soumet_cclargs_call.sh arg1 arg2 arg3 > build/a.txt 2>/dev/null

	$(call make_echo_color,white,"Doing the same thing with gglargs")
	@GGLARGS_GENERATE_AUTOCOMPLETE=""  ./test_files/ord_soumet_gglargs_call.sh arg1 arg2 arg3 | sed 's/GGLARGS/CCLARGS/g' > build/b.txt 2>/dev/null

	@diff build/a.txt build/b.txt
	@echo "Built target $@"

smm: cclargs_src/star_minus_minus.c
	$(call make_echo_color_bold,white,"Building executable")
	@gcc $< -Wno-unused-value -o smm
	./smm
	@echo "Built target $@"

clean:
	rm -f smm cclargs gglargs a.txt b.txt build/*
