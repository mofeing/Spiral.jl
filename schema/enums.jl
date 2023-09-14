using Pkg
Pkg.activate(@__DIR__)

using JSON
using MacroTools
using JuliaFormatter

schema = JSON.parsefile(joinpath(@__DIR__, "spirv.json"))

schema["spv"]["enum"][1]

tokens = map(schema["spv"]["enum"]) do enum
    name = enum["Name"]
    type = enum["Type"]
    values = enum["Values"]

    MacroTools.@q @enumx $(Symbol(name))::UInt32 begin
        $(
            map(sort(collect(values), by=last)) do (tokenname, tokenvalue)
                tokenname = Symbol(tokenname)
                :($tokenname = $tokenvalue)
            end...
        )
    end
end

target_file = joinpath(@__DIR__, "..", "src", "Enums.jl")
open(target_file, "w") do io
    write(io, "using EnumX\n\n")

    for token in tokens
        write(io, string(token) * "\n\n")
    end
end
JuliaFormatter.format_file(target_file)
