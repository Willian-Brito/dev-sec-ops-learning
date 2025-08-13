# horusec_docker_windows.ps1
# willian-brito.github.io | github.com/Willian-Brito
# Testado em: Horusec CLI v2.9.0-beta.3
# PSVersion 5.1.26100.1252


# CONFIGURAÇÃO DE PARÂMETROS DO HORUSEC
$image = "horuszup/horusec-cli:v2.9.0-beta.3"
$severity_exception = "LOW,UNKNOWN,INFO"
$report_type = "json"
$report_directory = "reports"
$report_file = "horusec_report.json"
$ignore = @(
    "**/tmp/**",
    "**/.vscode/**",
    "**/.venv/**",
    "**/.env/**",
    "**/tests/**",
    "**/test/**",
    "**/test/",
    "**/*.Tests/**",
    "**/*.Test/**",
    "**/test_*",
    "**/appsettings.*.json",
    "**/bin/Debug/*/appsettings.*.json",
    "**/*.yml",
    "**/bin/Debug/*/appsettings.json",
    "**/*.sarif"
) -join ','

# CRIA PASTA DE RELATÓRIO
if (-Not (Test-Path -Path $report_directory)) {
    New-Item -ItemType Directory -Path $report_directory
}

# EXECUTA CONTAINER DO HORUSEC REMOVENDO-O AO FIM DA EXECUÇÃO
docker pull $image
docker run --rm `
    -v /var/run/docker.sock:/var/run/docker.sock `
    -v ${PWD}:/src/horusec $image horusec start `
    -p /src/horusec -P ${PWD} `
    -s="$severity_exception" `
    --ignore="$ignore" `
    --information-severity=$true `
    -o="$report_type" `
    -O="/src/horusec/$report_directory/$report_file"