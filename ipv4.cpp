#include <iostream>
#include <string>
#include <cctype>

// extractIPv4 scans `str` for a valid embedded IPv4 address (with optional port).
//
// Scanning rules:
//   - A candidate start is a digit NOT preceded by a digit, '.', or ':'
//     (preceding '.' or ':' = stray punctuation; preceding digit = mid-run)
//   - Four octets 0-255, no leading zeros, separated by exactly three dots
//   - Immediately after the 4th octet: '.' is a stray period → reject
//   - Optional port after ':': 0-65535, no leading zeros, no second colon
//
// On success : outAddress = 32-bit address, outPort = port or -1
// On failure : outAddress = 0,              outPort = -1
bool extractIPv4(const std::string& str, unsigned long& outAddress, int& outPort) {
    outAddress = 0;
    outPort    = -1;

    int n = static_cast<int>(str.size());

    for (int i = 0; i < n; i++) {

        // Only start at a digit
        if (!isdigit(static_cast<unsigned char>(str[i]))) continue;

        // Skip positions mid-way through a digit run (tried from the first digit already)
        if (i > 0 && isdigit(static_cast<unsigned char>(str[i - 1]))) continue;

        // Left boundary: stray '.' or ':' immediately before the first octet → skip
        if (i > 0 && (str[i - 1] == '.' || str[i - 1] == ':')) continue;

        // ---- attempt to parse 4 octets ----
        int pos = i;
        int octets[4];
        bool valid = true;

        for (int oct = 0; oct < 4 && valid; oct++) {

            // Octets 1-3 must be preceded by a dot
            if (oct > 0) {
                if (pos >= n || str[pos] != '.') { valid = false; break; }
                pos++;
            }

            // Need at least one digit
            if (pos >= n || !isdigit(static_cast<unsigned char>(str[pos]))) {
                valid = false; break;
            }

            int start = pos;
            int val   = 0;

            // Parse digits; break early once value exceeds 255
            while (pos < n && isdigit(static_cast<unsigned char>(str[pos]))) {
                val = val * 10 + (str[pos] - '0');
                pos++;
                if (val > 255) break;
            }
            // Consume any leftover digits (after early break)
            while (pos < n && isdigit(static_cast<unsigned char>(str[pos]))) pos++;

            if (val > 255)                              { valid = false; break; }
            if ((pos - start) > 1 && str[start] == '0'){ valid = false; break; } // leading zero

            octets[oct] = val;
        }

        if (!valid) continue;

        // Right boundary: '.' immediately after 4th octet = stray period
        if (pos < n && str[pos] == '.') continue;

        // ---- optional port ----
        int port = -1;
        if (pos < n && str[pos] == ':') {
            pos++; // consume ':'

            // Port must begin with a digit (empty port or non-digit → reject whole candidate)
            if (pos >= n || !isdigit(static_cast<unsigned char>(str[pos]))) continue;

            int       portStart = pos;
            long long portVal   = 0;

            // Parse digits; break early once value exceeds 65535
            while (pos < n && isdigit(static_cast<unsigned char>(str[pos]))) {
                portVal = portVal * 10 + (str[pos] - '0');
                pos++;
                if (portVal > 65535) break;
            }
            // Consume leftover digits (after early break)
            while (pos < n && isdigit(static_cast<unsigned char>(str[pos]))) pos++;

            if (portVal > 65535)                              continue; // out of range
            if ((pos - portStart) > 1 && str[portStart] == '0') continue; // leading zero

            // A second ':' after the port = multiple colons → reject
            if (pos < n && str[pos] == ':') continue;

            port = static_cast<int>(portVal);
        }

        // ---- success ----
        unsigned long addr =
            (static_cast<unsigned long>(octets[0]) << 24) |
            (static_cast<unsigned long>(octets[1]) << 16) |
            (static_cast<unsigned long>(octets[2]) <<  8) |
             static_cast<unsigned long>(octets[3]);

        outAddress = addr;
        outPort    = port;
        return true;
    }

    return false;
}

int main() {
    std::string line;

    while (true) {
        std::cout << "Enter a string (or 'END' to quit): ";

        if (!std::getline(std::cin, line)) break; // EOF / pipe closed

        // Tolerate Windows-style CRLF
        if (!line.empty() && line.back() == '\r') line.pop_back();

        if (line == "END") {
            std::cout << "Program terminated.\n";
            break;
        }

        unsigned long outAddr = 0;
        int           outPort = -1;

        if (extractIPv4(line, outAddr, outPort)) {
            std::cout << "Extracted IPv4 address: "
                      << ((outAddr >> 24) & 0xFF) << '.'
                      << ((outAddr >> 16) & 0xFF) << '.'
                      << ((outAddr >>  8) & 0xFF) << '.'
                      << ( outAddr        & 0xFF)
                      << " (decimal value: " << outAddr << ", port: ";

            if (outPort == -1) std::cout << "none";
            else               std::cout << outPort;

            std::cout << ")\n";
        } else {
            std::cout << "Invalid input: no valid IPv4 address found\n";
        }
    }

    return 0;
}
