# function that replaces '/' path separators in pwd with arg1 with color arg2
function replace_path_separator
    set -f oldstr '/'
    set -f newstr (printf '%s%s%s' (set_color $argv[2]) $argv[1] (set_color normal))
    echo $PWD | sed "s|$oldstr|$newstr|g"
end

function fish_prompt --description 'Donatello prompt'
    #Save the return status of the previous command
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

    if functions -q fish_is_root_user; and fish_is_root_user
        printf '%s@@%s %s%s%s# ' $USER (prompt_hostname) (set -q fish_color_cwd_root
                                                         and set_color $fish_color_cwd_root
                                                         or set_color $fish_color_cwd) \
            (prompt_pwd) (set_color normal)
    else
        set -l status_color (set_color $fish_color_status)
        set -l statusb_color (set_color --bold $fish_color_status)
        set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

        # printf '[%s] %s%s@%s %s%s %s%s%s \n> ' (date "+%H:%M:%S") (set_color brblue) \
        #     $USER (prompt_hostname) (set_color $fish_color_cwd) $PWD $pipestatus_string \
        #     (set_color normal)
        
        # no color
        # printf ' ╭─ [%s] %s in \n ╰─ %s \n%s🗧 ' (date "+%H:%M:%S") $USER $PWD $pipestatus_string
        
        printf '\n ╭─ %s[%s%s%s]%s %s %sin%s \n ╰─%s %s\n🗧 ' (set_color brblue) (set_color normal) (date "+%H:%M:%S") (set_color brblue) (set_color normal) \
            $USER (set_color brblue) (set_color normal) \
            (replace_path_separator ' ❭ ' purple) $pipestatus_string
    end
end


#  ╭─ [hh:mm:ss] gpaul in
#  ╰─ (file path)
# 🗧
# Σ » ▹ ➜ 🗧
