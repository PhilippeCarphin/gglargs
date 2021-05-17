UNAME := $(shell uname)
ifeq ($(UNAME),Linux)
	ECHO := echo -e
else
	ECHO := echo
endif

define make_echo_color_bold
	@case $(1) in \
		red)     $(ECHO) "\033[1;31m$(2)\033[0m" ;; \
		green)   $(ECHO) "\033[1;32m$(2)\033[0m" ;; \
		yellow)  $(ECHO) "\033[1;33m$(2)\033[0m" ;; \
		blue)    $(ECHO) "\033[1;34m$(2)\033[0m" ;; \
		magenta) $(ECHO) "\033[1;35m$(2)\033[0m" ;; \
		cyan)    $(ECHO) "\033[1;36m$(2)\033[0m" ;; \
		white)   $(ECHO) "\033[1;37m$(2)\033[0m" ;; \
		*)       $(ECHO) "\033[1;4m$(2)\033[0m"  ;; \
	esac
endef

define make_echo_color
	@case $(1) in \
		red)     $(ECHO) "\033[31m$(2)\033[0m" ;; \
		green)   $(ECHO) "\033[32m$(2)\033[0m" ;; \
		yellow)  $(ECHO) "\033[33m$(2)\033[0m" ;; \
		blue)    $(ECHO) "\033[34m$(2)\033[0m" ;; \
		magenta) $(ECHO) "\033[35m$(2)\033[0m" ;; \
		cyan)    $(ECHO) "\033[36m$(2)\033[0m" ;; \
		white)   $(ECHO) "\033[37m$(2)\033[0m" ;; \
		*)       $(ECHO) "\033[4m$(2)\033[0m"  ;; \
	esac
endef

define big_success
	@$(ECHO) "\033[1;32m✓\033[0m"
endef
define success
	@$(ECHO) "\033[32m✓\033[0m"
endef
define make_echo_build_c_object
	$(call make_echo_color,green,"Building C object $@")
endef
define make_echo_link_c_executable
	$(call make_echo_color_bold,green,"Linking C executable $@")
endef
define make_echo_generate_file
	$(call make_echo_color_bold,blue,"Generating $@")
endef
define make_echo_run_test
	$(call make_echo_color_bold,cyan,$(1))
endef
