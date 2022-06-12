-- See https://github.com/Dot-lua/TypeWriter/wiki/package.info.lua-format for more info

return { InfoVersion = 1, -- Dont touch this

    ID = "Bootstrap", -- A unique id 
    Name = "Bootstrap",
    Description = "Bootstrap for BrowserView",
    Version = "1.0.0",

    Author = {
        Developers = {
            "CoreByte"
        },
        Contributors = {}
    },

    Dependencies = {
        Luvit = {
            "creationix/coro-http",
            "luvit/secure-socket"
        },
        Git = {},
        Dua = {}
    },

    Contact = {
        Website = "",
        Source = "",
        Socials = {}
    },

    Entrypoints = {
        Main = "ga.corebyte.BrowserView.Wrapper.Test"
    }

}
