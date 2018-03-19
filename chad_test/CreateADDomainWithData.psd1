@{ 
    AllNodes = @( 
        @{ 
            Nodename = 'localhost'
            PSDscAllowDomainUser = $true
        }
    )

    NonNodeData = @{

        UserData = @'
UserName,Password,Dept,Title
craigf,P@55w0rd,IT,Grand Poobah
hartlw,P@55w0rd,Accounting,Money Launderer Extraordinare
dufoua,P@55w0rd,Marketing,F-Bomb Dropper
barric,P@55w0rd,Operations,Monkey with a Keyboard
'@

        RootOUs = 'Accounting','IT','Marketing','Operations'
        ChildOUs = 'Users','Computers','Groups'

    }
} 
