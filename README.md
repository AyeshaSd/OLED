# OLED
 This file is a basic addon for MATLAB to call the u8x8 library via the custom library method specified in the arduino support package. Tested the R2019b version
 target is to drive a single LED display connected to an arduino board.
 ## Pre-requisites
 This requires the u8x8 library to be added to the path below. 
 <code>C:\ProgramData\MATLAB\SupportPackages\R2019\3P.instrset\arduinoide.instrset\portable\sketchbook\libraries</code>
 ## Install:
 Add the OLED folder to the MATLAB paths for it to work.
 
 ## Creation example
 oled_display = addon(arduino_var,'OLED/OLED',flipMode_var);
 ## Deletion Example:
 clear screen; 
 ## Method Calls:
 setCursor(x,y);  
 print(%s); % Note String lenght maximum depends on the size of the font and your display.
 ## Tips:
 ### This file needs to be built with the correct constructor for your display. 
 I have used U8X8_SSD1306_128X64_ALT0_HW_I2C for my HW (0.96" OLED). Pick one that suits your display parameters.  
 Modify the line below in <code>OLED\\+arduinoioaddons\\+OLED\src\OLED.h</code>
 <pre><code>
 public:
    U8X8_SSD1306_128X64_ALT0_HW_I2C oled_lcd;
 </code></pre>
 
 ### If you wish to change the font:
 Modify the line below in <code>OLED\\+arduinoioaddons\\+OLED\src\OLED.h</code>
 <pre><code>		oled_lcd.setFont(u8x8_font_courR18_2x3_f);</code></pre>
 Utilize any font found in the U8x8 library (https://github.com/olikraus/u8g2/wiki/fntlist8x8).  
 Be mindful that some arduino boards' memory may not be large enough to support your selected font
 
