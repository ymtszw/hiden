[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

function Get-QuotaSummary {
    $proc = Get-CimInstance Win32_Process -Filter "Name = 'language_server.exe'" -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $proc) {
        return @{ status = "fallback"; reason = "language_server.exe not running" }
    }

    $csrfToken = ""
    if ($proc.CommandLine -match '--csrf_token\s+([a-zA-Z0-9\-]+)') {
        $csrfToken = $matches[1]
    }

    $connections = Get-NetTCPConnection -OwningProcess $proc.ProcessId -State Listen -ErrorAction SilentlyContinue
    if (-not $connections) {
        return @{ status = "fallback"; reason = "listening port not found" }
    }

    $headers = @{
        'Content-Type'         = 'application/json'
        'X-Codeium-Csrf-Token' = $csrfToken
    }

    $res = $null
    foreach ($conn in $connections) {
        $port = $conn.LocalPort
        try {
            $uri = "http://127.0.0.1:$port/exa.language_server_pb.LanguageServerService/RetrieveUserQuotaSummary"
            $res = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body "{}" -TimeoutSec 2
            if ($null -ne $res -and $null -ne $res.response) {
                break
            }
        }
        catch {
            # try next port
        }
    }

    if (-not $res -or -not $res.response) {
        return @{ status = "fallback"; reason = "could not fetch from any port" }
    }

    $summary = @{}
    if ($res.response.groups) {
        foreach ($grp in $res.response.groups) {
            foreach ($b in $grp.buckets) {
                $key = "$($grp.displayName):$($b.displayName)"
                $summary[$key] = [math]::Round($b.remainingFraction * 100, 1)
            }
        }
    }

    return @{
        Status    = "ok"
        Timestamp = (Get-Date).ToString("o")
        Quotas    = $summary
    }
}

try {
    $result = Get-QuotaSummary
    $result | ConvertTo-Json -Depth 4
}
catch {
    @{ status = "fallback"; reason = $_.Exception.Message } | ConvertTo-Json
}
