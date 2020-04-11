Write-Host "Input:" $Args[0]
Write-Host "Output:" $Args[1]

if (!(Test-Path $Args[0] -PathType Leaf)) {
    Write-Error "No input file found."
    Exit-PSSession
}

$extlibs = @()

$loaded = @()

$programLine = @()

function Parse-Require($orig) {
    $d = $orig.Split(' ');
    return $d[1].Trim('"', "'");
}

function Parse-RequireRelative($orig) {
    $d = $orig.Split(' ');
    $fp = $d[1].Trim('"', "'");
    return $fp;
}

function Read-Program($path) {
    Write-Host "Loading:" $path;

    $fline = (Get-Content $path) -as [string[]]
    foreach ($l in $fline) {
        $l = $l.Trim(' ');

        if ($l.StartsWith("require ")) {
            $lib = Parse-Require($l);
            if (!$extlibs.Contains($lib)) {
                Write-Host "Detected Thirdparty Library:" $lib
                $extlibs += $lib
            }
        }
        elseif ($l.StartsWith("require_relative ")) {
            $file = Parse-RequireRelative($l);
            if (!$loaded.Contains($file)) {
                $loaded += $file;
                . Read-Program $file;
            }
        }
        else {
            $programLine += $l;
        }
    }
}

. Read-Program($Args[0]);

$extlibline = @();
foreach ($lib in $extlibs) {
    $extlibline += "require '" + $lib + "'"
}

$programLine = $extlibline + $programLine

$programLine | Out-File $Args[1]