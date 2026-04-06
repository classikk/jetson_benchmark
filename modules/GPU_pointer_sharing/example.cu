#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cuda.h>
#include <cuda_runtime.h>
#include <iostream>
#define HANDLE_FILE "cuda_ipc_handle.bin"

// Simple kernel to write a value into shared memory
__global__ void writeValue(int* ptr, int value) {
    *ptr = value;
}

// Simple kernel to read a value from shared memory
__global__ void readValue(int* ptr) {
    printf("Process B sees value: %d\n", *ptr);
}

void runProducer() {
    printf("[A] Producer starting...\n");

    int* devPtr;
    cudaMalloc(&devPtr, sizeof(int));

    // Write something into the memory
    writeValue<<<1,1>>>(devPtr, 12345);
    cudaDeviceSynchronize();

    // Export IPC handle
    cudaIpcMemHandle_t handle;
    cudaIpcGetMemHandle(&handle, devPtr);

    // Save handle to a file so Process B can read it
    FILE* f = fopen(HANDLE_FILE, "wb");
    fwrite(&handle, sizeof(handle), 1, f);
    fclose(f);

    printf("[A] Wrote IPC handle to file: %s\n", HANDLE_FILE);
    printf("[A] Now waiting so B can attach. Press Enter to exit.\n");
    getchar();

    cudaFree(devPtr);
}

void runConsumer() {
    printf("[B] Consumer starting...\n");

    // Read handle from file
    cudaIpcMemHandle_t handle;
    FILE* f = fopen(HANDLE_FILE, "rb");
    if (!f) {
        printf("[B] ERROR: Could not open handle file.\n");
        return;
    }
    fread(&handle, sizeof(handle), 1, f);
    fclose(f);

    // Open shared memory
    int* devPtr;
    cudaIpcOpenMemHandle((void**)&devPtr, handle, cudaIpcMemLazyEnablePeerAccess);
    std::cout << devPtr << "\n";
    // Read the value written by Process A
    readValue<<<1,1>>>(devPtr);
    cudaDeviceSynchronize();

    cudaIpcCloseMemHandle(devPtr);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage:\n");
        printf("  %s A   (run as producer)\n", argv[0]);
        printf("  %s B   (run as consumer)\n", argv[0]);
        return 1;
    }

    if (strcmp(argv[0], "") == 0) {} // avoid unused warning
    
    cudaSetDevice(0);
    cudaFree(0);   // forces creation of primary context

    if (strcmp(argv[1], "A") == 0) {
        runProducer();
    } else if (strcmp(argv[1], "B") == 0) {
        runConsumer();
    } else {
        printf("Unknown mode. Use A or B.\n");
    }

    return 0;
}
