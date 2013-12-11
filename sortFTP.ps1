#######################
# Sorts Remote Connections for Eclipse
# This script needs to be run on Eclipse execution. It will sort your remote connections before starting the application.
# If this script has any issues it has the potential to wreck all of your FTP connections! I suggest backing up your node.properties just in case.
# 1. Place this script in WORKSPACE/.metadata/.plugins/org.eclipse.rse.core/profiles (We may need to move this as the file contents could be overwritten, but I put it there for now)
# 2. Setup the constants
# 3. Create a shortcut on the desktop (or wherever you prefer) with the following as the target:
# powershell.exe -command "& 'E:\Web Workspace\.metadata\.plugins\org.eclipse.rse.core\sortFTP.ps1'"
# You will need to adjust the path to your workspace, but you get the idea.
# Kyle B
# 11/12/2013
#######################


#######################
# CONSTANTS
#######################

# Eclipse executable file path (Full Path)
Set-Variable eclipse -option Constant -value "E:\Zend\zend-eclipse-php\zend-eclipse-php.exe"
# Set the profile name of your eclipse profile. Find this by doing the following steps:
# 1. Find workspace
# 2. Go to .metadata/.plugins/org.eclipse.rse.core/profiles
# 3. Your profile name will be the name of the only folder under profiles. Mine is PRF.kyles-pc_539
Set-Variable profile -option Constant -value PRF.kylesgg-pc_539
# The name of the file from Eclipse. This shouldn't change
Set-Variable fileName -option Constant -value node.properties

#######################
# FUNCTIONS
#######################
#
#               _,........__
#            ,-'            "`-.
#          ,'                   `-.
#        ,'                        \
#      ,'                           .
#      .'\               ,"".       `
#     ._.'|             / |  `       \
#     |   |            `-.'  ||       `.
#     |   |            '-._,'||       | \
#     .`.,'             `..,'.'       , |`-.
#     l                       .'`.  _/  |   `.
#     `-.._'-   ,          _ _'   -" \  .     `
#`."""""'-.`-...,---------','         `. `....__.
#.'        `"-..___      __,'\          \  \     \
#\_ .          |   `""""'    `.           . \     \
#  `.          |              `.          |  .     L
#    `.        |`--...________.'.        j   |     |
#      `._    .'      |          `.     .|   ,     |
#         `--,\       .            `7""' |  ,      |
#            ` `      `            /     |  |      |    _,-'"""`-.
#             \ `.     .          /      |  '      |  ,'          `.
#              \  v.__  .        '       .   \    /| /              \
#               \/    `""\"""""""`.       \   \  /.''                |
#                `        .        `._ ___,j.  `/ .-       ,---.     |
#                ,`-.      \         ."     `.  |/        j     `    |
#               /    `.     \       /         \ /         |     /    j
#              |       `-.   7-.._ .          |"          '         /
#              |          `./_    `|          |            .     _,'
#              `.           / `----|          |-............`---'
#                \          \      |          |
#               ,'           )     `.         |
#                7____,,..--'      /          |
#                                  `---.__,--.'
#
# 
# Squirtle use Bubblesort!
# It's a bubble sort
# It only works on an array of strings

function bubbleSort($unsorted_array)
{
	$swapFlag = 1
	$temp

	for($i=1;($i -le $unsorted_array.length -and $swapFlag); $i++){
		$swapFlag = 0;
		for($j=0; $j -lt ($unsorted_array.length -1); $j++){
			$a = $unsorted_array[$j].split("=")
			$b = $unsorted_array[$j+1].split("=")
			$c = [string]::Compare($a[1], $b[1], $True)
			if($c -eq 1){
				$temp = $($b[0] + "=" + $a[1])
				$unsorted_array[$j] = $($a[0] + "=" + $b[1])
				$unsorted_array[$j+1] = $temp
				$swapFlag = 1
			}
			
		}
	}
	# I know this is named "Unsorted Array" which makes so sense, but let's roll with it
	return $unsorted_array
}

#######################
# MAIN
#######################
# Get file contents
$file = Get-content "$($profile)/$($fileName)"
# Put first few lines of file to the side
$beginningOfFile = $file[0 .. 5]
# Get the rest of the file
$choppedFile = $file[6 .. ($file.length-1)]
# Sort the list of remote connections
$sortedFile = bubbleSort($choppedFile)
# Make sure the new array isn't empty
if($sortedFile.count -gt 0){
	#Combine beginning piece of file with the sorted piece of the file
	$newFile = $beginningOfFile + $sortedFile
	# Write to file!
	$newFile | out-file -encoding ASCII "$($profile)/$($fileName)"
}
# Sorted! Run Eclipse
& $eclipse
#######################
# END OF MAIN
#######################
