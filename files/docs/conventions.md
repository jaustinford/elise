## Coding Conventions and Styling

### Bash
- all functions and main execution that take positional parameters must define them within the first few declarations for readability
    ```
    test_function () {
        pos_1="$1"
        pos_2="$2"

        echo "$pos_1 - $pos_2"
    }
    ```

- all variables and interpolated commands must be double-quoted, can be nested if there are both, except when variables are being called between an EOF block
    ```
    echo "$var1 $var2"
    echo "$var1"
    echo "$(echo "$var1")"
    ```

    ```
    cat << EOF
    No quotes in $var between EOF blocks
    EOF
    ```

- value definitions or comparatives within conditional statements must be at least single-quoted, double-quoted if they contain variables or interpolated commands
    ```
    var='value'
    ```

    ```
    if [ "$var" == 'value' ]; then
        do_something

    fi
    ```

- string arguments passed into functions are not single-quoted unless they contain spaces, special characters, and double-quoted if they contain variables or interpolated commands
    ```
    function_in_some_file arg1 'this is arg 2' "$arg3"
    ```
