$words = "RENT", "WIN", "MOON", "STOP", "STUDY"
$firstWord = "CAT"

function Permutiere {
    Param(
        [string[]]$sequenzBisJetzt, 
        [string[]]$worteUebrig
    )

    if ( -not ([bool]$worteUebrig) ) {
        $firstWord + " " + $sequenzBisJetzt
    }

    foreach ($wort in $worteUebrig) {
        $testsequenz = $sequenzBisJetzt + $wort
        $worteUebrigTest = $worteUebrig | Where-Object { $_ -ne $wort }

        Permutiere -beginntMit $firstWord -sequenzBisJetzt $testsequenz -worteUebrig $worteUebrigTest
    }
}


function HatEinGemeinsamesZeichenMit {
    Param(
        [string]$wort1,
        [string]$wort2
    )
    
    for ( $i = 0; $i -lt $wort1.length; $i ++ ) {
        if ( $wort2.IndexOf($wort1[$i]) -ge 0 ) {
            return $true
        }
    }

    for ( $i = 0; $i -lt $wort2.length; $i ++ ) {
        if ( $wort1.IndexOf($wort2[$i]) -ge 0 ) {
            return $true
        }
    }
}

function IstEinGewinner {
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        $permutation
    )

    $istEinGewinner = $true
    $split = $permutation.Split(" ")
    
    for($i = 0; $i -lt $split.length -1; $i++) {
        $aktuellesWort = $split[$i]
        $naechstesWort = $split[$i+1]
        #Write-Host "Vergleiche $aktuellesWort <-> $naechstesWort ..."

        if (-not (HatEinGemeinsamesZeichenMit -Wort1 $aktuellesWort -Wort2 $naechstesWort) ) {
            $istEinGewinner = $false
            Write-Host "$permutation funktioniert nicht ($i): $aktuellesWort <-> $naechstesWort haben keine gemeinsamen Zeichen"
            break;
        }

        if ($aktuellesWort.length -eq $naechstesWort.length ) {
            $istEinGewinner = $false
            Write-Host "$permutation funktioniert nicht ($i): $aktuellesWort <-> $naechstesWort haben die gleiche Länge"
            break;
        }
    }

    if ( $istEinGewinner ) {
        Write-Host $permutation -ForegroundColor Green
    }

    return $istEinGewinner
}

$permutationen = Permutiere -beginntMit $firstWord -sequenzBisJetzt @() -worteUebrig $words

$permutationen | ForEach-Object {
    $gewinn = IstEinGewinner -permutation $_
    if ($gewinn) {
        break;
    }
}


