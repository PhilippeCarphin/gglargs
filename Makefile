include color-makefile/colors.mk

build_dir = build
cclargs_src_dir = cclargs

.PHONY: $(build_dir)/cclargs

all: $(build_dir)/gglargs $(build_dir)/cclargs

# EXECUTABLE TARGETS
$(build_dir)/cclargs:
	$(at) $(MAKE) -C $(cclargs_src_dir) --no-print-directory cclargs
	$(at) cp $(cclargs_src_dir)/cclargs $@

$(build_dir)/gglargs: gglargs.go cmd/gglargs/main.go
	$(call make_echo_generate_file)
	$(at) cd build && go build ../cmd/gglargs

# TEST TARGETS
check: check_gounittest check_output check_completion check_help
	$(at) $(MAKE) -C $(cclargs_src_dir) --no-print-directory check_unittest

check_help: $(build_dir)/cclargs_help.txt $(build_dir)/gglargs_help.txt
	$(call make_echo_run_test,"Comparng output $^")
	$(at)diff $^
	$(call success)
$(build_dir)/cclargs_help.txt: $(build_dir)/cclargs
	$(call make_echo_generate_file)
	$(at)./test_files/ord_soumet_cclargs_call.sh -h 2>&1 1>/dev/null | sed 's/ *$$//' > $@
$(build_dir)/gglargs_help.txt: $(build_dir)/gglargs
	$(call make_echo_generate_file)
	$(at)./test_files/ord_soumet_gglargs_call.sh -h 2>&1 1>/dev/null | sed 's/ *$$//' > $@

# Run all Test* go functions in all test_*.go files
check_gounittest:
	$(call make_echo_run_test,"Running GO unit tests")
	$(at)go test ./... >/dev/null
	$(call success)

# Compare normal outputs
check_output: $(build_dir)/cclargs_output.sh $(build_dir)/gglargs_output.sh
	$(call make_echo_run_test,"Comparng output $^")
	$(at)diff $^
	$(call success)
$(build_dir)/cclargs_output.sh: $(build_dir)/cclargs
	$(call make_echo_generate_file)
	$(at) ./test_files/ord_soumet_cclargs_call.sh arg1 arg2 arg3 > $@ 2>/dev/null
$(build_dir)/gglargs_output.sh: $(build_dir)/gglargs
	$(call make_echo_generate_file)
	$(at) ./test_files/ord_soumet_gglargs_call.sh arg1 arg2 arg3 2>/dev/null | sed 's/GGLARGS/CCLARGS/g' > $@

# Compare generated autocomplete scripts
check_completion: $(build_dir)/cclargs_ord_soumet_completion.bash $(build_dir)/gglargs_ord_soumet_completion.bash
	$(call make_echo_run_test,"Comparng output $^")
	$(at)diff $^
	$(call success)
$(build_dir)/cclargs_ord_soumet_completion.bash: $(build_dir)/cclargs
	$(call make_echo_generate_file)
	$(at) ./test_files/ord_soumet_cclargs_call.sh -generate-autocomplete 2> $@ 1>/dev/null
$(build_dir)/gglargs_ord_soumet_completion.bash: $(build_dir)/gglargs
	$(call make_echo_generate_file)
	$(at) ./test_files/ord_soumet_gglargs_call.sh -generate-autocomplete 2> $@ 1>/dev/null

clean:
	$(at) rm -f build/*
	$(at) make -C $(cclargs_src_dir) --no-print-directory $@
