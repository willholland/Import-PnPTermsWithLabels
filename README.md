# Import-PnPTermsWithLabels

## SYNOPSIS
PnP PowerShell Script for importing Taxonomy Terms with Labels from a CSV.

## SYNTAX
```powershell
Import-PnPTermsWithLabels -TenantAdminUrl <string> -Path <string>
```
## EXAMPLES

### EXAMPLE 1
```powershell
Import-PnPTermsWithLabels -TenantAdminUrl "https://contoso-admin.sharepoint.com" -Path "./terms.csv"
```

## PARAMETERS
### -TenantAdminUrl
URL Pointing to the Tenant Admin Site

```yaml
Type: String
Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Full or Relative path to the CSV containting import data.

```yaml
Type: String
Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

# CSV Fields
A sample CSV file has been includes here: [./template.csv](template.csv)

|Name|Type|Notes|
|:-:|:-:|---|
|termGroup|string||
|termSet|string||
|Name|string||
|LCID|Number||
|Labels|string|Multiple values separated by semicolon (;)|
