alias hyperion_arm="zoneminder_api_change_function_all_monitors Modect 1"
alias hyperion_check="zoneminder_api_get_monitors | jq '.monitors[].Monitor_Status' | jq -s '.'"
alias hyperion_disarm="zoneminder_api_change_function_all_monitors Monitor 1"
alias hyperion_off="zoneminder_api_change_function_all_monitors None 0"
alias hyperion_on="zoneminder_api_change_function_all_monitors Monitor 1"