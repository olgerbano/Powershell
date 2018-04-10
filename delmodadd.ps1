function Diference{
   $content1 = $(Get-Content $args[1])                                         
   $content2 = $(Get-Content $args[0])                          
   $nrrrjeshta1 = ($content1 | Measure-Object ).Count                                         
   $nrrrjeshta2 = ($content2 | Measure-Object ).Count
   if($nrrrjeshta1 -eq 0){
        $lista56 = @()
            $prop_s =New-Object -TypeName PSCustomObject -Property @{
                  added = 0
                  mod = 0
                  del = $nrrrjeshta2 
            }            
            $lista56 += $prop_s 
            return $lista56
   }
   elseif($nrrrjeshta2 -eq 0){
        $lista56 = @()
            $prop_s =New-Object -TypeName PSCustomObject -Property @{
                  added = $nrrrjeshta1
                  mod = 0
                  del = 0
            }            
            $lista56 += $prop_s 
            return $lista56
   }
   else{
       $comparedLines = Compare-Object $content1 $content2 | 
                         Sort-Object { $_.InputObject.ReadCount }                                             
       $listalista = @()                                 
       $lineNumber = 0                                             
       $comparedLines | foreach {
           if($_.SideIndicator -eq "==" -or $_.SideIndicator -eq "<=" -or $_.SideIndicator -eq "=>" ){                                                                                                  
             $lineNumber = $_.InputObject.ReadCount                                                
            }                                                            
	        if($_.SideIndicator -ne "==") {	                                                     
	             if($_.SideIndicator -eq "<="){  	                                                         
	                $lineOperation = "added" 	    
	             } 
	             elseif($_.SideIndicator -eq "=>"){ 	                                                         
	                     $lineOperation = "deleted" 	            
	             }	                
	            $props =New-Object -TypeName PSCustomObject -Property @{
	                Line = $lineNumber
	                numer = 0 
	                Operation = $lineOperation 
	                Text = $_.InputObject
	                Nrtjeter = 0
	            }	            
	                 $listalista += $props 	    
	        }                                                  
        }                
        foreach($l1 in $listalista){                                               
            foreach($l2 in $listalista){                                                
                if($l1.Line -eq $l2.Line){                         
                    $l1.numer++                                                    
                }                                                    
                if($l1.numer -gt 2){                                                    
                    $l1.numer--                                                    
                }                                              
            }                                            
        }
        foreach($l1 in $listalista){                                                
            foreach($l2 in $listalista){                                                    
                if( ($l1.Line -eq $l2.Line) -and ($l1.Text.Trim() -eq $l2.Text.Trim() ) ) {                                                       
                    $l1.Nrtjeter++                                                    
                }                                                
            }                                            
        }      
        $listalista = $listalista | Select-Object | where{$_.Nrtjeter -lt 2}                                            
        $nrtot = ($listalista | Measure-Object).Count                                            
        $addordel = $listalista | Select-Object | where{$_.Numer -eq 1}                                            
        $nraddordel = ( $addordel | Measure-Object).Count
        $rrjeshtamod = ($nrtot - $nraddordel)/2
        $rrjeshtaadd = ($addordel | Select-Object | where{$_.Operation -eq "added"} | Measure-Object).Count     
        foreach($elem22 in $addordel | Select-Object | where{$_.Operation -eq "added"}){
            if($elem22.Line -lt $nrrrjeshta2 ){                                                    
                $rrjeshtaadd--                                                    
                $rrjeshtamod++
            }            
        }
        $rrjeshtadel = ($addordel | Select-Object | where{$_.Operation -eq "deleted"} | Measure-Object).Count
        $lista56 = @()
        $prop_s =New-Object -TypeName PSCustomObject -Property @{
            added = $rrjeshtaadd
            mod = $rrjeshtamod
            del = $rrjeshtadel 
        }            
        $lista56 += $prop_s 
        return $lista56
    }
}
$li = Diference $args[0] $args[1]
Write-Host added $li.added
Write-Host modyfied $li.mod
Write-Host deleted $li.del