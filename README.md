# Shawazu GB Dumper Hardware
Custom Shawazu PCB for dumping GB / GBC / GBA games and savegames.  
This is an easy to solder DIY project.

<img src="https://github.com/tihmstar/shawazu-gb-dumper-hardware/blob/master/images/front.jpg?raw=true" width="300" />
<img src="https://github.com/tihmstar/shawazu-gb-dumper-hardware/blob/master/images/back.jpg?raw=true" width="300" />


# Voltage switch 
GB / GBC cartridges run on 5V.  
GBA cartridges run on 3.3V.  

Always set the correct voltage **before** plugging in the cartridge!

# Bill Of Materials
* 1 x Raspberry Pi Pico
* 7 x BOB-12009 (4 bit level shifter)
* 1 x Switch (3 pin 2 position panel, 3mm)
* 1 x 32pin Gameboy Cartridge Connector
* 2 x wires

It is important that the pico has the footprint of an original pico. It is possible to use cheap USB-C picos from china but original is recommended.  
The project uses GPIO23 as a bidirectional data pin, which on a raspberry pi pico is connected to the on-board SMPS Power Save pin. While doing this is kinda out of spec, it works fine in practise. However, on some cheap USB-C picos from china it can cause bootloops and thus may be problematic. It worked fine for me most of the time, but a few picos had the bootloop issue.

The switches i used are https://www.amazon.de/gp/product/B09TVFF6KW. They fit like 95%. Just a little squeezing is needed.  

For the connector, just pick one from AliExpress. They should be pretty much all the same, so any that looks like it fits should work.

# Assembly

A video tutorial on how to assembly the board is available here:
<iframe width="560" height="315" src="https://www.youtube.com/embed/dES8QW8xg44?si=9sVKwl2QdlvckcLd" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

In General:  
1) **Flash and test the pico!!!!!**
2) Solder the 7 level shifter
3) Solder the connector
4) Solder the switch
5) Solder the pico (front side only)
6) **Test the pico again!!!**
7) Solder to the pico testpoint through the whole in the back of the PCB
8) **Test the pico again!!!**
9) Optional 1: Solder the TP near the switch on the PCB to the LED of the Pico (check video)
10) **Test the pico again!!!**
11) Optional 2: (check video)
- Remove the two resistors on the pico
- **Test the pico again!!!**
- Solder the upper pad of the resistor placeholder on the PCB to the correct pad where you removed the resistors on the pico (check video)
12) Finally: test the finished assembly

**Make sure to test the pico over and over during assembly! Otherwise it will be extremely difficult to debug what is wrong in case the final thing doesn't _just work_!!!!**  

### "Testing the pico"
Flash the [Shawazu firmware](https://github.com/tihmstar/shawazu-gb-dumper) to your pico and make sure a drive called _SHAWAZU_ appears when you plug it in. The drive should contain one file _Info.txt_ which says that no cartridge is connected. After the relevant assembly steps connect the pico again and check if the drive with the file still shows up.  
If the drive doesn't show up before assembly and you realize the pico is dead, do no solder it on the PCB.  
**Once soldered to the PCB it is ~~impossible~~ extremely diffucult to remove the pico without damaging anything!!!**  
If the drive showed up before assembly but does no longer show up after a certain step, go back and debug/fix your previous assembly step. If you don't test the pico after every modification it will be very hard to tell which step exactly causes the failure!

# Optional solders
There are 2 so called "optional solders" on the board. You will need to solder both correctly if you want to have all features of shawazu. Let's take a look at what each of them do

## Optional solder 1
This solder point refers to the testpoint which is closer to the power switch on the PCB. The TP needs to be soldered to GPIO25, which is used by the LED. The LED seems not to interfere and can be left on the board.  
There are multiple revisions of the PCB with different pinout.

### Optional solder: PICO_<span style="text-decoration:overline">CS</span>
**You pretty much always want to solder this!**

The negated chipselect line is set low (enabled) when talking to GB / GBC ROM and set high (disabled) when talking to GB / GBC SRAM. Some cartridges (especially those without savestate) may ignore this so those can be talked to without this. It is possible to enable the solderbridge to ground this pin to always have the ROM enabled, but this may cause issues in some GB / GBC games.

On GBA games this line is used to "clock" the bus for transfer to ROM (and flash/eeprom savestate).   
**Without this line GBA cartridges will not work**.

### Optional solder: PICO_CLK
**Needed for Gameboy Camera. Other Cartridges may work without this**  

The gameboy CLK line is rarely used by any GB / GBC cartridge. The only cartridge i have tested that actually needs this line is the Gameboy Camera. If you don't plan on using the Gameboy Camera it is fine to leave this alone. Do NOT ground this line with the solderbridge.

As far as i'm aware, GBA does not use the CLK.


## Optional solder 2
This solder point refers the the upper pad of the resistor placeholder. Rev 4 has a dedicated TP on on the PCB labled as "<span style="text-decoration:overline">CS2</span>", which is connected to the upper pad of the resistor placeholder. Earlier revisions do not have a dedicated TP, there you just solder to the upper resistor placeholder. 
This point should be connected to GPIO24 on the pico. That GPIO is normally used to detect whether 5V (eg via USB) is available, or if the pico is powered by 3.3V. To use the GPIO is is **required** to remove 2 resistors.   
**Without removing the two resistors you cannot use the GPIO!!!!** 


### Optional solder: <span style="text-decoration:overline">CS2</span>
**Solder for GBA savegame support. If you don't care about GBA, place a 10k resistor on the PCB**

On GB / GBC cartridges this pin is called _<span style="text-decoration:overline">RST</span>_ and used to reset the Gameboy CPU from the cartridge. Most cartridges do not care about this pin, but some (Gameboy Camera) want this to be pulled high.

On GBA this pin is called <span style="text-decoration:overline">CS2</span> and is used to "clock" the SRAM. Without this pin SRAM is not accessible and thus savegame of some GBA cartridges cannot be read / written. Some cartridges which use EEPROM / Flash based savegame may not need this pin, but if you plan to use GBA cartridges it is recommended to solder this.