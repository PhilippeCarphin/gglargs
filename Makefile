include colors.mk

build_dir = build
cclargs_src_dir = cclargs_src

.PHONY: $(build_dir)/ord_soumet.cclargs $(build_dir)/ord_soumet.gglargs


all: $(build_dir)/gglargs $(build_dir)/cclargs

# EXECUTABLE TARGETS
$(build_dir)/cclargs: $(build_dir)/cclargs_lite.o $(build_dir)/main.o
	$(call make_echo_link_c_executable)
	@gcc $^ -o $@
	@echo "Built target $@"

$(build_dir)/gglargs: gglargs.go cmd/gglargs/main.go
	$(call make_echo_generate_file)
	@cd build && go build ../cmd/gglargs
	@echo "Built target $@"

# TEST TARGETS
check: check_gounittest check_output check_completion check_smm check_cunittest

# Run all Test* go functions in all test_*.go files
check_gounittest:
	$(call make_echo_run_test,"Running GO unit tests")
	@go test ./...
	$(call success)

# Compare normal outputs
check_output: $(build_dir)/cclargs_output.sh $(build_dir)/gglargs_output.sh
	$(call make_echo_run_test,"Comparng output $^")
	@diff $^
	$(call success)
$(build_dir)/cclargs_output.sh: $(build_dir)/cclargs
	$(call make_echo_generate_file)
	@CCLARGS_GENERATE_AUTOCOMPLETE="" ./test_files/ord_soumet_cclargs_call.sh arg1 arg2 arg3 > $@ 2>/dev/null
$(build_dir)/gglargs_output.sh: $(build_dir)/gglargs
	$(call make_echo_generate_file)
	@GGLARGS_GENERATE_AUTOCOMPLETE="" ./test_files/ord_soumet_gglargs_call.sh arg1 arg2 arg3 | sed 's/GGLARGS/CCLARGS/g' > $@ 2>/dev/null

# Compare generated autocomplete scripts
check_completion: $(build_dir)/cclargs_ord_soumet_completion.bash $(build_dir)/gglargs_ord_soumet_completion.bash
	$(call make_echo_run_test,"Comparng output $^")
	@diff $^
	$(call success)
$(build_dir)/cclargs_ord_soumet_completion.bash: $(build_dir)/cclargs
	$(call make_echo_generate_file)
	@CCLARGS_GENERATE_AUTOCOMPLETE="1" ./test_files/ord_soumet_cclargs_call.sh arg1 arg2 arg3 >> $@ 2>/dev/null
$(build_dir)/gglargs_ord_soumet_completion.bash: $(build_dir)/gglargs
	$(call make_echo_generate_file)
	@GGLARGS_GENERATE_AUTOCOMPLETE="1" ./test_files/ord_soumet_gglargs_call.sh arg1 arg2 arg3 >> $@


# Unit tests for functions in cclargs_lite.c
check_cunittest: $(build_dir)/cunittest
	$(call make_echo_run_test,"Running unit test executable $<")
	@./$<
	$(call success)
$(build_dir)/cunittest: $(build_dir)/cclargs_lite.o $(build_dir)/test.o
	$(call make_echo_link_c_executable)
	@gcc $^ -o $@

# Demo for `*pttmp--`
.PHONY: smm
$(build_dir)/smm: $(build_dir)/star_minus_minus.o
	$(call make_echo_link_c_executable)
	@gcc $^ -o $@
check_smm: $(build_dir)/smm
	$(call make_echo_run_test,"Running demo for '*pttmp--'")
	@./$<

# RULES
$(build_dir)/%.o: $(cclargs_src_dir)/%.c
	$(call make_echo_build_c_object)
	@gcc -c -DNOUI -DVERSION=1 $< -o $@

clean:
	rm -f smm cclargs gglargs a.txt b.txt build/*
