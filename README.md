# Spiral

A Julia library for manipulating SPIR-V.

## Roadmap

- [ ] Read/store SPIR-V modules in binary form
- [ ] Store SPIR-V modules in text form
- [ ] Parse SPIR-V modules in text form
- [ ] Translate [SPIRV-Tools](https://github.com/KhronosGroup/SPIRV-Tools) to Julia
  - [ ] Translate validator
  - [ ] Translate optimization passes
  - [ ] Translate linker
  - [ ] Translate fuzzer
  - [ ] Translate diff
- [ ] Implement codegen backend for SPIR-V
  - [ ] Delimit supported Julia language subset
  - [ ] Research GPUCompiler, SPIRV.jl
- [ ] Design a DSL for writing shaders
