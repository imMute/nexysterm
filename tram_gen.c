#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <stdint.h>



int main(int argc, char *argv[])
{
    uint16_t addr;
    uint8_t chr = 0x00;
    uint8_t color = (0xFC);
    
    for (addr = 0 ; addr < (100 * 50) ; addr++){
        fprintf(stdout, "%c%c%c%c", ((addr & 0xFF00) >> 8), (addr & 0xFF), color, chr);
    }
}
