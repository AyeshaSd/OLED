/**
 * @file OLED.h
 *
 * Class definition for OLED class that wraps APIs of the U8x8 library for the Seeed Grove Beginner board v2
 *Universal 8bit Graphics Library (https://github.com/olikraus/u8g2/)
 * Based off https://www.mathworks.com/matlabcentral/fileexchange/72441-dht22-add-on-library-for-arduino
 * Guidance from  https://www.mathworks.com/help/supportpkg/arduinoio/ug/add-lcd-library.html#buvvedz-1	
 */

#include "LibraryBase.h"
#include "U8x8lib.h"
// MY functions as seen in OLED.m
// Command ID's
#define CREATE_OLED       0x01
#define DELETE_OLED       0x02
#define SET_CURSOR_OLED   0x03
#define PRINT_OLED        0x04

class OLED: public LibraryBase
{
public:
    U8X8_SSD1306_128X64_ALT0_HW_I2C oled_lcd;
    // from HelloWorld 
public:
    // Constructor
    OLED(MWArduinoClass& a)
    {
        // Define the library name
        libName = "OLED/OLED";
        // Register the library to the server
        a.registerLibrary(this);
    }
public:
    void commandHandler(byte cmdID, byte* dataIn, unsigned int payload_size)
    {
        switch (cmdID)
        {
            case CREATE_OLED: {
                // Get flip from dataIn?
                byte flipMode = dataIn[0];
                // Initialize OLED
                oled_lcd.begin();
		oled_lcd.setFlipMode(flipMode); // flipMode?
		oled_lcd.setFont(u8x8_font_courR18_2x3_f); //trail and error tested 
                oled_lcd.print("***"); // sample text
                // Send response
                sendResponseMsg(cmdID, 0, 0);//?
                break;
            }
            
            case DELETE_OLED: {
                // Make NULL
                oled_lcd = NULL;
                // Send response
                sendResponseMsg(cmdID, 0, 0);//?
                break;
            }
            
            case SET_CURSOR_OLED: {
		int x= dataIn[0];
		int y= dataIn[1];
                // Call set cursor method from u8x8 Libary
                oled_lcd.setCursor(x,y);
                sendResponseMsg(cmdID,0,0);//?
                break;
            }
            
            case PRINT_OLED: {
		// modified from  https://www.mathworks.com/help/supportpkg/arduinoio/ug/add-lcd-library.html#buvvedz-1		
  		char message[payload_size+1];
                for(byte k=0; k<(payload_size); k=k+1)
                {
                    message[k]=dataIn[k];
                }
		message[payload_size] = '\0';
		oled_lcd.clear();
		oled_lcd.print(message);
                sendResponseMsg(cmdID, 0,0);
                break;
            }
            
            default: {
                break;
            }
        }
    }
};