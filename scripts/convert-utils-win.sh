mkdir -p build/scripts
cp utils.bat build/
cp scripts/*.* utils.bat build/scripts

bat2exe.exe /y /source:D:\\Repos\\Weidows-projects\\Keeper\\build /target:D:\\Repos\\Weidows-projects\\Keeper

rm -r build
