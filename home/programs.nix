{ config, ... }:

{
    programs.git = {
        enable = true;
        userName = "ridwanalmahmud";
        userEmail = "ridwanalmahmud107@gmail.com";
        extraConfig = {
            init.defaultBranch = "master";
        };
    };
}
