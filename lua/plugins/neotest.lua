-- Neotest adapters + their debug strategies.
--
-- The test.core and dap.core extras already provide neotest and nvim-dap.
-- The lang.python extra wires neotest-python + nvim-dap-python (debugpy), and
-- lang.typescript registers the `pwa-node` DAP adapter (js-debug-adapter).
--
-- This file adds the Vitest adapter for JS/TS. Its dap strategy emits a
-- `pwa-node` launch config, so `<leader>td` (Debug Nearest) reuses the adapter
-- that lang.typescript already set up -- no extra debug wiring needed.
return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        ["neotest-vitest"] = {},
        -- Pin to pytest instead of neotest-python's unittest autodetect.
        ["neotest-python"] = {
          runner = "pytest",
        },
      },
    },
  },
}
