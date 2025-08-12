return {
    "askfiy/http-client.nvim",
    ft = "http",
    config = function()
        require("http-client").setup()
        require("http-client")
    end,
}
