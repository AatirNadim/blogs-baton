#include <stddef.h>
#include <stdint.h>


typedef struct ProcessedImage {
  uint8_t *ptr;
  size_t size;
} ProcessedImage;


ProcessedImage apply_greyscale(const uint8_t *image_bytes, size_t size);
ProcessedImage apply_watermark(const uint8_t *main_image_bytes, size_t main_size, const uint8_t *watermark_image_bytes, size_t watermark_size);
void free_memory(uint8_t *ptr, size_t size);
