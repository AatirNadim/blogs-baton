#include <stdio.h>
#include <stdlib.h>  // For exit()

int main(int argc, char *argv[]) {
  // argc is the argument count, argv is the array of argument strings.
  // argv[0] is the program name, argv[1] would be the filename.
  if (argc < 2) {
    fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
    exit(1);
  }

  const char *filename = argv[1];
  FILE *file_pointer;

  // `fopen` is a C standard library function that asks the OS to open a file.
  // "r" means open for reading.
  file_pointer = fopen(filename, "r");

  // CRITICAL: Always check if the OS call succeeded.
  // fopen returns NULL if the file can't be opened (doesn't exist, no
  // permissions, etc.)
  if (file_pointer == NULL) {
    perror("Error opening file");  // perror prints a system error message
    exit(1);
  }

  // Read the file character by character until we reach the End-Of-File (EOF).
  int character;
  while ((character = fgetc(file_pointer)) != EOF) {
    // `putchar` prints a single character to standard output (the console).
    putchar(character);
  }

  // `fclose` tells the OS we are done with the file, so it can free resources.
  fclose(file_pointer);

  return 0;
}