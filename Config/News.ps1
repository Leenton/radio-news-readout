$NewsConfig = Get-Content -Path "\\club-main\Profiles\Dev-Leenton\Documents\Powershell\News Broadcast\Config\NewsConfig.json" | ConvertFrom-Json
$Temp = @()

#Gucci
function Log-ChosenItems($SelectedItems, $BroadcastHistory, $WeighedItems){
    $NewBroadCastHistory = [PSCustomObject]@{
        "Low" = @()
        "Medium" = @()
        "High" = @()
        "Critical" = @()
    }
    #Write-Host $WeighedItems
    
    foreach($Item in $BroadcastHistory.Low){
        if($SelectedItems.Name -contains $Item.Title){

            $Item.'Total-Plays' = $Item.'Total-Plays' + 1
            $Item.'Weight' = $WeighedItems[$WeighedItems.Name.IndexOf($Item.Title)].'Weight'- 5
            $Item.'Last-Played' = 0
            $NewBroadcastHistory.'Low' = $NewBroadcastHistory.'Low' + $Item
        }else{
            $Item.'Last-Played' = $Item.'Last-Played' + 1
            $Item.'Weight' = $WeighedItems[$WeighedItems.Name.IndexOf($Item.Title)].'Weight'
            $NewBroadcastHistory.'Low' = $NewBroadcastHistory.'Low' + $Item
        }
    }
    foreach($Item in $BroadcastHistory.Medium){
        if($SelectedItems.Name -contains $Item.Title){
            $Item.'Total-Plays' = $Item.'Total-Plays' + 1
            $Item.'Weight' = $WeighedItems[$WeighedItems.Name.IndexOf($Item.Title)].'Weight'- 5
            $Item.'Last-Played' = 0
            $NewBroadcastHistory.'Medium' = $NewBroadcastHistory.'Medium' + $Item - 5
        }else{
            $Item.'Last-Played' = $Item.'Last-Played' + 1
            $Item.'Weight' = $WeighedItems[$WeighedItems.Name.IndexOf($Item.Title)].'Weight'
            $NewBroadcastHistory.'Medium' = $NewBroadcastHistory.'Medium' + $Item
        }
    }
    foreach($Item in $BroadcastHistory.High){
        if($SelectedItems.Name -contains $Item.Title){
            $Item.'Total-Plays' = $Item.'Total-Plays' + 1
            $Item.'Weight' = $WeighedItems[$WeighedItems.Name.IndexOf($Item.Title)].'Weight'- 5
            $Item.'Last-Played' = 0
            $NewBroadcastHistory.'High' = $NewBroadcastHistory.'High' + $Item
        }else{
            $Item.'Last-Played' = $Item.'Last-Played' + 1
            $Item.'Weight' = $WeighedItems[$WeighedItems.Name.IndexOf($Item.Title)].'Weight'
            $NewBroadcastHistory.'High' = $NewBroadcastHistory.'High' + $Item
        }
    }
    foreach($Item in $BroadcastHistory.Critical){
        if($SelectedItems.Name -contains $Item.Title){
            $Item.'Total-Plays' = $Item.'Total-Plays' + 1
            $Item.'Weight' = $WeighedItems[$WeighedItems.Name.IndexOf($Item.Title)].'Weight'- 5
            $Item.'Last-Played' = 0
            $NewBroadcastHistory.'Critical' = $NewBroadcastHistory.'Critical' + $Item
        }else{
            $Item.'Last-Played' = $Item.'Last-Played' + 1
            $Item.'Weight' = $WeighedItems[$WeighedItems.Name.IndexOf($Item.Title)].'Weight'
            $NewBroadcastHistory.'Critical' = $NewBroadcastHistory.'Critical' + $Item
        }
    }

    
    $BroadcastHistory = $NewBroadcastHistory | ConvertTo-Json
    Set-Content -Path $NewsConfig.'Broadcast-History' -value $BroadcastHistory
    $Date = Get-Date -Format "dd/MM/yyyy dddd HH:mm"
    $Log = "`n" + $Date + " : The following news items will be played out this hour:`n" + $SelectedItems[0].Name + "`n" + $SelectedItems[1].Name + "`n" + $SelectedItems[2].Name + "`n"
    Write-host $Log
    Add-Content -Path $NewsConfig.'Log-File' $Log

}

