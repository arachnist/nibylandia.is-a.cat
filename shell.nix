with import <nixpkgs> { };
let
  pubKeys = (import ./secrets/users.nix).users;
  ageRecipients = "-r "
    + builtins.concatStringsSep " -r " (map (x: ''"${x}"'') pubKeys);
  age-crypt = pkgs.writeShellScriptBin "age-crypt" ''
    case $1 in
    smudge)
    	exec age --decrypt -i ~/.ssh/id_ed25519
    ;;
    clean)
    	exec age --encrypt ${ageRecipients}
    ;;
    esac
    	'';
in pkgs.mkShell {
  buildInputs = with pkgs; [ git age age-crypt ];
  runScript = ''
    git config --local --replace-all 'filter.age-crypt.smudge' 'age-crypt smudge'
    git config --local --replace-all 'filter.age-crypt.clean' 'age-crypt clean'
  '';
}
