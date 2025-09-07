# usage: test.ps1 [file, use comma seperate, optional]

function Uncompress-7zfile($files){
    foreach ($file in $files){
        $dest = Join-Path $file.directory $file.basename
        $date = ($file.basename -split "_")[2]
        $pwd = ($file.basename).split("_")[0]+([int]($date).tostring().substring(4,4)*[int]($date).tostring().substring(4,4))
        & 'C:\Program Files\7-Zip\7z.exe' e $file.fullname -o"$dest" "$date\*.*" -y
    }
}

if ($args){
    $files = Get-Item $args[0]
    Uncompress-7zfile($files)
} else {
    $files = Get-ChildItem -filter *.7z -recurse -file 
    Uncompress-7zfile($files)
}