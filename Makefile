.PHONY: test test-repro test-busted

test: test-busted test-repro

test-busted:
	nvim --headless -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests/ {minimal_init='tests/minimal_init.lua'}" \
		-c "qa!"

test-repro:
	nvim -l tests/repro/scroll_shift_min.lua
