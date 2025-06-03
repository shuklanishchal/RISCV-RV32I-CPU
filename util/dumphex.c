/*

Helper file to convert compiled binary to .hex file for SystemVerilog usage

*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Predefine size for file memory allocation. Make sure it is always bigger than the actual file size.
unsigned int size = (1<<16);

// Define input file
FILE *input_file;

// Define output file default name
char output_filename[1024] = "out.hex";

int main(int argc, char *argv[]) {
    int i = 1;

    // Loop through arguments, looking for input and output files
    while (i < argc) {
        if (!strcmp(argv[i], "-i")) {

            // Store input file, throw error if input file does not exist
            input_file = fopen(argv[i + 1], "r");
            if (!input_file)
                printf("Cannot open: %s\n", argv[i + 1]);
            i++;
        }
        else if (!strcmp(argv[i], "-o")) {

            // Override output file name
            strcpy(output_filename, argv[i + 1]);
            i++;
        }
        else {
            printf("Cannot parse: %s\n", argv[i]);
            exit(1);
        }
        i++;
    }      
    if (!input_file) {
        printf("Cannot open input\n");
        exit(2);
    }

    // Allocate memory for data to be read in
    unsigned char *data = malloc(size);
    memset(data, 0, size);
    int amount = fread(data, 1, size, input_file);
    if (input_file != stdin)
        fclose(input_file);

    // Determine true file size
    int true_size = amount;
    while (data[true_size - 1] == 0 && true_size  > 0)
        --true_size;

    uint32_t *data32 = (uint32_t *) data;

    // Create output file
    FILE *output_file;
    output_file = fopen(output_filename, "w");
    if (!output_file) {
        printf("Failure to create %s\n", output_filename);
        exit(2);
    }

    // Write hex data to output file
    i = 0;
    while (i < true_size) {
        fprintf(output_file, "%8.8x\n", data32[i / 4]);
        i += 4;
    }
    fclose(output_file);
    
    return 0;
}

