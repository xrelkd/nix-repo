{ callPackage }:

{
  fedora-28 = {
    inherit (callPackage ./fedora-28 { }) zen;
  };
}
