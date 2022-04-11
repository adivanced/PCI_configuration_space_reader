# PCI_conficuration_space_reader
A Master Boot Record program for intel x86, that will come useful in reading the PCI configuration space of various devices, located on the PCI bus.

# Assembly and usage
Run the make utility to assemble the .img file. Then insert a USB/Floppy drive into your PC and run the following command to write the .img file onto your inserted drive: ```sudo dd if=cspci.img of=/dev/sda && sync```. In place of /dev/sda should be the path to your drive in /dev.

Be aware of the fact that USB 3.0 drives are not guaranteed to work properly with this software.

After writing your image file onto your drive, proceed to the BIOS, and put your drive on top of the boot priority list. If using UEFI, do not forget to enable the legacy boot mode first.
Note that this software is not bootable without your UEFI supporting the legacy boot mode.
After setting the proper boot priority, exit your BIOS and wait for the program to start.
If you did everything according to the instructions given above, the program should boot without a problem and give you a view at your PCI devices.
