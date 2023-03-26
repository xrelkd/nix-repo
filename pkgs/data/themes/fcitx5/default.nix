{ fetchFromGitHub }:

{
  material-color = fetchFromGitHub {
    owner = "hosxy";
    repo = "Fcitx5-Material-Color";
    rev = "2256feeae48dcc87f19a3cfe98f171862f8fcace";
    hash = "sha256-i9JHIJ+cHLTBZUNzj9Ujl3LIdkCllTWpO1Ta4OT1LTc=";
  };

  nord = fetchFromGitHub {
    owner = "tonyfettes";
    repo = "fcitx5-nord";
    rev = "bdaa8fb723b8d0b22f237c9a60195c5f9c9d74d1";
    hash = "sha256-qVo/0ivZ5gfUP17G29CAW0MrRFUO0KN1ADl1I/rvchE=";
  };

  thep0y = fetchFromGitHub {
    owner = "thep0y";
    repo = "fcitx5-themes";
    rev = "452286a21db617a80fbed9c02f3dff9d77632191";
    hash = "sha256-+lcI/Tyv7kmwmuEn5m4fsGVHiqvpWgk7g7p04lz4KFs=";
  };
}
