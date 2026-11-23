{
  pkgs,
  baseDirectory ? ./by-name,
}:

let
  directoryEntries =
    path:
    let
      types = builtins.readDir path;
    in
    builtins.filter (name: builtins.getAttr name types == "directory") (builtins.attrNames types);

  shards = directoryEntries baseDirectory;

  packageEntries = builtins.listToAttrs (
    builtins.concatLists (
      map (
        shard:
        map (name: {
          inherit name;
          value = pkgs.callPackage (baseDirectory + "/${shard}/${name}/package.nix") { };
        }) (directoryEntries (baseDirectory + "/${shard}"))
      ) shards
    )
  );
in
packageEntries
