General AI Disclosure  
For this assignment, I used Claude Sonnet 4.6 on High Effort on 9/17/2026.

Code Attribution  
The prompts I used to generate the code follow below:  
Prompt 1:  
```bash
got a project for you! this project is intended to develop my skills with ai-assisted code generation. it's not expected that you oneshot this, but i think it would be cool if you did, so do your best to ensure the program works on the first try! pay close attention to the constraints and example output specifically.
requirements:
two files: a .cpp file and a MAKEFILE
the cpp file should read a line of text from stdin and extract a single IPv4 address (with possible port number) embedded in the line of text. the IPv4 address should match exactly; partial matches aren't allowed. function prototype:

int main()
//main repeatedly asks user for input until user enters END (case-sensitive), then prints Program terminated and exits
//on successful ipv4 address found, print Extracted IPv4 address: A.B.C.D (decimal value: N, port: P) where N is the 32-bit decimal value and P is the port number or the literal text none
bool extractIPv4(const std::string& str, unsigned long& outAddress, int& outPort);
//on success: outAddress holds 32-bit ipv4 address and outPort holds port number or -1 if no port present
//on failure: outAddress set to 0, outPort -1

You can use character classification functions like isdigit

constraints:
Cannot use str-to-num conversion (atoi, atol, atoll, strtol, strtoul, strtod, stoi, stol, stoul, sscanf, scanf with numeric conversions)
Cannot use address-parsing library
Cannot use regex libraries
There will only ever be one valid ipv4 address per input line
Incorrect outputs include wrong octet count, empty octet, port or octet out of range, disallowed leading zeros, multiple colons, stray periods/colons immediately adjacent to otherwise-valid addresses
example output:

Enter a string (or 'END' to quit): connecting to 192.168.1.1 now
Extracted IPv4 address: 192.168.1.1 (decimal value: 3232235777, port: none)
Enter a string (or 'END' to quit): server=10.0.0.255:8080end
Extracted IPv4 address: 10.0.0.255 (decimal value: 167772415, port: 8080)
Enter a string (or 'END' to quit): 192a168.1.1.1
Extracted IPv4 address: 168.1.1.1 (decimal value: 2818638081, port: none)
Enter a string (or 'END' to quit): 192.168.1.1.
Invalid input: no valid IPv4 address found
Enter a string (or 'END' to quit): Connection from 192.168.1.1 refused
Extracted IPv4 address: 192.168.1.1 (decimal value: 3232235777, port: none)
Enter a string (or 'END' to quit): 192.168.01.1
Invalid input: no valid IPv4 address found
Enter a string (or 'END' to quit): 1.2.3.4:99999
Invalid input: no valid IPv4 address found
Enter a string (or 'END' to quit): 12.34.56
Invalid input: no valid IPv4 address found
Enter a string (or 'END' to quit): no number here
Invalid input: no valid IPv4 address found
Enter a string (or 'END' to quit): END
Program terminated.

gl hf! if you need clarification on anything, ask, but i feel like this is fairly straightforward.
```

Prompt 2:  
```bash
keep going fren, I ran out of free usage credits
```

Every line of `ipv4.cpp` and `Makefile` is AI-generated.  
The test cases were human-authored.    
I did not have to make any modifications to the AI-generated output.  

Verification Statement  
I understand every line of the submitted code.  
The code has been tested and works as intended.  

