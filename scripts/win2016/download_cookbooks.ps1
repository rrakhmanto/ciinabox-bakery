$ErrorActionPreference = "Stop"
Set-ExecutionPolicy Bypass -force
Write-Output "Start at: $(Get-Date)"
try
{
  $start_time      = Get-Date
  $GzipPath        = "C:\base2\cookbooks.tar.gz"
  $Base2Path       = "C:\base2"
  $TarPath         = "C:\base2\cookbooks.tar"
  $Destination     = "C:\chef\"
  $CookbookDir     = "C:\chef\cookbooks"
  $SourceBucket    = $ENV:SOURCE_BUCKET
  $BucketRegion    = $ENV:BUCKET_REGION
  $CookbookVersion = $ENV:CB_BUILD_NO
  $ChefPath        = $ENV:CHEF_PATH

  Write-Output "INFO: Downloading cookbooks from s3 location: $SourceBucket/chef/$CookbookVersion/cookbooks.tar.gz"
  Read-S3Object -Region $BucketRegion -BucketName $SourceBucket -Key /chef/$CookbookVersion/cookbooks.tar.gz -File $GzipPath

  Write-Output "INFO: Deleting dir $CookbookDir"
  if(Test-Path -Path $CookbookDir ){
    Remove-Item -Recurse -Force $CookbookDir
  }

  Write-Output "INFO: Extracting $GzipPath to $CookbookDir"
  7za x $GzipPath -o"$Base2Path"
  7za x $TarPath -o"$Destination"

  Write-Output "INFO: Cleaning up $GzipPath $TarPath"
  rm $GzipPath
  rm $TarPath

  Write-Output "INFO: Time taken: $((Get-Date).Subtract($start_time))"
}
catch
{
  Write-Output "ERROR: Caught an exception:"
  Write-Output "ERROR: Exception Type: $($_.Exception.GetType().FullName)"
  Write-Output "ERROR: Exception Message: $($_.Exception.Message)"
  exit 1
}
exit 0
