package llm

//go:generate git submodule init

//go:generate git submodule update --force ggml
//go:generate cmake -S ggml -B ggml/build/cpu -DLLAMA_K_QUANTS=on
//go:generate cmake --build ggml/build/cpu --target server --config Release
//go:generate mv ggml/build/cpu/bin/server ggml/build/cpu/bin/ollama-runner

//go:generate git submodule update --force gguf
//go:generate cmake -S gguf -B gguf/build/cpu -DLLAMA_K_QUANTS=on
//go:generate cmake --build gguf/build/cpu --target server --config Release
//go:generate mv gguf/build/cpu/bin/server gguf/build/cpu/bin/ollama-runner

//go:generate cmake -S ggml -B ggml/build/cuda -DLLAMA_CUBLAS=on -DLLAMA_ACCELERATE=on -DLLAMA_K_QUANTS=on
//go:generate cmake --build ggml/build/cuda --target server --config Release
//go:generate mv ggml/build/cuda/bin/server ggml/build/cuda/bin/ollama-runner
//go:generate cmake -S gguf -B gguf/build/cuda -DLLAMA_CUBLAS=on -DLLAMA_ACCELERATE=on -DLLAMA_K_QUANTS=on
//go:generate cmake --build gguf/build/cuda --target server --config Release
//go:generate mv gguf/build/cuda/bin/server gguf/build/cuda/bin/ollama-runner
