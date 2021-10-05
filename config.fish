source ~/.config/fish/local.fish

function fish_prompt --description 'Write out the prompt'
	set laststatus $status
	
	switch $USER
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd bbcbff
            set suffix '>'
    end
	
    function _git_branch_name
        echo (git symbolic-ref --quiet HEAD 2>&1 | sed -e '/not a git/d' | sed -e 's|^refs/heads/||')
    end
    function _is_git_dirty
        echo (git status -s --ignore-submodules=dirty ^/dev/null)
    end
    if [ (_git_branch_name) ]
        set -l git_branch (set_color -o ffbbcb)(_git_branch_name)
        if [ (_is_git_dirty) ]
            for i in (git branch -qv --no-color | string match -r '\*' | cut -d' ' -f4- | cut -d] -f1 | tr , \n)\
 (git status --porcelain | cut -c 1-2 | uniq)
                switch $i
                    case "*[ahead *"
                        set git_status "$git_status"(set_color red)⬆
                    case "*behind *"
                        set git_status "$git_status"(set_color red)⬇
                    case "."
                        set git_status "$git_status"(set_color green)✚
                    case " D"
                        set git_status "$git_status"(set_color red)✖
                    case "*M*"
                        set git_status "$git_status"(set_color green)✱
                    case "*R*"
                        set git_status "$git_status"(set_color purple)➜
                    case "*U*"
                        set git_status "$git_status"(set_color brown)═
                    case "??"
                        set git_status "$git_status"(set_color red)≠
                end
            end
        else
            set git_status (set_color green):
        end
        set git_info "git$git_status$git_branch"(set_color white)
    end
    set_color -b black
    
    # Replace `(prompt_pwd)` with `(echo $PWD | sed -e "s|^$HOME|~|")` for full path
    printf '%s%s%s%s%s%s%s%s%s%s%s%s%s' (set_color -o white) (date '+%Y-%m-%d %T ') (set_color 94fbaa) $USER (set_color white) ' 🍔  ' (set_color $color_cwd) (prompt_pwd) (set_color white) ' ' (set_color white) (set_color white)
    
    
    if test $laststatus -eq 0
        printf "%s✔  %s%s " (set_color -o green) (set_color white) (set_color normal)
    else
        printf "%s✘  %s%s " (set_color -o red) (set_color white) (set_color normal)
    end
    
    if test -n "$git_info"
    	printf "\n%s" $git_info 
    end
    
    printf "\n%s%s%s%s" (set_color white) " " $suffix " "
end

	


function ff
	osascript -e 'tell application "Finder"'\
	 -e "if (1 <= (count Finder windows)) then"\
	 -e "get POSIX path of (target of window 1 as alias)"\
	 -e 'else' -e 'get POSIX path of (desktop as alias)'\
	 -e 'end if' -e 'end tell'
end


function cdff
	cd (ff $argv)
end
