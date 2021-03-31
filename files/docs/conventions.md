## Coding Conventions and Style Guide

### Bash

#### _organization_
---

- all functions and variables are defined within module files located within the `/src` directory, no main execution of any kind may be defined here

- all command aliases are stored in `/aliases`

- the bash profile sources everything within the `/src` and `/aliases` directories when executed with `ELISE_PROFILE=1`

- most of the main execution is defined within scripts that are located within the `/scripts` directory and any script can retrieve functionality as needed via import lines which must always be at the top of the script
    ```
    #!/usr/bin/env bash

    . "${ELISE_ROOT_DIR}/src/elise.sh"
    . "${ELISE_ROOT_DIR}/src/general.sh"
    ```

- [`${ELISE_ROOT_DIR}/scripts/container.sh`](https://github.com/jaustinford/elise/blob/main/scripts/container.sh) is a special script meant to run independant of the `/src` modules, therefore is an exception where constants or main execution may be defined.

- the bash profile executes to import the functions inside `/src` which also makes it another exception where constants or main execution can be defined.

#### _built-ins_
---

- [`${ELISE_ROOT_DIR}/src/elise.sh`](https://github.com/jaustinford/elise/blob/main/src/elise.sh) is a special encrypted module which stores most of the constants and all of the secrets used for the project; the details for each variable can be found in the [`README`](https://github.com/jaustinford/elise/blob/main/README.md#variables)

- the module [`${ELISE_ROOT_DIR}/src/general.sh`](https://github.com/jaustinford/elise/blob/main/src/general.sh) defines general functions and variables which are imported frequently across the project

- the function [`print_message`](https://github.com/jaustinford/elise/blob/main/src/general.sh#L103) inside of the `${ELISE_ROOT_DIR}/src/general.sh` module is used for all stdout and stderr message handling

#### _conventions_
---

- all functions and main execution that take positional parameters must define them within the first few declarations for readability
    ```
    test_function () {
        pos_1="$1"
        pos_2="$2"

        echo "$pos_1 - $pos_2"
    }
    ```

- all variables and interpolated commands must be double-quoted and can be nested if there are both, except when variables are being called inside an EOF block or when it's being iterated over in a loop
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
    ```
    for item in $(some_command); do
        echo "$item"

    done
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
    ```
    if [ "$var" == "$(command)" ]; then
        do_something_else

    fi
    ```

- string arguments passed into functions are not single-quoted unless they contain spaces, special characters, and double-quoted if they contain variables or interpolated commands
    ```
    function_in_some_file arg1 'this is arg 2' "$arg3" "$(arg4)"
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
    pos_1="$1"
    pos_2="$2"

    echo "$pos_1 - $pos_2"
    ```

- if a string possesses a variable in it, then the whole string is double-quoted
    ```
    "${ELISE_ROOT_DIR}/src/elise.sh is a file"
    echo '/root/src/elise.sh is a file'
    echo "${ELISE_ROOT_DIR}/src/elise.sh is a file"
    ```

- when using bash concepts that indent (for loops, while loops, if statements, etc), the convention is to indent 4 spaces and leave one blank line before either the next condition or the end of that block
    ```
    for item in thing1 thing2; do
        echo "$item"

    done
    ```
    ```
    while [ "$condition" == 'something' ]; do
        sleep 1

    done
    ```
    ```
    if [ "$var" == 'value' ]; then
        echo 'something'

    else
        echo 'something else'

    fi
    ```

- indented blocks will also have a space before the starting statement and a space after the closing line, except when following a single `print_message` command
    ```
    statement_1

    for item in thing1 thing2; do
        echo "$item"

    done

    statement_2
    ```
    ```
    print_message stdout 'doing a thing'
    for item in thing1 thing2; do
        echo "$item"

    done
    ```

- functions must indent four spaces and do not have an empty line before the closing brace
    ```
    function () {
        do_something
        do_something_else
    }
    ```

 - if piping is used, either in a command or through an interpolated command, each pipe will break out on a new line escaped with the unix `\` and is indented four spaces except if there's only one pipe, then the whole command must be on one line
    ```
    echo "$something" \
        | grep 'string' \
        | grep 'string_2'
    ```
    ```
    var="$(echo "$something" \
        | grep 'string' \
        | grep 'string_2')"
    ```
    ```
    var="$(echo "something" | grep 'string')"
    ```

 - blocks containing piped commands have one empty line before and one empty line after the block, same as other blocks
    ```
    do_something

    var="$(echo "$something" \
        | grep 'string' \
        | grep 'string_2')"
    
    do_something_else
    ```

 - when using conditionals that only assign one line variables, the command is included on the previous line along with the condition and there are no empty lines
    ```
    if [ "$var" == 'value_1' ]; then something='something_1'
    elif [ "$var" == 'value_2' ]; then something='something_2'
    fi
    ```

 - when using conditionals that check for multiple conditions, each condition is broken out to new line using the unix `\` and indented however many spaces needed to align it with the previous condition, except when the condition has only one command assigning a variable, which is then printed on one line and has no empty lines
    ```
    if [ "$var_1" == 'value_1' ] && \
       [ "$var_2" == 'value_2' ]; then
        echo 'something'
    
    elif [ "$var_1" == 'value_3' ] && \
         [ "$var_2" == 'value_4' ]; then
         echo 'something else'

    fi
    ```
    ```
    if [ "$var_1" == 'value_1' ] && [ "$var_2" == 'value_2' ]; then var='something'
    elif [ "$var_1" == 'value_3' ] && [ "$var_2" == 'value_4' ]; then var='something else'
    fi
    ```