#Gucci
function Update-History($Low, $Medium, $High, $Critical, $BroadcastHistory){
    #Runs through each of the priority folders and checks if the Item is already in the broadcast history json, if it's not it gets added. 
    $UpdatedLow = @()
    $UpdatedMedium = @()
    $UpdatedHigh = @()
    $UpdatedCritical = @()
    #Write-Host "About to list everything inside the high folder"
    
    foreach($Item in $Low.name){
        if($BroadcastHistory.Low.Title -Contains $Item){
            $UpdatedLow = $UpdatedLow + $BroadcastHistory.Low.Get($BroadcastHistory.Low.Title.IndexOf($Item))
        }else{
            $Item = [PSCustomObject]@{
                "Title" = $Item
                "Total-Plays" = 0
                "Last-Played" = 0
                "Dated-Added"= [String](Get-Date)
                "Weight" = 0
            }
            $UpdatedLow = $UpdatedLow + $Item
        }   
    }
    foreach($Item in $Medium.name){
        if($BroadcastHistory.Medium.Title -Contains $Item){
            $UpdatedMedium = $UpdatedMedium + $BroadcastHistory.Medium.Get($BroadcastHistory.Medium.Title.IndexOf($Item))
        }else{
            $Item = [PSCustomObject]@{
                "Title" = $Item
                "Total-Plays" = 0
                "Last-Played" = 0
                "Dated-Added"= [String](Get-Date)
                "Weight" = 0
            }
            $UpdatedMedium = $UpdatedMedium + $Item
        }   
    }
    foreach($Item in $High.name){
        
        if($BroadcastHistory.High.Title -Contains $Item){
            $UpdatedHigh = $UpdatedHigh + $BroadcastHistory.High.Get($BroadcastHistory.High.Title.IndexOf($Item))
        }else{
            $Item = [PSCustomObject]@{
                "Title" = $Item
                "Total-Plays" = 0
                "Last-Played" = 0
                "Dated-Added"= [String](Get-Date)
                "Weight" = 0
            }
            $UpdatedHigh = $UpdatedHigh + $Item
        }   
    }
    foreach($Item in $Critical.name){
        if($BroadcastHistory.Critical.Title -Contains $Item){
            $UpdatedCritical = $UpdatedCritical + $BroadcastHistory.Critical.Get($BroadcastHistory.High.Title.IndexOf($Item))
        } else{
            $Item = [PSCustomObject]@{
                "Title" = $Item
                "Total-Plays" = 0
                "Last-Played" = 0
                "Dated-Added"= [String](Get-Date)
                "Weight" = 0            }
            $UpdatedCritical = $UpdatedCritical + $Item
        }  
    }
    $BroadcastHistory = [PSCustomObject]@{
        "Low" = $UpdatedLow
        "Medium" = $UpdatedMedium
        "High" = $UpdatedHigh
        "Critical" = $UpdatedCritical
    }
    return $BroadcastHistory
}

