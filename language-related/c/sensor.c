#include <stdint.h>
#include <stdio.h>

/**
 * In a real embedded system, this would be a hardware memory address.
 * We simulate it here with a global variable for demonstration.
 * volatile tells the compiler not to optimize away reads/writes to this
 * variable.
 */
volatile uint8_t HARDWARE_REGISTER =
    0b00000001;  // Example: Sensor is initially ready

// Masks to isolate the specific bits we care about.
#define SENSOR_READY_BIT (1 << 0)
#define LED_PIN_BIT (1 << 7)

void check_and_toggle_led() {
  printf("Reading hardware register: 0x%02X\n", HARDWARE_REGISTER);
  // Use bitwise AND (&) to check if the sensor bit is set.
  if (HARDWARE_REGISTER & SENSOR_READY_BIT) {
    printf("Sensor is ready. Turning LED ON.\n");
    // Use bitwise OR (|) to set the LED bit high without affecting other bits.
    HARDWARE_REGISTER |= LED_PIN_BIT;
  } else {
    printf("Sensor is not ready. Turning LED OFF.\n");
    // Use bitwise AND with a NOT (~) to set the LED bit low.
    HARDWARE_REGISTER &= ~LED_PIN_BIT;
  }
  printf("Register after operation:  0x%02X\n\n", HARDWARE_REGISTER);
}

int main() {
  check_and_toggle_led();

  HARDWARE_REGISTER = 0b00000000;

  check_and_toggle_led();

  return 0;
}
