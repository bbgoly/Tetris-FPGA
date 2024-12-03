# Tetris on a DE10-Lite

## Dev Notes

-   To open this project in Quartus (you can do this through remote lab if at home, if needed), select VGATest.qpf in the prompt that appears after clicking Open Project
-   The following files and folders contain code relevant to the VGA stuff that I have been testing **(ignore everything else, I honestly don't know why there are so many random files)**:

    -   <ins>**WORKING VGA CODE:**</ins> The v folder, which contains **vga_controller.v**, **vga_pll.v** (the PLL used to drive the clock of the VGA driver), and **video_sync_generator.v** (creates the VSYNC and HSYNC signals for the VGA driver).
        -   This folder contains the working VGA driver from the internet, and is what I am referencing to make my own VGA driver with a frame buffer
        -   **vga_controller.v** contains the VGA driver code and uses **video_sync_generator.v** internally
        -   **DE10_LITE_VGA_PATTERN.v** is the top level component (main entrypoint) that came with these files, and is what you should run if you want to see working VGA. It also connects the PLL to **vga_controller.v**
    -   <ins>**MY CODE:**</ins> **vga_controller_framebuffer.v** and **main.v**

        -   This is gonna be the actual vga controller I ship to our main Tetris project, and everything I add to this file is stuff I know will work. It is essentially a rewrite of **vga_controller.v** that makes sense (since **vga_controller.v** has a weird implementation that is hard to understand), but still uses **vga_sync_generator.v** internally. To keep this file clean, all my testing actually happens under **vga_controller_framebuffer_ex.v**
        -   Currently, main.v **acts like the entrypoint for vga_controller_framebuffer_ex.v**
        -   **vga_controller_framebuffer.v** is entirely commented out to allow the test file to compile (see **vga_controller_framebuffer_ex.v**)

    -   <ins>**TEST FILE FOR MY CODE:**</ins> **vga_conrtoller_framebuffer_ex.v**
        -   Desperate attempt at trying to string together a working proof of concept code for using a framebuffer in VGA
        -   I feel like I'm almost there and theres some hidden bug that I can't find, so I have been trying random stuff with some help from ChatGPT to get it working
        -   If this file ends up working, then cleanly porting it to **vga_controller_framebuffer.v** will be easy and we can finally begin working on the rest of the Tetris stuff
