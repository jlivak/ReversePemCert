if ($args.Length -ne 1)  {
    Write-Error "Script expects a single argument, a file path to a certificate file."
    return
}

$pemFile = Get-Content -Raw $args[0]
$privateKey = $null

if ($pemFile.Contains('-----BEGIN PRIVATE KEY-----')) {
    $privateKeyIndex = $pemFile.IndexOf('-----BEGIN PRIVATE KEY-----')
    $privateKeyEndIndex = $pemFile.IndexOf('-----END PRIVATE KEY-----')
    $privateKeyEndLength = '-----END PRIVATE KEY-----'.Length
    $privateKey = $pemFile.Substring($privateKeyIndex, ($privateKeyEndIndex - $privateKeyIndex) + $privateKeyEndLength)
    $pemFile = $pemFile.Replace($privateKey, '')
}
elseif ($pemFile.Contains('-----BEGIN RSA PRIVATE KEY-----')) {
    $privateKeyIndex = $pemFile.IndexOf('-----BEGIN RSA PRIVATE KEY-----')
    $privateKeyEndIndex = $pemFile.IndexOf('-----END RSA PRIVATE KEY-----')
    $privateKeyEndLength = '-----END RSA PRIVATE KEY-----'.Length
    $privateKey = $pemFile.Substring($privateKeyIndex, ($privateKeyEndIndex - $privateKeyIndex) + $privateKeyEndLength)
    $pemFile = $pemFile.Replace($privateKey, '')
}

$keys = $pemFile -split "-----END CERTIFICATE-----"
$output = ''

for ($i = $keys.Length-1; $i -ge 0; $i--) {
    $output += $keys[$i].Trim()
    if ($keys[$i].Contains("-----BEGIN CERTIFICATE-----")) {
        $output += "`n-----END CERTIFICATE-----`n`n"
    }
}

if ($privateKey -ne $null) {
    $output += "`n"
    $output += $privateKey
}

Write-Output $output