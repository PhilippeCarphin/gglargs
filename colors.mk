
define make_echo_color_bold
	@case $(1) in \
		red)     echo "\033[1;31m$(2)\033[0m" ;; \
		green)   echo "\033[1;32m$(2)\033[0m" ;; \
		yellow)  echo "\033[1;33m$(2)\033[0m" ;; \
		blue)    echo "\033[1;34m$(2)\033[0m" ;; \
		magenta) echo "\033[1;35m$(2)\033[0m" ;; \
		cyan)    echo "\033[1;36m$(2)\033[0m" ;; \
		white)   echo "\033[1;37m$(2)\033[0m" ;; \
		*)       echo "\033[1;4m$(2)\033[0m"  ;; \
	esac
endef

define make_echo_color
	@case $(1) in \
		red)     echo "\033[31m$(2)\033[0m" ;; \
		green)   echo "\033[32m$(2)\033[0m" ;; \
		yellow)  echo "\033[33m$(2)\033[0m" ;; \
		blue)    echo "\033[34m$(2)\033[0m" ;; \
		magenta) echo "\033[35m$(2)\033[0m" ;; \
		cyan)    echo "\033[36m$(2)\033[0m" ;; \
		white)   echo "\033[37m$(2)\033[0m" ;; \
		*)       echo "\033[4m$(2)\033[0m"  ;; \
	esac
endef

define big_success
	@echo "\033[1;32m✓\033[0m"
endef
define success
	@echo "\033[32m✓\033[0m"
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
