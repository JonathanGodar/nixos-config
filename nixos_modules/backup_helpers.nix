{ ... }:
{
  home_ignore_directories = [
    ".cargo/"
    ".eclipse/"
    ".discord-rpc/"
    ".java/"
    ".julia/"
    ".nix-profile/"
    ".ssh/"
    ".vscode/"
    ".zconpdump"
    ".zshenv"
    ".zshrc"
    "Downloads/"

    ".mozilla/firefox/*.default-release/cache2/"
    ".mozilla/firefox/"
    ".config/discord/"
    ".config/google-chrome/Default/Cache/"
    ".config/chromium/"
    ".local/share/Trash/"
    ".local/share/containers/"
    ".local/share/Steam/"

    ".npm/"
    ".m2/repository/"
    ".gradle/caches/"
    ".virtualenvs/"

    # From WAX9
    "VirtualBox VMs/"
    "bin/MATLAB/"
    ".MathWorks"
  ];

  ignore_directories = [
    "**/Cache"
    "**/cache"
    "**/.cache/"
    "**/target/**"
    "**/build/**"
    "**/__pycache__/**"
    "**/.venv/**"
    "**/venv/**"
    "**/node_modules/**"

    "**/tmp/"
    "**/.git/"
    "**/pyc"

    "**/node_modules/"

    "**/DistantHorizons.sqlite"

  ];
}
