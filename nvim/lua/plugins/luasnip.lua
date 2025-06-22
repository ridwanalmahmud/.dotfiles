return {
    "L3MON4D3/LuaSnip",
    config = function()
        local ls = require "luasnip"
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node

        vim.keymap.set({ "i", "s" }, "<A-j>", function ()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true })

        vim.keymap.set({ "i", "s" }, "<A-k>", function ()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true })

        ls.add_snippets("make", {
            s(
              "makefile_basic",
              {
                t({ "CC=gcc" }),
                t({ "", "ICDIRS=-I" }),
                t({ "", "OPT=-O1" }),
                t({ "", "CFLAGS=-Wall -Wextra -g $(INCDIRS) $(OPT)" }),
                t({ "", "" }),
                t({ "", "CFILES=src/" }),i(1, "main.c"),
                t({ "", "BINARY=bin/" }),i(2, "main"),
                t({ "", "" }),
                t({ "", "all: $(BINARY)" }),
                t({ "", "" }),
                t({ "", "$(BINARY):" }),
                t({ "", "\t$(CC) $(CFLAGS) $(CFILES) -o $@" }),
                t({ "", "" }),
                t({ "", "run:" }),
                t({ "", "\t$(BINARY)" }),
                t({ "", "" }),
                t({ "", "clean:" }),
                t({ "", "\trm -f $(BINARY)" }),
              },
              {
                priority = 100,
                description = "Basic Makefile with variables",
                keywords = {"makefile", "c", "compile"},
              }
            )
        })

    end
}
