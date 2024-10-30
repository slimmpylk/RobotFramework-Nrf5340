*** Settings ***
Library    SerialLibrary
Library    BuiltIn
Library    String
Library    Collections

*** Variables ***
${com}      COM8          # Replace with your actual COM port
${baud}     115200

*** Test Cases ***
Test Valid Time String
    [Documentation]    Test parsing a valid time string '000120' (1 minute 20 seconds)
    [Teardown]    Disconnect Serial
    Connect Serial
    Send Time String    000120
    ${response}=    Read Response
    Log To Console    Received: ${response}
    ${parsed_value}=    Extract Parsed Value    ${response}
    Should Be Equal As Integers    ${parsed_value}    80

Test Invalid Time String
    [Documentation]    Test parsing an invalid time string '001067' (invalid seconds)
    [Teardown]    Disconnect Serial
    Connect Serial
    Send Time String    001067
    ${response}=    Read Response
    Log To Console    Received: ${response}
    ${parsed_value}=    Extract Parsed Value    ${response}
    Should Be Equal As Strings    ${parsed_value}    x

Test Time String Length
    [Documentation]    Test that the device rejects time strings not exactly 6 characters long
    [Teardown]    Disconnect Serial
    Connect Serial
    Send Time String    00120    # 5 characters, invalid length
    ${response}=    Read Response
    Log To Console    Received: ${response}
    ${parsed_value}=    Extract Parsed Value    ${response}
    Should Be Equal As Strings    ${parsed_value}    x

Test Non-Zero Time String
    [Documentation]    Test that the device rejects time strings resulting in 0 seconds
    [Teardown]    Disconnect Serial
    Connect Serial
    Send Time String    000000    # Time string representing 0 seconds
    ${response}=    Read Response
    Log To Console    Received: ${response}
    ${parsed_value}=    Extract Parsed Value    ${response}
    Should Be Equal As Strings    ${parsed_value}    x

Test Time String Is Digit
    [Documentation]    Test that the device rejects time strings containing non-digit characters
    [Teardown]    Disconnect Serial
    Connect Serial
    Send Time String    00a120    # Invalid time string containing 'a'
    ${response}=    Read Response
    Log To Console    Received: ${response}
    ${parsed_value}=    Extract Parsed Value    ${response}
    Should Be Equal As Strings    ${parsed_value}    x

*** Keywords ***
Connect Serial
    Log To Console    Connecting to ${com}
    Add Port    ${com}    baudrate=${baud}    encoding=ascii
    Port Should Be Open    ${com}
    Reset Input Buffer
    Reset Output Buffer
    Sleep    5s  # Delay to allow initialization

Disconnect Serial
    Log To Console    Disconnecting serial port
    Delete Port    ${com}

Send Time String
    [Arguments]    ${time_string}
    Log To Console    Sending time string: ${time_string}
    Write Data    ${time_string}\n    encoding=ascii

Read Response
    [Arguments]    ${retries}=5    ${delay}=1
    ${response}=    Set Variable    ${EMPTY}
    FOR    ${i}    IN RANGE    ${retries}
        ${response}=    Read Until    terminator=\n    encoding=ascii
        Log To Console    Full response: ${response}
        ${cleaned_response}=    Remove CR Characters    ${response}
        Log    Cleaned response: ${cleaned_response}
        ${response_length}=    Get Length    ${cleaned_response}
        Run Keyword If    ${response_length} > 0    Return From Keyword    ${cleaned_response}
        Log To Console    Invalid response, retrying... (${i}/${retries})
        Sleep    ${delay}
    END
    Fail    No valid response found after ${retries} retries.

Remove CR Characters
    [Arguments]    ${input_string}
    # Remove all occurrences of \r character manually
    ${cleaned_string}=    Replace String    ${input_string}    \r    ${EMPTY}
    RETURN    ${cleaned_string}

Extract Parsed Value
    [Arguments]    ${response}
    ${lines}=    Split String    ${response}    \n
    Reverse List    ${lines}
    FOR    ${line}    IN    @{lines}
        ${stripped_line}=    Strip String    ${line}
        Run Keyword If    '${stripped_line}' != ''    Return From Keyword    ${stripped_line}
    END
    Fail    No non-empty line found in response
