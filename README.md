# mac-setup
## To install nix:
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## To install nix-darwin with an existing nix flake:
```
nix run nix-darwin -- switch --flake ~/.config/nix#ProfileName
```

## To switch to a new config:
  ```
  darwin-rebuild switch --flake ~/.config/nix#ProfileName
  ```

## todo:

~~* migrate from the ansiblebot - check~~
~~* Use omp instead of powerlevel 10K~~
* divide between diffrent and more focused flakes
  1. darwin-configuration
  2. shell config
  3. Profiles
  4. home-manager
  5. add a path for ykman to etc/paths