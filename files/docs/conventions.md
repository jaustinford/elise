## Coding Conventions and Styling

### Bash
- all functions and variables are defined within module files located within the `/src` directory, no main execution of any kind may be defined here

- all scripts are located within the `/scripts` directory and retrieve functionality as needed via import lines which must always be at the top of the script
    ```
    #!/usr/bin/env bash

    . "${ELISE_ROOT_DIR}/src/elise.sh"
    . "${ELISE_ROOT_DIR}/src/general.sh"
    ```

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

- variables that are defined as constants must be capitalized and called with braces
    ```
    ROOT_LEVEL_CONSTANT='something'
    echo "${ROOT_LEVEL_CONSTANT}"
    ```

- variables that are not defined as constants are lower-cased and called without braces, this includes all positional variables
    ```
    var='something'
    echo "$var"
    ```

    ```
    test_function () {
        pos_1="$1"
        pos_2="$2"

        echo "$pos_1 - $pos_2"
    }
    ```
