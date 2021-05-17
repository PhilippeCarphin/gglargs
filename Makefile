include colors.mk

build_dir = build
cclargs_src_dir = cclargs_src
execs = $(build_dir)/gglargs $(build_dir)/cclargs

.PHONY: $(build_dir)/ord_soumet.cclargs $(build_dir)/ord_soumet.gglargs


all: $(execs)

$(build_dir)/%.o: $(cclargs_src_dir)/%.c
	$(call make_echo_build_c_object)
	@gcc -c $< -o $@

$(build_dir)/cclargs: $(build_dir)/cclargs_lite.o
	$(call make_echo_link_c_executable)
	@gcc $< -o $@
	@echo "Built target $@"

$(build_dir)/gglargs: gglargs.go cmd/gglargs/main.go
	$(call make_echo_generate_file)
	@cd build && go build ../cmd/gglargs
	@echo "Built target $@"

test: gotest test_args test_autocomplete

gotest:
	$(call make_echo_run_test,"Running GO unit tests")
	@go test ./...
	@echo "Built target $@"

test_args: $(build_dir)/ord_soumet.gglargs_output $(build_dir)/ord_soumet.cclargs_output
	$(call make_echo_run_test,"Comparng output $^")
	@diff $^
	@echo "Built target $@"

test_autocomplete: $(build_dir)/ord_soumet.cclargs.completion.bash $(build_dir)/ord_soumet.gglargs.completion.bash
	$(call make_echo_run_test,"Comparng output $^")
	@diff $^
	@echo "Built target $@"

$(build_dir)/ord_soumet.cclargs_output: $(build_dir)/cclargs
	$(call make_echo_color_bold,blue,"Generating $@")
	@CCLARGS_GENERATE_AUTOCOMPLETE="" ./test_files/ord_soumet_cclargs_call.sh arg1 arg2 arg3 > $@ 2>/dev/null

$(build_dir)/ord_soumet.cclargs.completion.bash: $(build_dir)/cclargs
	$(call make_echo_color_bold,blue,"Generating $@")
	@CCLARGS_GENERATE_AUTOCOMPLETE="1" ./test_files/ord_soumet_cclargs_call.sh arg1 arg2 arg3 >> $@ 2>/dev/null

$(build_dir)/ord_soumet.gglargs_output: $(build_dir)/gglargs
	$(call make_echo_color_bold,blue,"Generating $@")
	@GGLARGS_GENERATE_AUTOCOMPLETE="" ./test_files/ord_soumet_gglargs_call.sh arg1 arg2 arg3 | sed 's/GGLARGS/CCLARGS/g' > $@ 2>/dev/null

$(build_dir)/ord_soumet.gglargs.completion.bash: $(build_dir)/gglargs
	$(call make_echo_color_bold,blue,"Generating $@")
	@GGLARGS_GENERATE_AUTOCOMPLETE="1" ./test_files/ord_soumet_gglargs_call.sh arg1 arg2 arg3 >> $@

smm: cclargs_src/star_minus_minus.c
	$(call make_echo_color_bold,white,"Building executable")
	@gcc $< -Wno-unused-value -o smm
	./smm
	@echo "Built target $@"

clean:
	rm -f smm cclargs gglargs a.txt b.txt build/*
