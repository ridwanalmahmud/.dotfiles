return {
    "L3MON4D3/LuaSnip",
    config = function()
        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node

        vim.keymap.set({ "i", "s" }, "<A-j>", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true })

        vim.keymap.set({ "i", "s" }, "<A-k>", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true })

        -- Makefile snippet
        ls.add_snippets("make", {
            s("makefile_basic", {
                t({ "CC=clang" }),
                t({ "", "INCDIR=include" }),
                t({ "", "SRCDIR=src" }),
                t({ "", "BUILDDIR=build" }),
                t({ "", "OBJDIR=$(BUILDDIR)/obj" }),
                t({ "", "TESTDIR=tests" }),
                t({ "", "TESTOBJDIR=$(TESTDIR)/obj" }),
                t({ "", "TESTBUILDDIR=$(TESTDIR)/build" }),
                t({ "", "OPT=-O2" }),
                t({ "", "# Avoid in release flags -> -g -fsanitize=address" }),
                t({ "", "# Avoid in development flags -> -O2" }),
                t({ "", "CFLAGS=-std=c99 -Wall -Wextra -I$(INCDIR) -pipe -pedantic -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE $(OPT) \\" }),
                t({ "", "\t   -fstack-protector-all -fPIE -MMD -MP \\" }),
                t({ "", "\t   -g -fsanitize=address" }),
                t({ "", "LDFLAGS=-pie" }),
                t({ "", "" }),
                t({ "", "SRCS=$(wildcard $(SRCDIR)/*.c)" }),
                t({ "", "OBJS=$(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SRCS))" }),
                t({ "", "DEPS=$(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.d, $(SRCS))" }),
                t({ "", "EXEC=$(BUILDDIR)/" }),
                i(1, "main"),
                t({ "", "" }),
                t({ "", "TESTSRCS=$(wildcard $(TESTDIR)/*.c)" }),
                t({ "", "TESTOBJS=$(patsubst $(TESTDIR)/%.c, $(TESTOBJDIR)/%.o, $(TESTSRCS))" }),
                t({ "", "TESTBINS=$(patsubst $(TESTOBJDIR)/%.o, $(TESTBUILDDIR)/%, $(TESTOBJS))" }),
                t({ "", "" }),
                t({ "", "-include $(DEPS)" }),
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
                t({ "", "$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR)" }),
                t({ "", "\t$(CC) $(CFLAGS) -c $< -o $@" }),
                t({ "", "" }),
                t({ "", "test: $(TESTBUILDDIR) $(TESTOBJS) $(TESTBINS)" }),
                t({ "", "\t@for test in $(TESTBINS); do \\" }),
                t({ "", "\t\t./$$test || exit 1; \\" }),
                t({ "", "\tdone" }),
                t({ "", "" }),
                t({ "", "$(TESTBUILDDIR)/%: $(TESTOBJDIR)/%.o $(OBJS) | $(TESTBUILDDIR)" }),
                t({ "", "\t$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) $< -o $@" }),
                t({ "", "" }),
                t({ "", "$(TESTOBJDIR)/%.o: $(TESTDIR)/%.c | $(TESTOBJDIR)" }),
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
            }, {
                priority = 100,
                description = "Basic Makefile with variables",
                keywords = { "makefile", "c", "compile" },
            }),
        })
    end,
}
