# Serial LED Control System

This project is an embedded system application designed to control LEDs using UART communication. It allows the user to send sequences of commands to light up Red, Yellow, and Green LEDs for specified durations. The project runs on an nRF5340 platform, utilizing Zephyr RTOS for real-time scheduling, and uses the Robot Framework to automate testing of the UART-based LED control interface.

## Features
- **LED Control**: Control Red, Yellow, and Green LEDs using UART commands.
- **Command Parsing**: Send sequences such as `R,1000,G,500,Y,1000` to light up LEDs in order with specified durations.
- **Repeat Functionality**: Include repeat commands to execute sequences multiple times, e.g., `T,2` for repeating twice.
- **Validation**: Input validation for correct command structure, time values, and sequence repetition.
- **Debugging**: UART responses provide useful information for debugging command parsing and system behavior.

## Components
- **Zephyr RTOS**: The system runs on Zephyr RTOS for precise task scheduling, mutexes, and FIFO message queues.
- **UART Communication**: Commands are sent via UART, received by the nRF5340, parsed, and used to control the LEDs.
- **Robot Framework Testing**: The Robot Framework is used to automate the testing of the UART interface, ensuring the system behaves as expected for valid and invalid inputs.

## Why Use Robot Framework?
The **Robot Framework** is a test automation framework that allows you to easily write and execute tests in a human-readable syntax. Here's why it's being used in this project:

1. **Automated Testing**: Robot Framework allows us to automate the validation of different UART commands, reducing manual testing time.
2. **Reliability**: Since the LED control involves real-time behavior, using Robot Framework ensures consistency across multiple test runs, which helps in identifying issues like incorrect parsing, unexpected delays, or timing issues.
3. **Ease of Use**: Robot Framework's clear syntax and extensibility via custom libraries (like SerialLibrary) make it an ideal choice for interfacing with the UART console and testing complex behavior, such as handling invalid commands or repetitions.

The Robot Framework tests cover:
- **Valid Time Strings**: Ensuring that the correct time formats are accepted and parsed accurately.
- **Invalid Time Strings**: Ensuring incorrect values are properly rejected.
- **Sequence Testing**: Validating command sequences for LED operation, including special cases like invalid commands or repeat functionality.

The Robot Framework ensures that the entire system operates as expected across a variety of different inputs, which is critical for reliable operation in embedded systems.

## Directory Structure
```
vko7Pylkkonen/
 ├── .vscode/
 │    ├── c_cpp_properties.json
 │    └── settings.json
 ├── build/
 ├── googletest/
 ├── src/
 │    ├── log.html
 │    ├── main.c
 │    ├── output.xml
 │    ├── report.html
 │    ├── serial_led_control.robot  # Robot Framework test suite
 │    ├── TimeParser.c
 │    ├── TimeParser.h
 │    ├── TrafficParser.c
 │    └── TrafficParser.h
 ├── tests/
 │    ├── build/
 │    ├── CMakeLists.txt
 │    ├── TimeParserTest.cpp
 │    └── TrafficParserTest.cpp
 ├── .gitignore
 ├── .gitmodules
 ├── CMakeLists.txt
 ├── prj.conf
 └── README.md
```

## Getting Started
### Prerequisites
- **Zephyr SDK** for building the embedded application.
- **Robot Framework** along with **SerialLibrary** for executing automated tests.
- **UART Terminal** (like PuTTY or Tera Term) for sending manual commands, if needed.

### Building the Project
1. Clone the repository:
   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```
2. Build the project using CMake:
   ```sh
   west build -b nrf5340dk_nrf5340_cpuapp
   ```

### Running Tests with Robot Framework
1. Make sure your board is connected to the UART interface.
2. Run the test suite using Robot Framework:
   ```sh
   robot src/serial_led_control.robot
   ```
3. After tests, logs will be generated in the `src` folder (`log.html`, `report.html`, and `output.xml`).

   ![kuva](https://github.com/user-attachments/assets/b1515f4a-0fc8-4634-af58-f27da9e3adde)


## Usage
- Connect to the board over a UART terminal.
- Use commands like `R,1000` to turn on the Red LED for 1000 milliseconds.
- To repeat a sequence, add `T,n` at the end to repeat `n` times.

## Example Commands
- `R,1000,G,500,Y,1500`: Turns on Red LED for 1 second, then Green for 0.5 seconds, and Yellow for 1.5 seconds.
- `R,500,T,3`: Turns on the Red LED for 500 milliseconds, repeating this 3 times.

## Troubleshooting
- **Laggy UART Responses**: Ensure there are no message queue overflows. Reduce the frequency of command input or debug using the sequence buffer.
- **Commands Not Executing**: Double-check for proper command formatting and ensure that the correct baud rate is set in the UART terminal.

## Future Improvements
- **Additional Commands**: Support for more LED colors or specific patterns.
- **Error Handling**: Improved error codes for invalid command sequences.
- **Web Interface**: Provide a web interface to control the LEDs via a connected module.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

