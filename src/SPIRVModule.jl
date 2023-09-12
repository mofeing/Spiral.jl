import Serialization: Serialization, serialize, deserialize

const SPIRV_MODULE_MAGIC_NUMBER::SPIRV_WORD = 0x07230203
const SPIRV_GENERATOR_MAGIC_NUMBER::SPIRV_WORD = 0x0

struct SPIRVModule
    version::VersionNumber

    "From `OpCapability` instructions."
    capabilities::Set{Capability.T}

    "From optional `OpExtension` instructions."
    extensions::Vector

    "From optional `OpExtInstImport` instructions."
    extinstr_imports::Vector

    "From single `OpMemoryModel` instruction."
    memory_model::MemoryModel.T

    "From `OpEntryPoint` instructions."
    entrypoints::Vector

    "From `OpExecutionMode` or `OpExecutionModeId`."
    execution_modes

    debug
    annotations
    type_declarations
    function_declarations
    function_definitions
    ...
end

function serialize(stream::IO, mod::SPIRVModule)
    # magic number
    serialize(stream, SPIRV_MODULE_MAGIC_NUMBER)

    # version number: 0 | major | minor | 0
    @assert 0 <= mod.version.major <= 0xFF
    @assert 0 <= mod.version.minor <= 0xFF
    serialize(stream, UInt8[
        0x00,
        reinterpret(UInt8, [mod.version.major])|>last,
        reinterpret(UInt8, [mod.version.minor])|>last,
        0x00,
    ])

    # generator's magic number
    # NOTE currently 0, but can be registered at https://github.com/KhronosGroup/SPIRV-Headers
    serialize(stream, SPIRV_GENERATOR_MAGIC_NUMBER)

    # TODO bound
    bound::SPIRV_WORD = 0
    serialize(stream, bound)

    # reserved (for instruction schema)
    serialize(stream, SPIRV_WORD(0))

    # TODO sequence of instructions
end

function deserialize(stream, ::Type{SPIRVModule})
    # magic number
    magic_number = read(stream, SPIRV_WORD)
    @assert magic_number == SPIRV_MODULE_MAGIC_NUMBER

    # version number
    version = read(stream, 4)
    @assert first(version) == last(version) == 0x00
    version = VersionNumber(version[2], version[3], 0)

    # generator's magic number
    generator_magic_number = read(stream, SPIRV_WORD)

    # TODO bounds

    # reserved (for instruction schema)
    _ = read(stream, SPIRV_WORD)

    # TODO ...

    # Module(version, ...)
end