#Gucci
function Get-Weights($Low, $Medium, $High, $Critical, $BroadcastHistory){
    #Runs though all the items provided and asigns each item a weight
    $WeighedItems = @()
    $Weight = 0
    $Modififer
    foreach($Item in $Low){
        if($Item.'Total-Plays' -eq 0){
            $Weight = $NewsConfig.'Low-Starting-Weight'
        }else{
            $Weight = $Item.'Weight' 
        }
        if($Items.'Last-Played' -gt 2){
            $Weight = $Weight * (1 + 0.05)
        }
        $Item = [PSCustomObject]@{
            "Location" = $NewsConfig.'Low-Priority' + "\" +$Item.'Title'
            "Weight" = $Weight
            "Name" = $Item.Title
        }
        $WeighedItems = $WeighedItems + $Item
    }
    foreach($Item in $Medium){
        if($Item.'Total-Plays' -eq 0){
            $Weight = $NewsConfig.'Medium-Starting-Weight'
        }else{
            $Weight = $Item.'Weight' 
        }
        if($Items.'Last-Played' -gt 2){
            $Weight = $Weight * (1 + 0.05)
        }
        $Item = [PSCustomObject]@{
            "Location" = $NewsConfig.'Medium-Priority' + "\" + $Item.'Title'
            "Weight" = $Weight
            "Name" = $Item.Title
        }
        $WeighedItems = $WeighedItems + $Item
    }
    foreach($Item in $High){
        if($Item.'Total-Plays' -eq 0){
            $Weight = $NewsConfig.'High-Starting-Weight'
        }else{
            $Weight = $Item.'Weight' 
        }
        if($Items.'Last-Played' -gt 2){
            $Weight = $Weight * (1 + 0.05)
        }
        $Item = [PSCustomObject]@{
            "Location" = $NewsConfig.'High-Priority' + "\" + $Item.'Title'
            "Weight" = $Weight
            "Name" = $Item.Title
        }
        $WeighedItems = $WeighedItems + $Item
    }
    foreach($Item in $Critical){
        if($Item.'Total-Plays' -eq 0){
            $Weight = $NewsConfig.'Critical-Starting-Weight'
        }else{
            $Weight = $Item.'Weight' 
        }
        if($Items.'Last-Played' -gt 2){
            $Weight = $Weight * (1 + 0.05)
        }
        $Item = [PSCustomObject]@{
            "Location" = $NewsConfig.'Critical-Priority' + "\" + $Item.'Title'
            "Weight" = $Weight
            "Name" = $Item.Title
        }
        $WeighedItems = $WeighedItems + $Item
    }
    return $WeighedItems
       
}

#Gucci
function Get-NewsItems($Low, $Medium, $High, $Critical, $BroadcastHistory){
    #Convert the histroy to a powershell object then pass it to get updated. In the update it removes any entries in the JSON that have been removed from their respective folders.
    $BroadcastHistory = Get-Content -LiteralPath $BroadcastHistory | ConvertFrom-Json
    $BroadcastHistory = Update-History -Low $Low -Medium $Medium -High $High -Critical $Critical -BroadcastHistory $BroadcastHistory

    #Weighs all the Items in the folders and returns an arrary of new stories from highest weight to lowest weight for us to chose from.
    $WeighedItems = Get-Weights -Low $BroadcastHistory.Low -Medium $BroadcastHistory.Medium -High $BroadcastHistory.High -Critical $BroadcastHistory.Critical
    $WeighedItems = $WeighedItems | Sort-object -property "Weight" -Descending

    #Update the Broadcast history and write in the Log what Items where chosen for that hours news.
    Log-ChosenItems -SelectedItems $WeighedItems[0..2] -BroadcastHistory $BroadcastHistory -WeighedItems $WeighedItems
    return $WeighedItems[0..2]
}

#Gucci
function Update-BA1News(){
    $LowItems = Get-ChildItem -Path $NewsConfig."Low-Priority"
    $MediumItems = Get-ChildItem -Path $NewsConfig."Medium-Priority"
    $HighItems = Get-ChildItem -Path $NewsConfig."High-Priority"
    $CriticalItems = Get-ChildItem -Path $NewsConfig."Critical-Priority"
    $NewsItems = Get-NewsItems -Low $LowItems -Medium $MediumItems -High $HighItems -Critical $CriticalItems -BroadcastHistory $NewsConfig.'Broadcast-History'
    
    #Copy selected news items to playout folders
    $Location = $NewsConfig.'Playout-Folder' + "\Story 1\"
    Copy-Item -Path $NewsItems[0].Location -Destination $Location
    $Location = $NewsConfig.'Playout-Folder' + "\Story 2\"
    Copy-Item -Path $NewsItems[1].Location -Destination $Location
    $Location = $NewsConfig.'Playout-Folder' + "\Story 3\"
    Copy-Item -Path $NewsItems[2].Location -Destination $Location
    return $NewsItems
}