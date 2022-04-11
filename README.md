# PCI_conficuration_space_reader
A Master Boot Record program for intel x86, that will come useful in reading the PCI configuration space of various devices, located on the PCI bus.

# Assembly and usage
Run the make utility to assemble the .img file. Then insert a USB/Floppy drive into your PC and run the following command to write the .img file onto your inserted drive: ```sudo dd if=cspci.img of=/dev/sda && sync```. In place of /dev/sda should be the path to your drive in /dev.
Be aware of the fact that USB 3.0 drives are not guaranteed to work properly with this software.
