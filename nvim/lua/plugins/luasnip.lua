return {
    "L3MON4D3/LuaSnip",
    config = function()
        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node

        vim.keymap.set({ "i", "s" }, "<C-j>", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true })

        vim.keymap.set({ "i", "s" }, "<C-k>", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true })

        -- Makefile snippet
        local function makefile_snippet(lang, compiler, std, src_pattern, test_lib)
            local ext = lang == "c" and "c" or "cpp"

            return {
                t({ "CC := " .. compiler }),
                t({ "", "INCDIR := include" }),
                t({ "", "SRCDIR := src" }),
                t({ "", "BUILDDIR := build" }),
                t({ "", "OBJDIR := $(BUILDDIR)/obj" }),
                t({ "", "TESTDIR := tests" }),
                t({ "", "TESTBUILDDIR := $(TESTDIR)/build" }),
                t({ "", "TESTOBJDIR := $(TESTBUILDDIR)/obj" }),
                t({ "", "OPT := -O2" }),
                t({ "", "# Avoid in release flags -> -g3 -fsanitize=address" }),
                t({ "", "# Avoid in development flags -> -O2 -march=native" }),
                t({
                    "",
                    "CFLAGS := -std="
                        .. std
                        .. " -Wall -Wextra -I$(INCDIR) -pedantic -D_GNU_SOURCE \\",
                }),
                t({ "", "\t   -D_FORTIFY_SOURCE=2 -fstack-protector-all -fPIE -fPIC -MMD -MP \\" }),
                t({ "", "\t   $(OPT) -march=native \\" }),
                t({ "", "\t   -g3 -fsanitize=address" }),
                t({ "", "LDFLAGS := -pie" }),
                t({ "", "TESTLIB := -l" }),
                i(1, test_lib),
                t({ "", "" }),
                t({ "", "SRCS := $(wildcard $(SRCDIR)/" .. src_pattern .. ")" }),
                t({ "", "OBJS := $(patsubst $(SRCDIR)/%." .. ext .. ", $(OBJDIR)/%.o, $(SRCS))" }),
                t({ "", "DEPS := $(patsubst $(SRCDIR)/%." .. ext .. ", $(OBJDIR)/%.d, $(SRCS))" }),
                t({ "", "EXEC := $(BUILDDIR)/" }),
                i(2, "main"),
                t({ "", "" }),
                t({ "", "TESTSRCS := $(wildcard $(TESTDIR)/" .. src_pattern .. ")" }),
                t({
                    "",
                    "TESTOBJS := $(patsubst $(TESTDIR)/%."
                        .. ext
                        .. ", $(TESTOBJDIR)/%.o, $(TESTSRCS))",
                }),
                t({
                    "",
                    "TESTBINS := $(patsubst $(TESTOBJDIR)/%.o, $(TESTBUILDDIR)/%, $(TESTOBJS))",
                }),
                t({
                    "",
                    "TESTDEPS := $(patsubst $(TESTDIR)/%."
                        .. ext
                        .. ", $(TESTOBJDIR)/%.d, $(TESTSRCS))",
                }),
                t({ "", "" }),
                t({ "", "-include $(DEPS)" }),
                t({ "", "-include $(TESTDEPS)" }),
                t({ "", "" }),
                t({ "", ".PHONY: all run test clean-obj clean-test clean" }),
                t({ "", "" }),
                t({ "", "all: $(EXEC)" }),
                t({ "", "" }),
                t({ "", "run: $(EXEC)" }),
                t({ "", "\t@$(EXEC)" }),
                t({ "", "" }),
                t({ "", "$(EXEC): $(OBJS) | $(BUILDDIR)" }),
                t({ "", "\t$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@" }),
                t({ "", "" }),
                t({ "", "$(OBJDIR)/%.o: $(SRCDIR)/%." .. ext .. " | $(OBJDIR)" }),
                t({ "", "\t$(CC) $(CFLAGS) -c $< -o $@" }),
                t({ "", "" }),
                t({ "", "test: $(TESTBUILDDIR) $(TESTOBJS) $(TESTBINS)" }),
                t({ "", "\t@for test in $(TESTBINS); do \\" }),
                t({ "", "\t\t./$$test || exit 1; \\" }),
                t({ "", "\tdone" }),
                t({ "", "" }),
                t({ "", "$(TESTBUILDDIR)/%: $(TESTOBJDIR)/%.o $(OBJS) | $(TESTBUILDDIR)" }),
                t({
                    "",
                    "\t$(CC) $(CFLAGS) $(LDFLAGS) $< $(filter-out $(OBJDIR)/main.o, $(OBJS)) -o $@ $(TESTLIB)",
                }),
                t({ "", "" }),
                t({ "", "$(TESTOBJDIR)/%.o: $(TESTDIR)/%." .. ext .. " | $(TESTOBJDIR)" }),
                t({ "", "\t$(CC) $(CFLAGS) -c $< -o $@" }),
                t({ "", "" }),
                t({ "", "$(BUILDDIR) $(OBJDIR) $(TESTBUILDDIR) $(TESTOBJDIR):" }),
                t({ "", "\tmkdir -p $@" }),
                t({ "", "" }),
                t({ "", "clean-obj:" }),
                t({ "", "\trm -rf $(OBJDIR) $(TESTOBJDIR)" }),
                t({ "", "" }),
                t({ "", "clean-test:" }),
                t({ "", "\trm -rf $(TESTBINS) $(TESTOBJDIR)" }),
                t({ "", "" }),
                t({ "", "clean: clean-obj clean-test" }),
                t({ "", "\trm $(EXEC)" }),
                t({ "", "" }),
                t({ "", "# only if passing arguments are needed" }),
                t({ "", "# %:" }),
                t({ "", "# \t@:" }),
            }
        end

        ls.add_snippets("make", {
            s("makefile_c", makefile_snippet("c", "clang", "c99", "*.c", "criterion")),
            s("makefile_cpp", makefile_snippet("c++", "clang++", "c++17", "*.cpp", "gtest")),
        })

        ls.add_snippets("sh", {
            s("bashpath", {
                t({ "#!/usr/bin/env bash" }),
            }),
        })

        -- Typst snippet
        ls.add_snippets("typst", {
            s("typst", {
                t({ "#set text(" }),
                t({ "", '    font: "Monaspace Argon NF",' }),
                t({ "", "    size: 16pt," }),
                t({ "", '    weight: "semibold",' }),
                t({ "", "    features: (" }),
                t({ "", '        "calt",' }),
                t({ "", '        "liga",' }),
                t({ "", '        "ss01",' }),
                t({ "", '        "ss02",' }),
                t({ "", '        "ss03",' }),
                t({ "", '        "ss04",' }),
                t({ "", '        "ss05",' }),
                t({ "", '        "ss06",' }),
                t({ "", '        "ss07",' }),
                t({ "", '        "ss08",' }),
                t({ "", '        "ss09",' }),
                t({ "", "    )," }),
                t({ "", ")" }),
                t({ "", "" }),
                t({ "", "#align(center)[#underline(text(" }),
                t({ "", '        weight: "bold",' }),
                t({ "", "        size: 24pt," }),
                t({ "", "        fill: blue," }),
                t({ "", "    )[" }),
                i(1, "Typst"),
                t({ "])" }),
                t({ "", "]" }),
            }),
        })
    end,
}
