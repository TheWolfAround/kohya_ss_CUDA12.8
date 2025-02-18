# Kohya's GUI

This is a fork from [Kohya's GUI](https://github.com/bmaltais/kohya_ss) focusing Nvidia GPUs. Whole packages updated to run with newer versions of Python, CUDA and Pytorch. Everything is tested on Windows and Linux.

The GUI allows you to set the training parameters and generate and run the required CLI commands to train the model.

## Table of Contents

- [Kohya's GUI](#kohyas-gui)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
    - [Windows](#windows)
      - [Windows Pre-requirements](#windows-pre-requirements)
      - [Setup Windows](#setup-windows)
    - [Linux](#linux)
      - [Linux Pre-requirements](#linux-pre-requirements)
      - [Setup Linux](#setup-linux)
  - [Starting GUI Service](#starting-gui-service)
    - [Launching the GUI on Windows](#launching-the-gui-on-windows)
    - [Launching the GUI on Linux and macOS](#launching-the-gui-on-linux)
  - [Custom Path Defaults](#custom-path-defaults)
  - [LoRA](#lora)
  - [Sample image generation during training](#sample-image-generation-during-training)
  - [Troubleshooting](#troubleshooting)
    - [Page File Limit](#page-file-limit)
    - [No module called tkinter](#no-module-called-tkinter)
    - [LORA Training on TESLA V100 - GPU Utilization Issue](#lora-training-on-tesla-v100---gpu-utilization-issue)
      - [Issue Summary](#issue-summary)
      - [Potential Solutions](#potential-solutions)
  - [SDXL training](#sdxl-training)
  - [Masked loss](#masked-loss)
  - [Change History](#change-history)

## Installation

### Windows

#### Windows Pre-requirements

To install the necessary dependencies on a Windows system, follow these steps:

1. Install your Nvidia drivers: https://www.nvidia.com/en-us/drivers/
2. Python version should be greater than 3.11.0 and less then 3.13.0.  
You can download and install appropriate python version here: https://www.python.org/ftp/python  
I recommend Python3.12.9: https://www.python.org/ftp/python/3.12.9/python-3.12.9-amd64.exe

#### Setup Windows

To set up the project, follow these steps:

1. Run `git clone https://github.com/TheWolfAround/kohya_ss_CUDA12.8.git --recursive`
2. Change directory `cd kohya_ss_CUDA12.8.`
3. Run `install_python_dependencies.bat` and wait for the installation to complete.
4. Run `gui.bat`

### Linux

#### Linux Pre-requirements

1. Install your Nvidia drivers. Installing Nvidia drivers on Linux is a little bit complicated.  
Watch this video to install Nvidia driver on Linux: https://www.youtube.com/watch?v=mOIzYxVD4d0
2. Python version should be greater than 3.11.0 and less then 3.13.0.  
**If your Python version is not in this range**, you can compile appropriate python version from its source code.  
Watch this video to compile appropriate Python version: https://www.youtube.com/watch?v=RdhmJNDADNc  
I recommend for you to compile Python3.12.9.

#### Setup Linux

1. Run `git clone https://github.com/TheWolfAround/kohya_ss_CUDA12.8.git --recursive`
2. Change directory `cd kohya_ss_CUDA12.8.`
3. Make installation script an executable: `chmod +x install_python_dependencies.sh`
4. Run `./install_python_dependencies.sh` and wait for the installation to complete.
3. Make GUI script an executable: `chmod +x gui.sh`
4. Run `gui.bat`

## Starting GUI Service

To launch the GUI service, you can use the provided scripts or run the `kohya_gui.py` script directly. Use the command line arguments listed below to configure the underlying service.

```text
--listen: Specify the IP address to listen on for connections to Gradio.
--username: Set a username for authentication.
--password: Set a password for authentication.
--server_port: Define the port to run the server listener on.
--inbrowser: Open the Gradio UI in a web browser.
--share: Share the Gradio UI.
--language: Set custom language
```

### Launching the GUI on Windows

On Windows, you can use either the `gui.bat` script located in the root directory. Choose the script that suits your preference and run it in a terminal, providing the desired command line arguments. Here's an example:


```powershell
gui.bat --listen 127.0.0.1 --server_port 7860 --inbrowser --share
```

### Launching the GUI on Linux

To launch the GUI on Linux run the `./gui.sh` script located in the root directory. Provide the desired command line arguments as follows:

```bash
gui.sh --listen 127.0.0.1 --server_port 7860 --inbrowser --share
```

## Custom Path Defaults

The repository now provides a default configuration file named `config.toml`. This file is a template that you can customize to suit your needs.

To use the default configuration file, follow these steps:

1. Copy the `config example.toml` file from the root directory of the repository to `config.toml`.
2. Open the `config.toml` file in a text editor.
3. Modify the paths and settings as per your requirements.

This approach allows you to easily adjust the configuration to suit your specific needs to open the desired default folders for each type of folder/file input supported in the GUI.

You can specify the path to your config.toml (or any other name you like) when running the GUI. For instance: ./gui.bat --config c:\my_config.toml

## LoRA

To train a LoRA, you can currently use the `train_network.py` code. You can create a LoRA network by using the all-in-one GUI.

Once you have created the LoRA network, you can generate images using auto1111 by installing [this extension](https://github.com/kohya-ss/sd-webui-additional-networks).

## Sample image generation during training

A prompt file might look like this, for example:

```txt
# prompt 1
masterpiece, best quality, (1girl), in white shirts, upper body, looking at viewer, simple background --n low quality, worst quality, bad anatomy, bad composition, poor, low effort --w 768 --h 768 --d 1 --l 7.5 --s 28

# prompt 2
masterpiece, best quality, 1boy, in business suit, standing at street, looking back --n (low quality, worst quality), bad anatomy, bad composition, poor, low effort --w 576 --h 832 --d 2 --l 5.5 --s 40
```

Lines beginning with `#` are comments. You can specify options for the generated image with options like `--n` after the prompt. The following options can be used:

- `--n`: Negative prompt up to the next option.
- `--w`: Specifies the width of the generated image.
- `--h`: Specifies the height of the generated image.
- `--d`: Specifies the seed of the generated image.
- `--l`: Specifies the CFG scale of the generated image.
- `--s`: Specifies the number of steps in the generation.

The prompt weighting such as `( )` and `[ ]` is working.

## Troubleshooting

If you encounter any issues, refer to the troubleshooting steps below.

### Page File Limit

If you encounter an X error related to the page file, you may need to increase the page file size limit in Windows.

### No module called tkinter

If you encounter an error indicating that the module `tkinter` is not found, try reinstalling Python on your system.

### LORA Training on TESLA V100 - GPU Utilization Issue

#### Issue Summary

When training LORA on a TESLA V100, users reported low GPU utilization. Additionally, there was difficulty in specifying GPUs other than the default for training.

#### Potential Solutions

- **GPU Selection:** Users can specify GPU IDs in the setup configuration to select the desired GPUs for training.
- **Improving GPU Load:** Utilizing `adamW8bit` optimizer and increasing the batch size can help achieve 70-80% GPU utilization without exceeding GPU memory limits.

## SDXL training

The documentation in this section will be moved to a separate document later.

## Masked loss

The masked loss is supported in each training script. To enable the masked loss, specify the `--masked_loss` option.

The feature is not fully tested, so there may be bugs. If you find any issues, please open an Issue.

ControlNet dataset is used to specify the mask. The mask images should be the RGB images. The pixel value 255 in R channel is treated as the mask (the loss is calculated only for the pixels with the mask), and 0 is treated as the non-mask. The pixel values 0-255 are converted to 0-1 (i.e., the pixel value 128 is treated as the half weight of the loss). See details for the dataset specification in the [LLLite documentation](./docs/train_lllite_README.md#preparing-the-dataset).

## Change History

See release information.
