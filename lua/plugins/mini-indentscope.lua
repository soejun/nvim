return {
  "nvim-mini/mini.indentscope",
  opts = {
    draw = {
      delay = 50,
      -- no animation: same as MiniIndentscope.gen_animation.none()
      animation = function()
        return 0
      end,
    },
  },
}
