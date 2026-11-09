trap {
    $errText = "GFL SolvIT Tools could not start.`n`n$($_.Exception.Message)`n`nLine $($_.InvocationInfo.ScriptLineNumber): $("$($_.InvocationInfo.Line)".Trim())"
    try {
        Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
        [System.Windows.MessageBox]::Show($errText, "GFL SolvIT Tools", "OK", "Error") | Out-Null
    } catch {
        Write-Host $errText -ForegroundColor Red
        Read-Host "Press Enter to close"
    }
    exit 1
}

if ([System.Threading.Thread]::CurrentThread.ApartmentState -ne [System.Threading.ApartmentState]::STA -and $PSCommandPath) {
    Start-Process powershell.exe -ArgumentList "-NoProfile -STA -File `"$PSCommandPath`""
    exit
}

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase
Add-Type -AssemblyName Microsoft.VisualBasic

$script:AppVersionDate = "05/11/2026"

$inputXML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="GFLSolvIT Tools" Height="780" Width="1050" Background="#F3F3F3">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="190"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <Border Grid.Column="0" Background="#2D2D30">
            <Grid Margin="0,20,0,0">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <TextBlock Grid.Row="0" Text="GFL SolvIT Tools" Foreground="White" FontSize="20" FontWeight="Bold" Margin="20,0,0,30" FontFamily="Segoe UI"/>

                <StackPanel Grid.Row="1">
                    <Button Name="btnLaps" Height="40" Background="#3E3E42" Foreground="White" BorderThickness="0" HorizontalContentAlignment="Left" Padding="15,0,0,0">
                        <StackPanel Orientation="Horizontal">
                            <TextBlock FontFamily="Segoe MDL2 Assets" Text="&#xE8D7;" FontSize="16" VerticalAlignment="Center" Margin="0,0,10,0"/>
                            <TextBlock Text="LAPS" VerticalAlignment="Center"/>
                        </StackPanel>
                    </Button>

                    <Button Name="btnUserInfo" Height="40" Background="Transparent" Foreground="White" BorderThickness="0" HorizontalContentAlignment="Left" Padding="15,0,0,0">
                        <StackPanel Orientation="Horizontal">
                            <TextBlock FontFamily="Segoe MDL2 Assets" Text="&#xE77B;" FontSize="16" VerticalAlignment="Center" Margin="0,0,10,0"/>
                            <TextBlock Text="User Info" VerticalAlignment="Center"/>
                        </StackPanel>
                    </Button>

                    <Button Name="btnPrinterCard" Height="40" Background="Transparent" Foreground="White" BorderThickness="0" HorizontalContentAlignment="Left" Padding="15,0,0,0">
                        <StackPanel Orientation="Horizontal">
                            <TextBlock FontFamily="Segoe MDL2 Assets" Text="&#xE749;" FontSize="16" VerticalAlignment="Center" Margin="0,0,10,0"/>
                            <TextBlock Text="Printer Card" VerticalAlignment="Center"/>
                        </StackPanel>
                    </Button>

                    <Button Name="btnEmployeeID" Height="40" Background="Transparent" Foreground="White" BorderThickness="0" HorizontalContentAlignment="Left" Padding="15,0,0,0">
                        <StackPanel Orientation="Horizontal">
                            <TextBlock FontFamily="Segoe MDL2 Assets" Text="&#xE779;" FontSize="16" VerticalAlignment="Center" Margin="0,0,10,0"/>
                            <TextBlock Text="Employee ID" VerticalAlignment="Center"/>
                        </StackPanel>
                    </Button>

                    <Button Name="btnPaths" Height="40" Background="Transparent" Foreground="White" BorderThickness="0" HorizontalContentAlignment="Left" Padding="15,0,0,0">
                        <StackPanel Orientation="Horizontal">
                            <TextBlock FontFamily="Segoe MDL2 Assets" Text="&#xED25;" FontSize="16" VerticalAlignment="Center" Margin="0,0,10,0"/>
                            <TextBlock Text="Paths" VerticalAlignment="Center"/>
                        </StackPanel>
                    </Button>

                    <Button Name="btnTier2" Height="40" Background="Transparent" Foreground="White" BorderThickness="0" HorizontalContentAlignment="Left" Padding="15,0,0,0">
                        <StackPanel Orientation="Horizontal">
                            <TextBlock FontFamily="Segoe MDL2 Assets" Text="&#xE774;" FontSize="16" VerticalAlignment="Center" Margin="0,0,10,0"/>
                            <TextBlock Text="Time Zones / Tier 2" VerticalAlignment="Center"/>
                        </StackPanel>
                    </Button>

                </StackPanel>

                <StackPanel Grid.Row="2">
                    <Border Height="1" Background="#3E3E42" Margin="15,0,15,8"/>

                    <TextBlock Name="txtVersion" Text="" FontSize="10" Foreground="Gray" HorizontalAlignment="Left" Margin="20,8,0,10" />
                </StackPanel>
            </Grid>
        </Border>

        <Grid Grid.Column="1">
            <Grid Name="screenLaps" Visibility="Visible">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/> <RowDefinition Height="80"/>   <RowDefinition Height="*"/>    </Grid.RowDefinitions>
    
                <StackPanel Grid.Row="0" Margin="25,15,0,15">
                    <TextBlock Text="LAPS" FontSize="24" FontWeight="Bold" Foreground="#2D2D30" FontFamily="Segoe UI"/>
                    <TextBlock Text="Search for a workstation asset tag to retrieve credentials." FontSize="13" Foreground="#666"/>
                </StackPanel>

                <Border Grid.Row="1" Background="White" BorderBrush="#E5E5E5" BorderThickness="0,0,0,1">
                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center" Margin="20,0">
                        <Border CornerRadius="15" Background="#F1F1F1" Width="300" Height="35" Padding="10,0">
                            <TextBox Name="assetTagSearch" BorderThickness="0" Background="Transparent" VerticalContentAlignment="Center" Text="Search Asset Tag..." Foreground="Gray"/>
                        </Border>
                        <Button Name="btnsearchLaps" Content="Search" Margin="10,0" Width="100" Height="35" Background="#007ACC" Foreground="White">
                            <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="5"/></Style></Button.Resources>
                        </Button>
                        <TextBlock Name="lblLapsError" Text="Asset Tag not found!" TextWrapping="Wrap" MaxWidth="400" Foreground="#D13438" FontSize="12" FontWeight="SemiBold" Margin="25,0,0,0" Visibility="Collapsed" VerticalAlignment="Center"/>
                    </StackPanel>
                </Border>

                <Grid Grid.Row="2" Margin="30">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="300"/>
                    </Grid.ColumnDefinitions>

                    <StackPanel Grid.Column="0" Name="lapsResultCard" Visibility="Collapsed">
                        <Border Width="380" HorizontalAlignment="Left" Background="White" CornerRadius="12">
                            <Border.Effect><DropShadowEffect BlurRadius="15" Opacity="0.1" ShadowDepth="4"/></Border.Effect>
                            <Border Padding="25">
                                <StackPanel>
                                    <TextBox Name="lblAssetTitle" Text="Workstation Details" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontSize="18" FontWeight="Bold" Margin="0,0,0,15"/>
                                    <Separator Background="#EEE" Margin="0,0,0,20"/>
                                    <TextBlock Text="Local Admin User" Foreground="#888" FontSize="11" Margin="0,0,0,2"/>
                                    <TextBox Name="lblAdminUser" Text=".\Administrator" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontSize="16" FontWeight="SemiBold" Margin="0,0,0,20"/>
                                    <TextBlock Text="Password" Foreground="#888" FontSize="11" Margin="0,0,0,2"/>
                                    <Border Background="#F9F9F9" Padding="15" CornerRadius="8">
                                        <TextBox Name="lblAdminPass" Text="PasswordValue" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontSize="20" FontFamily="Consolas" Foreground="#D13438" FontWeight="Bold"/>
                                    </Border>
                                    <TextBlock Text="Computer Location" Foreground="#888" FontSize="11" Margin="0,2,0,0"/>
                                    <TextBox Name="lblAssetOU" Text="OU" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontSize="16" FontWeight="SemiBold" Margin="0,0,0,20" TextWrapping="Wrap"/>
                                </StackPanel>
                            </Border>
                        </Border>
                    </StackPanel>

                    <StackPanel Grid.Column="1" Margin="20,0,0,0" VerticalAlignment="Top">
                        <Border Background="White" CornerRadius="10">
                            <Border.Effect><DropShadowEffect BlurRadius="10" Opacity="0.05"/></Border.Effect>
                            <Border Padding="15">
                                <StackPanel>
                                    <TextBlock Text="Recent Searches" FontWeight="Bold" Foreground="#333" Margin="0,0,0,10"/>
                                    <ListBox Name="listLapsHistory" BorderThickness="0" Background="Transparent" Height="110"/>
                                    <Button Name="btnClearHistory" Content="Clear History" Background="Transparent" Foreground="#999" FontSize="10" BorderThickness="0" Margin="0,10,0,0"/>
                                </StackPanel>
                            </Border>
                        </Border>

                        <Grid Name="pingPanel" Margin="0,15,0,0" Visibility="Collapsed"
                              UseLayoutRounding="True" SnapsToDevicePixels="True"
                              TextOptions.TextFormattingMode="Display" TextOptions.TextRenderingMode="ClearType">
                            <Border Background="White" CornerRadius="10">
                                <Border.Effect><DropShadowEffect BlurRadius="10" Opacity="0.05"/></Border.Effect>
                            </Border>
                            <Border Background="White" CornerRadius="10" Padding="15">
                                <StackPanel>
                                    <TextBlock Name="pingTitle" Text="Ping" FontWeight="Bold" Foreground="#333"/>
                                    <TextBlock Name="pingSubtitle" Text="" FontSize="10" Foreground="#888" TextTrimming="CharacterEllipsis"/>
                                    <Border Name="pingStatusBox" Background="#888888" CornerRadius="8" Margin="0,10,0,0" Padding="12,8">
                                        <StackPanel>
                                            <TextBlock Name="pingStatus" Text="CHECKING..." FontSize="18" FontWeight="Bold" Foreground="White"/>
                                            <TextBlock Name="pingDetail" Text="" FontSize="11" Foreground="White" TextWrapping="Wrap"/>
                                        </StackPanel>
                                    </Border>
                                    <TextBlock Name="pingStats" Text="Sent: 0   Replies: 0   Lost: 0" FontSize="10" Foreground="#666" Margin="0,8,0,6"/>
                                    <TextBox Name="pingLog" Height="120" IsReadOnly="True" FontFamily="Consolas" FontSize="10" Background="#F9F9F9" BorderBrush="#E5E5E5"
                                             VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Auto" TextWrapping="NoWrap"/>
                                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,10,0,0">
                                        <Button Name="pingToggle" Content="Stop" Width="80" Height="28" Margin="0,0,8,0" Background="#007ACC" Foreground="White" BorderThickness="0">
                                            <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="5"/></Style></Button.Resources>
                                        </Button>
                                        <Button Name="pingClose" Content="Close" Width="80" Height="28" Background="#F1F1F1" BorderThickness="0">
                                            <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="5"/></Style></Button.Resources>
                                        </Button>
                                    </StackPanel>
                                </StackPanel>
                            </Border>
                        </Grid>
                    </StackPanel>
                </Grid>
            </Grid>

            <Grid Name="screenUserInfo" Visibility="Collapsed">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/> <RowDefinition Height="80"/> <RowDefinition Height="Auto"/>   <RowDefinition Height="*"/>    <RowDefinition Height="Auto"/><RowDefinition Height="12"/> </Grid.RowDefinitions>

                <StackPanel Grid.Row="0" Margin="25,15,0,15">
                    <TextBlock Text="User Account Lookup" FontSize="24" FontWeight="Bold" Foreground="#2D2D30" FontFamily="Segoe UI"/>
                    <TextBlock Text="Lookup Active Directory user details, account status, and security groups." FontSize="13" Foreground="#666"/>
                </StackPanel>

                <Border Grid.Row="1" Background="White" BorderBrush="#E5E5E5" BorderThickness="0,0,0,1">
                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center" Margin="20,0">
                        <Border CornerRadius="15" Background="#F1F1F1" Width="300" Height="35" Padding="10,0">
                            <TextBox Name="userSearch" BorderThickness="0" Background="Transparent" VerticalContentAlignment="Center" Text="Search User..." Foreground="Gray"/>
                        </Border>
                        <Button Name="btnsearchUser" Content="Search" Margin="10,0" Width="100" Height="35" Background="#007ACC" Foreground="White">
                            <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="5"/></Style></Button.Resources>
                        </Button>
                        <TextBlock Name="lblUserError" Text="User not found!" TextWrapping="Wrap" MaxWidth="400" Foreground="#D13438" FontSize="12" FontWeight="SemiBold" Margin="25,0,0,0" Visibility="Collapsed" VerticalAlignment="Center"/>
                    </StackPanel>
                </Border>

                <Border Name="userSubNavbar" Grid.Row="2" Background="#F9F9F9" BorderBrush="#E5E5E5" BorderThickness="0,1,0,1" Visibility="Collapsed">
                    <StackPanel Orientation="Horizontal" Margin="20,0">
                        <Button Name="btnSubUserInfo" Content="Information" Background="Transparent" Foreground="#007ACC" FontWeight="SemiBold" BorderThickness="0,0,0,2" BorderBrush="#007ACC" Height="40" Padding="15,0" Cursor="Hand"/>
                        <Button Name="btnSubUserGroups" Content="Groups" Background="Transparent" Foreground="#666" BorderThickness="0" Height="40" Padding="15,0" Cursor="Hand"/>
                        <Button Name="btnSubUserApps" Content="Apps" Background="Transparent" Foreground="#666" BorderThickness="0" Height="40" Padding="15,0" Cursor="Hand"/>
                    </StackPanel>
                </Border>

                <Grid Grid.Row="3" Name="userContentArea" Margin="25" Visibility="Collapsed">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="400"/> 
                        <ColumnDefinition Width="320"/> 
                    </Grid.ColumnDefinitions>

                    <Border Grid.Column="0" Background="White" CornerRadius="12" VerticalAlignment="Top">
                        <Border.Effect><DropShadowEffect BlurRadius="15" Opacity="0.1" ShadowDepth="4"/></Border.Effect>
                        <Border Padding="25">
                            <StackPanel>
                                <Grid Margin="0,0,0,20">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="Auto"/>
                                    </Grid.ColumnDefinitions>
                                    <StackPanel Orientation="Horizontal">
                                        <Border Width="50" Height="50" CornerRadius="25" Background="#007ACC" Margin="0,0,15,0">
                                            <TextBlock Text="&#xE77B;" FontFamily="Segoe MDL2 Assets" Foreground="White" FontSize="24" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                        </Border>
                                        <StackPanel VerticalAlignment="Center">
                                            <TextBox Name="lblUserName" Text="User Name" IsReadOnly="True" FontSize="18" FontWeight="Bold" BorderThickness="0" Background="Transparent"/>
                                            <TextBox Name="lblUserJobTitle" Text="Job Title" IsReadOnly="True" FontSize="13" Foreground="#666" BorderThickness="0" Background="Transparent"/>
                                        </StackPanel>
                                    </StackPanel>
                                    <Button Grid.Column="1" Name="btnPopOutUser" Content="&#xE8A7;" FontFamily="Segoe MDL2 Assets" FontSize="14" Width="30" Height="30" VerticalAlignment="Top"
                                            Background="Transparent" Foreground="#007ACC" BorderThickness="0" Cursor="Hand" ToolTip="Open this user in a separate window"/>
                                </Grid>
                                <Separator Background="#EEE" Margin="0,0,0,20"/>
                                <Grid Name="gridUserInfo">
                                    <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>

                                    <Grid.RowDefinitions>
                                        <RowDefinition Height="Auto"/><RowDefinition Height="12"/> 
                                        <RowDefinition Height="Auto"/><RowDefinition Height="12"/> 
                                        <RowDefinition Height="Auto"/><RowDefinition Height="12"/> 
                                        <RowDefinition Height="Auto"/><RowDefinition Height="12"/> 
                                        <RowDefinition Height="Auto"/><RowDefinition Height="12"/> 
                                        <RowDefinition Height="Auto"/><RowDefinition Height="12"/> 
                                        <RowDefinition Height="Auto"/><RowDefinition Height="12"/> 
                                        <RowDefinition Height="Auto"/><RowDefinition Height="12"/>
                                        <RowDefinition Height="Auto"/>
                                    </Grid.RowDefinitions>

                                    <TextBlock Grid.Row="0" Text="Status:" Foreground="#888" FontSize="12" VerticalAlignment="Center"/>
                                    <StackPanel Grid.Row="0" Grid.Column="1" Orientation="Horizontal" HorizontalAlignment="Right">
                                        <Button Name="btnUnlockAccount" Content="UNLOCK" Background="#D13438" Foreground="White" FontSize="10" FontWeight="Bold" Padding="8,2" Margin="0,0,10,0" Visibility="Collapsed">
                                            <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="4"/></Style></Button.Resources>
                                        </Button>
                                        <Button Name="btnResetPassword" Content="RESET PWD" Background="#007ACC" Foreground="White" FontSize="10" FontWeight="Bold" Padding="8,2" Margin="0,0,10,0">
                                            <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="4"/></Style></Button.Resources>
                                        </Button>
                                        <Border Name="brdUserStatus" Padding="8,2" CornerRadius="4" Background="#E1F5FE">
                                            <TextBlock Name="lblUserStatus" Text="Unlocked" FontSize="11" FontWeight="Bold"/>
                                        </Border>
                                    </StackPanel>
                                    <TextBlock Grid.Row="2" Text="Employee ID:" Foreground="#888" FontSize="12"/>
                                    <TextBox Grid.Row="2" Grid.Column="1" Name="lblEmployeeID" Text="N/A" IsReadOnly="True" BorderThickness="0" Background="Transparent" HorizontalAlignment="Right" FontWeight="SemiBold"/>
                                    <TextBlock Grid.Row="4" Text="User Level:" Foreground="#888" FontSize="12"/>
                                    <TextBox Grid.Row="4" Grid.Column="1" Name="lblUserLevel" Text="Standard User" IsReadOnly="True" BorderThickness="0" Background="Transparent" HorizontalAlignment="Right" FontWeight="SemiBold"/>
                                    <TextBlock Grid.Row="6" Text="Username:" Foreground="#888" FontSize="12"/>
                                    <TextBox Grid.Row="6" Grid.Column="1" Name="lblUserSam" Text="N/A" IsReadOnly="True" BorderThickness="0" Background="Transparent" HorizontalAlignment="Right" FontWeight="SemiBold"/>
                                    <TextBlock Grid.Row="8" Text="Email:" Foreground="#888" FontSize="12"/>
                                    <TextBox Grid.Row="8" Grid.Column="1" Name="lblUserEmail" Text="N/A" IsReadOnly="True" BorderThickness="0" Background="Transparent" HorizontalAlignment="Right" FontWeight="SemiBold"/>
                                    <TextBlock Grid.Row="10" Text="Manager:" Foreground="#888" FontSize="12"/>
                                    <TextBox Grid.Row="10" Grid.Column="1" Name="lblUserManager" Text="N/A" IsReadOnly="True" BorderThickness="0" Background="Transparent" HorizontalAlignment="Right" FontWeight="SemiBold"/>
                                    <TextBlock Grid.Row="12" Text="Phone/Mobile:" Foreground="#888" FontSize="12"/>
                                    <TextBox Grid.Row="12" Grid.Column="1" Name="lblUserPhone" Text="N/A" IsReadOnly="True" BorderThickness="0" Background="Transparent" HorizontalAlignment="Right" FontWeight="SemiBold"/>
                                    <TextBlock Grid.Row="14" Text="Address:" Foreground="#888" FontSize="12" VerticalAlignment="Top"/>
                                    <TextBox Grid.Row="14" Grid.Column="1" Name="lblUserAddress" Text="N/A" IsReadOnly="True" BorderThickness="0" Background="Transparent" HorizontalAlignment="Right" FontWeight="SemiBold" TextWrapping="Wrap" TextAlignment="Right" MaxWidth="220"/>
                                    <TextBlock Grid.Row="16" Text="Expiration Date:" Foreground="#888" FontSize="12" VerticalAlignment="Center"/>
                                    <StackPanel Grid.Row="16" Grid.Column="1" Orientation="Horizontal" HorizontalAlignment="Right">
                                        <TextBox Name="lblExpirationText" Text="Never" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontWeight="SemiBold" VerticalAlignment="Center" Margin="0,0,10,0"/>
    
                                        <DatePicker Name="dpAccountExpiration" Width="30" Height="25" Background="Transparent" BorderThickness="0"/>
    
                                        <Button Name="btnClearExpiration" Content="&#xE711;" FontFamily="Segoe MDL2 Assets" Width="30" Height="25" Margin="5,0,0,0" Background="#dc3545" Foreground="White" ToolTip="Set to Never Expire">
                                            <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="4"/></Style></Button.Resources>
                                        </Button>

                                        <Button Name="btnSaveExpiration" Content="&#xE74E;" FontFamily="Segoe MDL2 Assets" Width="30" Height="25" Margin="5,0,0,0" Background="#28a745" Foreground="White" ToolTip="Save Expiration Date">
                                            <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="4"/></Style></Button.Resources>
                                        </Button>
                                    </StackPanel>

                                </Grid>
                            </StackPanel>
                        </Border>
                    </Border>

                    <StackPanel Grid.Column="1" Margin="20,0,0,0">
                        <Border Background="White" CornerRadius="12" Margin="0,0,0,20">
                            <Border.Effect><DropShadowEffect BlurRadius="10" Opacity="0.05"/></Border.Effect>
                            <Border Padding="20">
                                <StackPanel>
                                    <TextBlock Text="Extensions" FontWeight="Bold" Margin="0,0,0,12"/>
            
                                    <TextBlock Text="Exch Remote Type" Foreground="#888" FontSize="10"/>
                                    <TextBox Name="lblUserExch" Text="N/A" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontWeight="SemiBold" Margin="0,0,0,10" FontSize="11"/>
            
                                    <TextBlock Text="Extension Attr 2" Foreground="#888" FontSize="10"/>
                                    <TextBox Name="lblExtAttr2" Text="N/A" BorderThickness="0,0,0,1" BorderBrush="#EEE" Background="Transparent" FontWeight="SemiBold" Margin="0,0,0,10" FontSize="11"/>
            
                                    <TextBlock Text="Extension Attr 3" Foreground="#888" FontSize="10"/>
                                    <TextBox Name="lblExtAttr3" Text="N/A" BorderThickness="0,0,0,1" BorderBrush="#EEE" Background="Transparent" FontWeight="SemiBold" Margin="0,0,0,15" FontSize="11"/>

                                    <Button Name="btnUpdateAttributes" Content="Update Attributes" Height="28" Background="#007ACC" Foreground="White" FontSize="10" FontWeight="Bold">
                                        <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="4"/></Style></Button.Resources>
                                    </Button>
                                </StackPanel>
                            </Border>
                        </Border>
                        <Border Background="White" CornerRadius="12">
                            <Border.Effect><DropShadowEffect BlurRadius="10" Opacity="0.05"/></Border.Effect>
                            <Border Padding="20">
                                <StackPanel>
                                    <TextBlock Text="Account Activity" FontWeight="Bold" Margin="0,0,0,12"/>
                                    <TextBlock Text="Password Last Set" Foreground="#888" FontSize="10"/>
                                    <TextBox Name="lblPwdLastSet" Text="N/A" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontWeight="SemiBold" Margin="0,0,0,7" FontSize="11"/>
                                    <TextBlock Text="Last Login" Foreground="#888" FontSize="10"/>
                                    <TextBox Name="lblLastLogin" Text="N/A" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontWeight="SemiBold" Margin="0,0,0,7" FontSize="11"/>
                                    <TextBlock Text="Last Bad Login" Foreground="#888" FontSize="10"/>
                                    <TextBox Name="lblLastBadLogin" Text="N/A" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontWeight="SemiBold" Margin="0,0,0,7" FontSize="11"/>
                                    <TextBlock Text="Last Modified" Foreground="#888" FontSize="10"/>
                                    <TextBox Name="lblModified" Text="N/A" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontWeight="SemiBold" Margin="0,0,0,7" FontSize="11"/>
                                    <TextBlock Text="Bad Password Count" Foreground="#888" FontSize="10"/>
                                    <TextBox Name="lblBadPasswordCount" Text="N/A" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontWeight="SemiBold" FontSize="11"/>
                                </StackPanel>
                            </Border>
                        </Border>
                    </StackPanel>
                </Grid>

                <Grid Grid.Row="3" Name="userGroupsArea" Margin="25" Visibility="Collapsed">
                    <Border Background="White" CornerRadius="12" VerticalAlignment="Stretch">
                        <Border.Effect><DropShadowEffect BlurRadius="15" Opacity="0.1" ShadowDepth="4"/></Border.Effect>
                        <Border Padding="20">
                            <StackPanel>
                                <StackPanel Orientation="Horizontal" Margin="0,0,0,10">
                                    <Border CornerRadius="15" Background="#F1F1F1" Width="320" Height="35" Padding="10,0">
                                        <TextBox Name="txtAddGroupName" BorderThickness="0" Background="Transparent" VerticalContentAlignment="Center" Text="Enter group name to add..." Foreground="Gray"/>
                                    </Border>
                                    <Button Name="btnAddUserGroup" Content="Add to Group" Margin="10,0" Width="120" Height="35" Background="#28a745" Foreground="White">
                                        <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="5"/></Style></Button.Resources>
                                    </Button>
                                    <Button Name="btnRemoveUserGroup" Content="Remove Selected" Margin="10,0" Width="130" Height="35" Background="#dc3545" Foreground="White">
                                        <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="5"/></Style></Button.Resources>
                                    </Button>
                                </StackPanel>
                                <TextBlock Name="lblGroupActionError" Text="Error" TextWrapping="Wrap" Foreground="#D13438" FontSize="12" FontWeight="SemiBold" Margin="0,0,0,10" Visibility="Collapsed"/>
                                <ListView Name="listUserGroups" Height="270" BorderBrush="#E5E5E5">
                                    <ListView.View>
                                        <GridView>
                                            <GridViewColumn Header="Group Name" DisplayMemberBinding="{Binding GroupName}" Width="700"/>
                                        </GridView>
                                    </ListView.View>
                                </ListView>
                                <TextBlock Name="lblGroupCount" Text="Total Groups: 0" Foreground="#666" Margin="0,10,0,0" FontStyle="Italic"/>
                            </StackPanel>
                        </Border>
                    </Border>
                </Grid>

                <Grid Grid.Row="3" Name="userAppsArea" Margin="25" Visibility="Collapsed">
                    <Grid.Resources>
                        <Style TargetType="Button">
                            <Setter Property="Height" Value="30"/>
                            <Setter Property="Margin" Value="2"/>
                            <Setter Property="FontSize" Value="11"/>
                            <Setter Property="FontWeight" Value="SemiBold"/>
                            <Setter Property="Background" Value="#F8F9FA"/>
                            <Setter Property="Foreground" Value="#495057"/>
                            <Setter Property="BorderBrush" Value="#DEE2E6"/>
                            <Setter Property="Cursor" Value="Hand"/>
                            <Style.Resources>
                                <Style TargetType="Border">
                                    <Setter Property="CornerRadius" Value="6"/>
                                </Style>
                            </Style.Resources>
                        </Style>
                    </Grid.Resources>

                    <ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
                        <WrapPanel>

                            <Border Width="230" Margin="0,0,20,20" Background="White" CornerRadius="12" VerticalAlignment="Top">
                                <Border.Effect><DropShadowEffect BlurRadius="10" Opacity="0.08" ShadowDepth="2"/></Border.Effect>
                                <StackPanel>
                                    <Border Name="brdTruxHeader" Background="#C6EFCE" CornerRadius="12,12,0,0" Padding="15,10">
                                        <Grid>
                                            <StackPanel>
                                                <TextBlock Name="txtTruxTitle" Text="Trux" FontWeight="Bold" FontSize="14" Foreground="#006100"/>
                                                <TextBlock Name="txtTruxVersion" Text="No Access" FontSize="10" Foreground="#006100"/>
                                            </StackPanel>
                                            <TextBlock Name="txtTruxStatusIcon" Text="&#xE73E;" FontFamily="Segoe MDL2 Assets" HorizontalAlignment="Right" VerticalAlignment="Center" Foreground="#006100" FontWeight="Bold"/>
                                        </Grid>
                                    </Border>
                                    <Border Padding="15">
                                        <StackPanel>
                                            <TextBlock Text="Groups:" FontSize="11" FontWeight="Bold" Foreground="#888" Margin="0,0,0,8"/>
                                            <ItemsControl Name="listTruxStatus" FontSize="11" Margin="0,0,0,10"/>
                                            <UniformGrid Columns="2">
                                                <Button Name="btnToggleTruxAWS" Content="Add AWS"/>
                                                <Button Name="btnToggleTruxMand" Content="Add Trux Group"/>
                                            </UniformGrid>
                                        </StackPanel>
                                    </Border>
                                </StackPanel>
                            </Border>

                            <Border Width="230" Margin="0,0,20,20" Background="White" CornerRadius="12" VerticalAlignment="Top">
                                <Border.Effect><DropShadowEffect BlurRadius="10" Opacity="0.08" ShadowDepth="2"/></Border.Effect>
                                <StackPanel>
                                    <Border Name="brdTowerHeader" Background="#C6EFCE" CornerRadius="12,12,0,0" Padding="15,10">
                                        <Grid>
                                            <StackPanel>
                                                <TextBlock Name="txtTowerTitle" Text="Tower" FontWeight="Bold" FontSize="14" Foreground="#006100"/>
                                                <TextBlock Name="txtTowerVersion" Text="V (FS1)" FontSize="10" Foreground="#006100"/>
                                            </StackPanel>
                                            <TextBlock Name="txtTowerStatusIcon" Text="&#xE73E;" FontFamily="Segoe MDL2 Assets" HorizontalAlignment="Right" VerticalAlignment="Center" Foreground="#006100" FontWeight="Bold"/>
                                        </Grid>
                                    </Border>
                                    <Border Padding="15">
                                        <StackPanel>
                                            <TextBlock Text="Groups:" FontSize="11" FontWeight="Bold" Foreground="#888" Margin="0,0,0,8"/>
                                            <ItemsControl Name="listTowerStatus" FontSize="11" Margin="0,0,0,10"/>
                                            <UniformGrid Columns="2">
                                                <Button Name="btnToggleTowerAWS" Content="Add AWS"/>
                                            </UniformGrid>
                                        </StackPanel>
                                    </Border>
                                </StackPanel>
                            </Border>

                            <Border Width="230" Margin="0,0,20,20" Background="White" CornerRadius="12" VerticalAlignment="Top">
                                <Border.Effect><DropShadowEffect BlurRadius="10" Opacity="0.08" ShadowDepth="2"/></Border.Effect>
                                <StackPanel>
                                    <Border Name="brdOMSHeader" Background="#FFC7CE" CornerRadius="12,12,0,0" Padding="15,10">
                                        <Grid>
                                            <StackPanel>
                                                <TextBlock Name="txtOMSTitle" Text="OMS" FontWeight="Bold" FontSize="14" Foreground="#9C0006"/>
                                                <TextBlock Name="txtOMSVersion" Text="No Access" FontSize="10" Foreground="#9C0006"/>
                                            </StackPanel>
                                            <TextBlock Name="txtOMSStatusIcon" Text="&#xE711;" FontFamily="Segoe MDL2 Assets" HorizontalAlignment="Right" VerticalAlignment="Center" Foreground="#9C0006" FontWeight="Bold"/>
                                        </Grid>
                                    </Border>
                                    <Border Padding="15">
                                        <StackPanel>
                                            <TextBlock Text="Groups:" FontSize="11" FontWeight="Bold" Foreground="#888" Margin="0,0,0,8"/>
                                            <ItemsControl Name="listOMSStatus" FontSize="11" Margin="0,0,0,10"/>
                                            <UniformGrid Columns="2">
                                                <Button Name="btnToggleOMSV30" Content="Add V30"/>
                                                <Button Name="btnToggleOMSV30DEV" Content="Add V30DEV"/>
                                            </UniformGrid>
                                        </StackPanel>
                                    </Border>
                                </StackPanel>
                            </Border>

                            <Border Width="230" Margin="0,0,20,20" Background="White" CornerRadius="12" VerticalAlignment="Top">
                                <Border.Effect><DropShadowEffect BlurRadius="10" Opacity="0.08" ShadowDepth="2"/></Border.Effect>
                                <StackPanel>
                                    <Border Name="brdM5Header" Background="#FFC7CE" CornerRadius="12,12,0,0" Padding="15,10">
                                        <Grid>
                                            <StackPanel>
                                                <TextBlock Name="txtM5Title" Text="M5" FontWeight="Bold" FontSize="14" Foreground="#9C0006"/>
                                                <TextBlock Name="txtM5Version" Text="No Access" FontSize="10" Foreground="#9C0006"/>
                                            </StackPanel>
                                            <TextBlock Name="txtM5StatusIcon" Text="&#xE711;" FontFamily="Segoe MDL2 Assets" HorizontalAlignment="Right" VerticalAlignment="Center" Foreground="#9C0006" FontWeight="Bold"/>
                                        </Grid>
                                    </Border>
                                    <Border Padding="15">
                                        <StackPanel>
                                            <TextBlock Text="Groups:" FontSize="11" FontWeight="Bold" Foreground="#888" Margin="0,0,0,8"/>
                                            <ItemsControl Name="listM5Status" FontSize="11" Margin="0,0,0,10"/>
                                            <UniformGrid Columns="2">
                                                <Button Name="btnToggleM5US" Content="Add US"/>
                                                <Button Name="btnToggleM5CA" Content="Add CA"/>
                                            </UniformGrid>
                                        </StackPanel>
                                    </Border>
                                </StackPanel>
                            </Border>

                            <Border Width="230" Margin="0,0,20,20" Background="White" CornerRadius="12" VerticalAlignment="Top">
                                <Border.Effect><DropShadowEffect BlurRadius="10" Opacity="0.08" ShadowDepth="2"/></Border.Effect>
                                <StackPanel>
                                    <Border Name="brdCieHeader" Background="#FFC7CE" CornerRadius="12,12,0,0" Padding="15,10">
                                        <Grid>
                                            <StackPanel>
                                                <TextBlock Name="txtCieTitle" Text="CieTrade" FontWeight="Bold" FontSize="14" Foreground="#9C0006"/>
                                                <TextBlock Name="txtCieVersion" Text="No Access" FontSize="10" Foreground="#9C0006"/>
                                            </StackPanel>
                                            <TextBlock Name="txtCieStatusIcon" Text="&#xE711;" FontFamily="Segoe MDL2 Assets" HorizontalAlignment="Right" VerticalAlignment="Center" Foreground="#9C0006" FontWeight="Bold"/>
                                        </Grid>
                                    </Border>
                                    <Border Padding="15">
                                        <StackPanel>
                                            <TextBlock Text="Groups:" FontSize="11" FontWeight="Bold" Foreground="#888" Margin="0,0,0,8"/>
                                            <ItemsControl Name="listCieStatus" FontSize="11" Margin="0,0,0,10"/>
                                            <UniformGrid Columns="2">
                                                <Button Name="btnToggleCieAWS" Content="Add AWS"/>
                                                <Button Name="btnToggleCieScale1" Content="Add Scale 1"/>
                                                <Button Name="btnToggleCieScale2" Content="Add Scale 2"/>
                                            </UniformGrid>
                                        </StackPanel>
                                    </Border>
                                </StackPanel>
                            </Border>

                            <Border Width="230" Margin="0,0,20,20" Background="White" CornerRadius="12" VerticalAlignment="Top">
                                <Border.Effect><DropShadowEffect BlurRadius="10" Opacity="0.08" ShadowDepth="2"/></Border.Effect>
                                <StackPanel>
                                    <Border Name="brdPCScaleHeader" Background="#FFC7CE" CornerRadius="12,12,0,0" Padding="15,10">
                                        <Grid>
                                            <StackPanel>
                                                <TextBlock Name="txtPCScaleTitle" Text="PC Scale" FontWeight="Bold" FontSize="14" Foreground="#9C0006"/>
                                                <TextBlock Name="txtPCScaleVersion" Text="No Access" FontSize="10" Foreground="#9C0006"/>
                                            </StackPanel>
                                            <TextBlock Name="txtPCScaleStatusIcon" Text="&#xE711;" FontFamily="Segoe MDL2 Assets" HorizontalAlignment="Right" VerticalAlignment="Center" Foreground="#9C0006" FontWeight="Bold"/>
                                        </Grid>
                                    </Border>
                                    <Border Padding="15">
                                        <StackPanel>
                                            <TextBlock Text="Groups:" FontSize="11" FontWeight="Bold" Foreground="#888" Margin="0,0,0,8"/>
                                            <ItemsControl Name="listPCScaleStatus" FontSize="11" Margin="0,0,0,10"/>
                                            <UniformGrid Columns="2">
                                                <Button Name="btnTogglePCScaleAWS" Content="Add AWS"/>
                                            </UniformGrid>
                                        </StackPanel>
                                    </Border>
                                </StackPanel>
                            </Border>

                            <Border Width="230" Margin="0,0,20,20" Background="White" CornerRadius="12" VerticalAlignment="Top">
                                <Border.Effect><DropShadowEffect BlurRadius="10" Opacity="0.08" ShadowDepth="2"/></Border.Effect>
                                <StackPanel>
                                    <Border Name="brdCognosHeader" Background="#FFC7CE" CornerRadius="12,12,0,0" Padding="15,10">
                                        <Grid>
                                            <StackPanel>
                                                <TextBlock Name="txtCognosTitle" Text="Cognos" FontWeight="Bold" FontSize="14" Foreground="#9C0006"/>
                                                <TextBlock Name="txtCognosVersion" Text="No Access" FontSize="10" Foreground="#9C0006"/>
                                            </StackPanel>
                                            <TextBlock Name="txtCognosStatusIcon" Text="&#xE711;" FontFamily="Segoe MDL2 Assets" HorizontalAlignment="Right" VerticalAlignment="Center" Foreground="#9C0006" FontWeight="Bold"/>
                                        </Grid>
                                    </Border>
                                    <Border Padding="15">
                                        <StackPanel>
                                            <TextBlock Text="Groups:" FontSize="11" FontWeight="Bold" Foreground="#888" Margin="0,0,0,8"/>
                                            <ItemsControl Name="listCognosStatus" FontSize="11" Margin="0,0,0,10"/>
                                            <UniformGrid Columns="2">
                                                <Button Name="btnToggleCognosCTX" Content="Add CTX"/>
                                                <Button Name="btnToggleCognosZscaler" Content="Add ZPA"/>
                                            </UniformGrid>
                                        </StackPanel>
                                    </Border>
                                </StackPanel>
                            </Border>

                        </WrapPanel>
                    </ScrollViewer>
                </Grid>

                <Grid Grid.Row="3" Name="multipleResultsArea" Margin="25" Visibility="Collapsed">
                    <Border Background="White" CornerRadius="12" VerticalAlignment="Top" HorizontalAlignment="Left" Width="650">
                        <Border.Effect><DropShadowEffect BlurRadius="15" Opacity="0.1" ShadowDepth="4"/></Border.Effect>
                        <Border Padding="20">
                            <StackPanel>
                                <TextBlock Text="Multiple Users Found" FontSize="18" FontWeight="Bold" Margin="0,0,0,5"/>
                                <TextBlock Text="Please select the correct user from the list below by double-clicking:" Foreground="#666" Margin="0,0,0,15"/>

                                <ListView Name="listUserResults" Height="250" BorderBrush="#E5E5E5">
                                    <ListView.ItemContainerStyle>
                                        <Style TargetType="ListViewItem">
                                            <Setter Property="Foreground" Value="{Binding Color}"/>
                                        </Style>
                                    </ListView.ItemContainerStyle>
                                    <ListView.View>
                                        <GridView>
                                            <GridViewColumn Header="Display Name" DisplayMemberBinding="{Binding DisplayName}" Width="150"/>
                                            <GridViewColumn Header="Username" DisplayMemberBinding="{Binding SamAccountName}" Width="100"/>
                                            <GridViewColumn Header="Email" DisplayMemberBinding="{Binding EmailAddress}" Width="200"/>
                                            <GridViewColumn Header="Manager" DisplayMemberBinding="{Binding Manager}" Width="150"/>
                                        </GridView>
                                    </ListView.View>
                                </ListView>

                            </StackPanel>
                        </Border>
                    </Border>
                </Grid>
            </Grid>

            <Grid Name="screenPrinterCard" Visibility="Collapsed">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/> <RowDefinition Height="80"/>   <RowDefinition Height="*"/>    </Grid.RowDefinitions>
    
                <StackPanel Grid.Row="0" Margin="25,15,0,15">
                    <TextBlock Text="Printer Card Search" FontSize="24" FontWeight="Bold" Foreground="#2D2D30" FontFamily="Segoe UI"/>
                    <TextBlock Text="Verify if a card number is currently assigned to an user." FontSize="13" Foreground="#666"/>
                </StackPanel>

                <Border Grid.Row="1" Background="White" BorderBrush="#E5E5E5" BorderThickness="0,0,0,1">
                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center" Margin="20,0">
                        <Border CornerRadius="15" Background="#F1F1F1" Width="300" Height="35" Padding="10,0">
                            <TextBox Name="printerCardSearch" BorderThickness="0" Background="Transparent" VerticalContentAlignment="Center" Text="Search Printer Card..." Foreground="Gray"/>
                        </Border>
                        <Button Name="btnSearchPrinterCard" Content="Search" Margin="10,0" Width="100" Height="35" Background="#007ACC" Foreground="White">
                            <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="5"/></Style></Button.Resources>
                        </Button>
                        <TextBlock Name="lblPrinterCardError" Text="Printer Card not found!" TextWrapping="Wrap" MaxWidth="400" Foreground="#D13438" FontSize="12" FontWeight="SemiBold" Margin="25,0,0,0" Visibility="Collapsed" VerticalAlignment="Center"/>
                    </StackPanel>
                </Border>

                <Grid Grid.Row="2" Margin="30">
                    <StackPanel Name="printerResultCard" Visibility="Collapsed">
                        <Border Width="450" HorizontalAlignment="Left" Background="White" CornerRadius="12">
                            <Border.Effect><DropShadowEffect BlurRadius="15" Opacity="0.1" ShadowDepth="4"/></Border.Effect>
                            <Border Padding="25">
                                <StackPanel>
                                    <TextBlock Text="1 user found" FontSize="18" FontWeight="Bold" Margin="0,0,0,15"/>
                                    <Separator Background="#EEE" Margin="0,0,0,20"/>
                    
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="Auto"/>
                                            <ColumnDefinition Width="*"/>
                                        </Grid.ColumnDefinitions>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="Auto"/> 
                                            <RowDefinition Height="10"/> <RowDefinition Height="Auto"/> 
                                            <RowDefinition Height="10"/> <RowDefinition Height="Auto"/> 
                                            <RowDefinition Height="10"/> <RowDefinition Height="Auto"/> 
                                        </Grid.RowDefinitions>

                                        <TextBlock Grid.Row="0" Text="Assigned To:" Foreground="#888" VerticalAlignment="Center"/>
                                        <TextBlock Grid.Row="0" Grid.Column="1" Name="lblPrinterOwnerName" Text="N/A" FontWeight="Bold" FontSize="16" HorizontalAlignment="Right"/>

                                        <TextBlock Grid.Row="2" Text="Username:" Foreground="#888" VerticalAlignment="Center"/>
                                        <TextBlock Grid.Row="2" Grid.Column="1" Name="lblPrinterOwnerSam" Text="N/A" HorizontalAlignment="Right"/>

                                        <TextBlock Grid.Row="4" Text="Extension Attr 2:" Foreground="#888" VerticalAlignment="Center"/>
                                        <TextBlock Grid.Row="4" Grid.Column="1" Name="lblPrinterOwnerAttr2" Text="N/A" HorizontalAlignment="Right"/>

                                        <TextBlock Grid.Row="6" Text="Extension Attr 3:" Foreground="#888" VerticalAlignment="Center"/>
                                        <TextBlock Grid.Row="6" Grid.Column="1" Name="lblPrinterOwnerAttr3" Text="N/A" HorizontalAlignment="Right"/>
                                    </Grid>
                    
                                    <Button Name="btnGoToUserProfile" Content="Open User Profile" Margin="0,20,0,0" Height="30" Background="#F1F1F1"/>
                                </StackPanel>
                            </Border>
                        </Border>
                    </StackPanel>

                    <StackPanel Name="printerMultipleArea" Visibility="Collapsed">
                        <TextBlock Text="Multiple users found" FontSize="18" FontWeight="Bold" Margin="0,0,0,15"/>
                        <ListView Name="listPrinterResults" Height="200" BorderBrush="#E5E5E5">
                            <ListView.View>
                                <GridView>
                                    <GridViewColumn Header="Name" DisplayMemberBinding="{Binding DisplayName}" Width="200"/>
                                    <GridViewColumn Header="Username" DisplayMemberBinding="{Binding SamAccountName}" Width="150"/>
                                    <GridViewColumn Header="Extension Attr 2" DisplayMemberBinding="{Binding extensionAttribute2}" Width="150"/>
                                    <GridViewColumn Header="Extension Attr 3" DisplayMemberBinding="{Binding extensionAttribute3}" Width="150"/>
                                </GridView>
                            </ListView.View>
                        </ListView>
                    </StackPanel>
                </Grid>
            </Grid>

            <Grid Name="screenEmployeeID" Visibility="Collapsed">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/> <RowDefinition Height="80"/>   <RowDefinition Height="*"/>    </Grid.RowDefinitions>
    
                <StackPanel Grid.Row="0" Margin="25,15,0,15">
                    <TextBlock Text="Employee ID Search" FontSize="24" FontWeight="Bold" Foreground="#2D2D30" FontFamily="Segoe UI"/>
                    <TextBlock Text="Search users by Employee ID." FontSize="13" Foreground="#666"/>
                </StackPanel>

                <Border Grid.Row="1" Background="White" BorderBrush="#E5E5E5" BorderThickness="0,0,0,1">
                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center" Margin="20,0">
                        <Border CornerRadius="15" Background="#F1F1F1" Width="300" Height="35" Padding="10,0">
                            <TextBox Name="employeeIDSearch" BorderThickness="0" Background="Transparent" VerticalContentAlignment="Center" Text="Search Employee ID..." Foreground="Gray"/>
                        </Border>
                        <Button Name="btnSearchEmployeeID" Content="Search" Margin="10,0" Width="100" Height="35" Background="#007ACC" Foreground="White">
                            <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="5"/></Style></Button.Resources>
                        </Button>
                        <TextBlock Name="lblEmployeeIDError" Text="Employee ID not found!" TextWrapping="Wrap" MaxWidth="400" Foreground="#D13438" FontSize="12" FontWeight="SemiBold" Margin="25,0,0,0" Visibility="Collapsed" VerticalAlignment="Center"/>
                    </StackPanel>
                </Border>

                <Grid Grid.Row="2" Margin="30">
                    <StackPanel Name="employeeIDResultCard" Visibility="Collapsed">
                        <Border Width="450" HorizontalAlignment="Left" Background="White" CornerRadius="12">
                            <Border.Effect><DropShadowEffect BlurRadius="15" Opacity="0.1" ShadowDepth="4"/></Border.Effect>
                            <Border Padding="25">
                                <StackPanel>
                                    <TextBlock Text="1 user found" FontSize="18" FontWeight="Bold" Margin="0,0,0,15"/>
                                    <Separator Background="#EEE" Margin="0,0,0,20"/>
                    
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="Auto"/>
                                            <ColumnDefinition Width="*"/>
                                        </Grid.ColumnDefinitions>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="Auto"/> 
                                            <RowDefinition Height="10"/> <RowDefinition Height="Auto"/> 
                                            <RowDefinition Height="10"/> <RowDefinition Height="Auto"/> 
                                            <RowDefinition Height="10"/> <RowDefinition Height="Auto"/> 
                                        </Grid.RowDefinitions>

                                        <TextBlock Grid.Row="0" Text="Display Name:" Foreground="#888" VerticalAlignment="Center"/>
                                        <TextBlock Grid.Row="0" Grid.Column="1" Name="lblEmployeeName" Text="N/A" FontWeight="Bold" FontSize="16" HorizontalAlignment="Right"/>

                                        <TextBlock Grid.Row="2" Text="Username:" Foreground="#888" VerticalAlignment="Center"/>
                                        <TextBlock Grid.Row="2" Grid.Column="1" Name="lblEmployeeSam" Text="N/A" HorizontalAlignment="Right"/>

                                        <TextBlock Grid.Row="4" Text="Employee ID:" Foreground="#888" VerticalAlignment="Center"/>
                                        <TextBlock Grid.Row="4" Grid.Column="1" Name="lblEmployeeNumber" Text="N/A" HorizontalAlignment="Right"/>
                                    </Grid>
                    
                                    <Button Name="btnGoToEmployeeProfile" Content="Open User Profile" Margin="0,20,0,0" Height="30" Background="#F1F1F1"/>
                                </StackPanel>
                            </Border>
                        </Border>
                    </StackPanel>

                    <StackPanel Name="employeeMultipleArea" Visibility="Collapsed">
                        <TextBlock Text="Multiple users found" FontSize="18" FontWeight="Bold" Margin="0,0,0,15"/>
                        <ListView Name="listemployeeResults" Height="200" BorderBrush="#E5E5E5">
                            <ListView.View>
                                <GridView>
                                    <GridViewColumn Header="Name" DisplayMemberBinding="{Binding DisplayName}" Width="200"/>
                                    <GridViewColumn Header="Username" DisplayMemberBinding="{Binding SamAccountName}" Width="150"/>
                                    <GridViewColumn Header="Employee ID" DisplayMemberBinding="{Binding EmployeeNumber}" Width="150"/>
                                </GridView>
                            </ListView.View>
                        </ListView>
                    </StackPanel>
                </Grid>
            </Grid>

            <Grid Name="screenPaths" Visibility="Collapsed">
                <Grid.Resources>
                    <Style x:Key="PathCard" TargetType="Border">
                        <Setter Property="Width" Value="230"/>
                        <Setter Property="Margin" Value="0,0,20,20"/>
                        <Setter Property="Background" Value="White"/>
                        <Setter Property="CornerRadius" Value="12"/>
                        <Setter Property="Effect">
                            <Setter.Value>
                                <DropShadowEffect BlurRadius="10" Opacity="0.08" ShadowDepth="2"/>
                            </Setter.Value>
                        </Setter>
                    </Style>
                    <Style TargetType="Button">
                        <Setter Property="Height" Value="30"/>
                        <Setter Property="Background" Value="#F8F9FA"/>
                        <Setter Property="Cursor" Value="Hand"/>
                        <Style.Resources>
                            <Style TargetType="Border">
                                <Setter Property="CornerRadius" Value="6"/>
                            </Style>
                        </Style.Resources>
                    </Style>
                </Grid.Resources>

                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
    
                <StackPanel Grid.Row="0" Margin="25,15,0,35">
                    <TextBlock Text="Network Paths" FontSize="24" FontWeight="Bold" Foreground="#2D2D30"/>
                    <TextBlock Text="Quick access to GFL network locations." FontSize="13" Foreground="#666"/>
                </StackPanel>

                <ScrollViewer Grid.Row="1" Margin="25,0,0,0" VerticalScrollBarVisibility="Auto">
                    <WrapPanel Name="panelPathCards">
            
                        <Border Style="{StaticResource PathCard}">
                            <StackPanel>
                                <Border Background="#007ACC" CornerRadius="12,12,0,0" Padding="15,10">
                                    <TextBlock Text="S Drive" FontWeight="Bold" Foreground="White"/>
                                </Border>
                                <Border Padding="15">
                                    <StackPanel>
                                        <TextBox Text="\\gfl.local\dfs" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontSize="11" Foreground="#444" TextWrapping="Wrap" Height="40"/>
                                        <Button Name="btnOpenSDrive" Content="Open in Explorer" Tag="\\gfl.local\dfs"/>
                                    </StackPanel>
                                </Border>
                            </StackPanel>
                        </Border>

                        <Border Style="{StaticResource PathCard}">
                            <StackPanel>
                                <Border Background="#28A745" CornerRadius="12,12,0,0" Padding="15,10">
                                    <TextBlock Text="K Drive" FontWeight="Bold" Foreground="White"/>
                                </Border>
                                <Border Padding="15">
                                    <StackPanel>
                                        <TextBox Text="\\gfl.local\dfs\GFL US SE" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontSize="11" Foreground="#444" TextWrapping="Wrap" Height="40"/>
                                        <Button Name="btnOpenKDrive" Content="Open in Explorer" Tag="\\gfl.local\dfs\GFL US SE"/>
                                    </StackPanel>
                                </Border>
                            </StackPanel>
                        </Border>

                        <Border Style="{StaticResource PathCard}">
                            <StackPanel>
                                <Border Background="#6F42C1" CornerRadius="12,12,0,0" Padding="15,10">
                                    <TextBlock Text="Z Drive" FontWeight="Bold" Foreground="White"/>
                                </Border>
                                <Border Padding="15">
                                    <StackPanel>
                                        <TextBox Text="\\gflfs4\dfs" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontSize="11" Foreground="#444" TextWrapping="Wrap" Height="40"/>
                                        <Button Name="btnOpenZDrive" Content="Open in Explorer" Tag="\\gflfs4\dfs"/>
                                    </StackPanel>
                                </Border>
                            </StackPanel>
                        </Border>

                        <Border Style="{StaticResource PathCard}">
                            <StackPanel>
                                <Border Background="#2ECC71" CornerRadius="12,12,0,0" Padding="15,10">
                                    <TextBlock Text="AWS Profiles" FontWeight="Bold" Foreground="White"/>
                                </Border>
                                <Border Padding="15">
                                    <StackPanel>
                                        <TextBox Text="\\amznfsxnuwpdkp5.gfl.local\share\userprofiles" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontSize="11" Foreground="#444" TextWrapping="Wrap" Height="40"/>
                                        <Button Name="btnOpenAWS" Content="Open in Explorer" Tag="\\amznfsxnuwpdkp5.gfl.local\share\userprofiles"/>
                                    </StackPanel>
                                </Border>
                            </StackPanel>
                        </Border>

                        <Border Style="{StaticResource PathCard}">
                            <StackPanel>
                                <Border Background="#D35400" CornerRadius="12,12,0,0" Padding="15,10">
                                    <TextBlock Text="FollowYou Installation" FontWeight="Bold" Foreground="White"/>
                                </Border>
                                <Border Padding="15">
                                    <StackPanel>
                                        <TextBox Text="\\gfl.local\netlogon\lrs" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontSize="11" Foreground="#444" TextWrapping="Wrap" Height="40"/>
                                        <Button Name="btnOpenLRS" Content="Open in Explorer" Tag="\\gfl.local\netlogon\lrs"/>
                                    </StackPanel>
                                </Border>
                            </StackPanel>
                        </Border>

                        <Border Style="{StaticResource PathCard}">
                            <StackPanel>
                                <Border Background="#17A2B8" CornerRadius="12,12,0,0" Padding="15,10">
                                    <TextBlock Text="PAfE" FontWeight="Bold" Foreground="White"/>
                                </Border>
                                <Border Padding="15">
                                    <StackPanel>
                                        <TextBox Text="\\gfl.local\dfs\AppData\SFTP\GFL Cognos\PAFE" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontSize="11" Foreground="#444" TextWrapping="Wrap" Height="40"/>
                                        <Button Name="btnOpenPAFE" Content="Open in Explorer" Tag="\\gfl.local\dfs\AppData\SFTP\GFL Cognos\PAFE"/>
                                    </StackPanel>
                                </Border>
                            </StackPanel>
                        </Border>

                        <Border Style="{StaticResource PathCard}">
                            <StackPanel>
                                <Border Background="#C0392B" CornerRadius="12,12,0,0" Padding="15,10">
                                    <TextBlock Text="Fix GFL Wallpaper" FontWeight="Bold" Foreground="White"/>
                                </Border>
                                <Border Padding="15">
                                    <StackPanel>
                                        <TextBox Text="\\gfl.local\netlogon\BGInfo" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontSize="11" Foreground="#444" TextWrapping="Wrap" Height="40"/>
                                        <Button Name="btnOpenWallpaper" Content="Open in Explorer" Tag="\\gfl.local\netlogon\BGInfo"/>
                                    </StackPanel>
                                </Border>
                            </StackPanel>
                        </Border>

                    </WrapPanel>
                </ScrollViewer>
            </Grid>

            <Grid Name="screenTier2" Visibility="Collapsed">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/> <RowDefinition Height="80"/>   <RowDefinition Height="*"/>    </Grid.RowDefinitions>

                <StackPanel Grid.Row="0" Margin="25,15,0,15">
                    <TextBlock Text="Time Zones / Tier 2" FontSize="24" FontWeight="Bold" Foreground="#2D2D30" FontFamily="Segoe UI"/>
                    <TextBlock Text="Find the Tier 2 team for a US state or CA province and compare local time with Portugal." FontSize="13" Foreground="#666"/>
                </StackPanel>

                <Border Grid.Row="1" Background="White" BorderBrush="#E5E5E5" BorderThickness="0,0,0,1">
                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center" Margin="20,0">
                        <StackPanel Margin="0,0,20,0">
                            <TextBlock Text="Reference Region" Foreground="#888" FontSize="11" Margin="0,0,0,3"/>
                            <ComboBox Name="cbT2Origin" Width="170" Height="30" VerticalContentAlignment="Center"/>
                        </StackPanel>
                        <StackPanel Margin="0,0,20,0">
                            <TextBlock Text="Country" Foreground="#888" FontSize="11" Margin="0,0,0,3"/>
                            <ComboBox Name="cbT2Country" Width="150" Height="30" VerticalContentAlignment="Center"/>
                        </StackPanel>
                        <StackPanel Margin="0,0,20,0">
                            <TextBlock Text="State / Province" Foreground="#888" FontSize="11" Margin="0,0,0,3"/>
                            <ComboBox Name="cbT2State" Width="200" Height="30" VerticalContentAlignment="Center" IsEnabled="False"/>
                        </StackPanel>
                        <Button Name="btnT2Clear" Content="Clear" Margin="0,14,0,0" Width="80" Height="30" Background="#F1F1F1"/>
                    </StackPanel>
                </Border>

                <StackPanel Grid.Row="2" Margin="30">
                    <Border Width="520" HorizontalAlignment="Left" Background="White" CornerRadius="12">
                        <Border.Effect><DropShadowEffect BlurRadius="15" Opacity="0.1" ShadowDepth="4"/></Border.Effect>
                        <Border Padding="25">
                            <StackPanel>
                                <TextBlock Text="Escalate to" Foreground="#888" FontSize="11" Margin="0,0,0,2"/>
                                <TextBox Name="txtT2Group" Text="-" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontSize="17" FontWeight="Bold" TextWrapping="Wrap"/>
                                <Separator Background="#EEE" Margin="0,15,0,15"/>

                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="Auto"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <Grid.RowDefinitions>
                                        <RowDefinition Height="Auto"/>
                                        <RowDefinition Height="10"/> <RowDefinition Height="Auto"/>
                                        <RowDefinition Height="10"/> <RowDefinition Height="Auto"/>
                                    </Grid.RowDefinitions>

                                    <TextBlock Grid.Row="0" Text="Time Difference:" Foreground="#888" VerticalAlignment="Center"/>
                                    <TextBox Grid.Row="0" Grid.Column="1" Name="txtT2Diff" Text="-" IsReadOnly="True" BorderThickness="0" Background="Transparent" FontWeight="SemiBold" HorizontalContentAlignment="Right"/>

                                    <TextBlock Grid.Row="2" Text="Timezone:" Foreground="#888" VerticalAlignment="Center"/>
                                    <TextBox Grid.Row="2" Grid.Column="1" Name="txtT2Zone" Text="-" IsReadOnly="True" BorderThickness="0" Background="Transparent" HorizontalContentAlignment="Right"/>

                                    <TextBlock Grid.Row="4" Text="Current Time There:" Foreground="#888" VerticalAlignment="Center"/>
                                    <TextBox Grid.Row="4" Grid.Column="1" Name="txtT2Now" Text="-" IsReadOnly="True" BorderThickness="0" Background="Transparent" HorizontalContentAlignment="Right"/>
                                </Grid>
                            </StackPanel>
                        </Border>
                    </Border>

                    <Border Width="520" HorizontalAlignment="Left" Background="White" CornerRadius="12" Margin="0,20,0,0">
                        <Border.Effect><DropShadowEffect BlurRadius="15" Opacity="0.1" ShadowDepth="4"/></Border.Effect>
                        <Border Padding="25">
                            <StackPanel>
                                <TextBlock Text="Synchronized Clocks" FontSize="16" FontWeight="Bold" Margin="0,0,0,2"/>
                                <TextBlock Text="Type a time (HH:mm) in either box and the other one updates." Foreground="#888" FontSize="11" Margin="0,0,0,15"/>

                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="50"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>

                                    <StackPanel Grid.Column="0">
                                        <TextBlock Name="lblT2StateClock" Text="State Time" Foreground="#888" FontSize="11" Margin="0,0,0,3"/>
                                        <TextBox Name="txtT2StateTime" Height="40" MaxLength="5" FontSize="22" FontFamily="Consolas" FontWeight="Bold" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" IsEnabled="False"/>
                                    </StackPanel>

                                    <TextBlock Grid.Column="1" FontFamily="Segoe MDL2 Assets" Text="&#xE8AB;" FontSize="18" Foreground="#888" HorizontalAlignment="Center" VerticalAlignment="Bottom" Margin="0,0,0,10"/>

                                    <StackPanel Grid.Column="2">
                                        <TextBlock Name="lblT2OriginClock" Text="Porto Time" Foreground="#888" FontSize="11" Margin="0,0,0,3"/>
                                        <TextBox Name="txtT2OriginTime" Height="40" MaxLength="5" FontSize="22" FontFamily="Consolas" FontWeight="Bold" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" IsEnabled="False"/>
                                    </StackPanel>
                                </Grid>

                                <Button Name="btnT2Sync" Content="Reset to Current Time" Margin="0,20,0,0" Height="30" Background="#F1F1F1" IsEnabled="False"/>
                            </StackPanel>
                        </Border>
                    </Border>
                </StackPanel>
            </Grid>
        </Grid>
    </Grid>
</Window>
"@


### UI/SCREENS LOGIC ###

try {
    [xml]$xaml = $inputXML
    $reader = New-Object System.Xml.XmlNodeReader $xaml
    $window = [Windows.Markup.XamlReader]::Load($reader)
} catch {
    throw "XAML Load Failed: $($_.Exception.Message)"
}

$xaml.SelectNodes("//*[@*[local-name()='Name']]") | ForEach-Object {
    $name = $_.GetAttribute("Name")
    $var = $window.FindName($name)
    Set-Variable -Name $name -Value $var -Scope Script
}

$txtVersion.Text = "Version Date: $($script:AppVersionDate)"

$global:CurrentDC = $null
$global:MyCred = $null

while ($null -eq $global:MyCred) {
    try {
        $cred = $null
        $cred = Get-Credential -Message "Enter your GFL HD Credentials" -ErrorAction Stop
        
        if ($null -eq $cred -or [string]::IsNullOrEmpty($cred.UserName)) {
            if ($window) { $window.Close() }
            Exit
        }
        
        $netCred = $cred.GetNetworkCredential()
        $un = $netCred.UserName
        $dom = $netCred.Domain
        if ([string]::IsNullOrEmpty($dom) -or $dom -eq "gflenv.com") { 
            $dom = "gfl.local" 
        }
        $cleanUser = "$dom\$un"
        $sanitizedCred = New-Object System.Management.Automation.PSCredential($cleanUser, $cred.Password)

        $null = Get-ADUser -Identity $un -Server "gfl.local" -Credential $sanitizedCred -ErrorAction Stop
        
        $global:MyCred = $sanitizedCred
        Write-Host "Credentials verified successfully for $cleanUser!" -ForegroundColor Green

    } catch {
        $isCancelAction = $false
        $currentException = $_.Exception
        
        while ($null -ne $currentException) {
            if ($currentException.GetType().Name -eq "PipelineStoppedException" -or $currentException.Message -match "PipelineStopped") {
                $isCancelAction = $true
                break
            }
            $currentException = $currentException.InnerException
        }

        if ($isCancelAction) {
            [System.Windows.MessageBox]::Show("Script execution cancelled by user.", "Exit")
            if ($window) { $window.Close() }
            Exit
        }

        $errMsg = $_.Exception.Message

        if (-not (Get-Command Get-ADUser -ErrorAction SilentlyContinue)) {
            [System.Windows.MessageBox]::Show(
                "The Active Directory PowerShell module is not installed on this computer.`n`nInstall 'RSAT: Active Directory Domain Services and Lightweight Directory Services Tools' and run the tool again.",
                "Missing Module",
                [System.Windows.MessageBoxButton]::OK,
                [System.Windows.MessageBoxImage]::Error
            )
            if ($window) { $window.Close() }
            Exit
        }

        $isBadLogin = ($_.Exception -is [System.Security.Authentication.AuthenticationException]) -or
                      ($errMsg -match "rejected the client credentials|user name or password is incorrect|unknown user name or bad password|logon failure|invalid credentials")

        if ($isBadLogin) {
            [System.Windows.MessageBox]::Show(
                "Authentication Failed!`n`nThe username or password you entered is incorrect.`n`nPlease try again.", 
                "Login Error", 
                [System.Windows.MessageBoxButton]::OK, 
                [System.Windows.MessageBoxImage]::Error
            )
        } else {
            $retry = [System.Windows.MessageBox]::Show(
                "Could not verify your credentials:`n`n$errMsg`n`nCheck that you are connected to the GFL network (or VPN).`n`nTry again?",
                "Login Error",
                [System.Windows.MessageBoxButton]::YesNo,
                [System.Windows.MessageBoxImage]::Warning
            )
            if ($retry -ne "Yes") {
                if ($window) { $window.Close() }
                Exit
            }
        }
    }
}

try {
    $global:CurrentDC = (Get-ADDomainController -ErrorAction Stop).HostName
} catch {
    $global:CurrentDC = "gfl.local"
}

### BACKGROUND WORK ###

$bgSession = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
$bgSession.ImportPSModule(@("ActiveDirectory"))
$global:BgPool = [runspacefactory]::CreateRunspacePool(1, 4, $bgSession, $Host)
$global:BgPool.Open()

$global:BgJobs   = New-Object System.Collections.ArrayList
$global:BgLatest = @{}

$global:BgTimer = New-Object System.Windows.Threading.DispatcherTimer
$global:BgTimer.Interval = [TimeSpan]::FromMilliseconds(100)
$global:BgTimer.Add_Tick({ bg_tick })

function start_bg ($channel, [scriptblock]$work, [object[]]$argList, [scriptblock]$onDone, $state) {
    $id = [guid]::NewGuid().ToString()
    $global:BgLatest[$channel] = $id

    $wrapper = @"
try {
    `$data = & { $($work.ToString()) } @args
    [pscustomobject]@{ Ok = `$true; Data = `$data; Error = `$null; ErrorType = `$null }
} catch {
    [pscustomobject]@{ Ok = `$false; Data = `$null; Error = `$_.Exception.Message; ErrorType = `$_.Exception.GetType().Name }
}
"@

    $ps = [PowerShell]::Create()
    $ps.RunspacePool = $global:BgPool
    $null = $ps.AddScript($wrapper)
    foreach ($a in $argList) { $null = $ps.AddArgument($a) }

    $null = $global:BgJobs.Add(@{
        PS = $ps; Handle = $ps.BeginInvoke(); Channel = $channel; Id = $id; OnDone = $onDone; State = $state
    })
    $global:BgTimer.Start()
}

function bg_tick {
    $done = @($global:BgJobs | Where-Object { $_.Handle.IsCompleted })

    foreach ($job in $done) {
        $global:BgJobs.Remove($job)
        $result  = $null
        $failMsg = "The background task returned no result."
        try {
            $out = $job.PS.EndInvoke($job.Handle)
            if ($out.Count -gt 0) { $result = $out[$out.Count - 1] }
        } catch {
            $failMsg = $_.Exception.Message
        }
        $job.PS.Dispose()

        if (-not $result) {
            $result = [pscustomobject]@{ Ok = $false; Data = $null; Error = $failMsg; ErrorType = $null }
        }

        if ($global:BgLatest[$job.Channel] -eq $job.Id) {
            try {
                & $job.OnDone $result $job.State
            } catch {
                Write-Host "UI update error ($($job.Channel)): $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }

    if ($global:BgJobs.Count -eq 0) { $global:BgTimer.Stop() }
}

$global:BusyText = @{}
function set_busy ($button, [bool]$busy, $text = "Searching...") {
    if ($busy) {
        if (-not $global:BusyText.ContainsKey($button.Name)) { $global:BusyText[$button.Name] = $button.Content }
        $button.Content   = $text
        $button.IsEnabled = $false
    } elseif ($global:BusyText.ContainsKey($button.Name)) {
        $button.Content   = $global:BusyText[$button.Name]
        $button.IsEnabled = $true
        $global:BusyText.Remove($button.Name)
    }
}

function log_error ($section, $target, $message) {
    Write-Host "--- $section ERROR ---" -ForegroundColor Red
    Write-Host "Target: $target" -ForegroundColor Yellow
    Write-Host "Error Message: $message" -ForegroundColor White
    Write-Host "-----------------------" -ForegroundColor Red
}

function show_search_error ($label, $text) {
    $label.Text       = $text
    $label.ToolTip    = $text
    $label.Visibility = "Visible"
}

function group_name_from_dn ($dn) {
    if ($dn -match '^CN=(?<name>(?:[^\\,]|\\.)+),') { return ($Matches.name -replace '\\', '') }
    return $null
}

function show_screen ($screenName, $activeButton) {
    $screenLaps.Visibility = if ($screenName -eq "screenLaps") { "Visible" } else { "Collapsed" }
    $screenUserInfo.Visibility = if ($screenName -eq "screenUserInfo") { "Visible" } else { "Collapsed" }
    $screenPrinterCard.Visibility = if ($screenName -eq "screenPrinterCard") { "Visible" } else { "Collapsed" }
    $screenEmployeeID.Visibility = if ($screenName -eq "screenEmployeeID") { "Visible" } else { "Collapsed" }
    $screenPaths.Visibility = if ($screenName -eq "screenPaths") { "Visible" } else { "Collapsed" }
    $screenTier2.Visibility = if ($screenName -eq "screenTier2") { "Visible" } else { "Collapsed" }
    
    $allNavButtons = @($btnLaps, $btnUserInfo, $btnPrinterCard, $btnEmployeeID, $btnPaths, $btnTier2)

    foreach ($btn in $allNavButtons) {
        $btn.Background = if ($btn.Name -eq $activeButton.Name) { [System.Windows.Media.Brushes]::DimGray } else { [System.Windows.Media.Brushes]::Transparent }
    }
}

$btnLaps.Add_Click({ show_screen "screenLaps" $btnLaps })
$btnUserInfo.Add_Click({ show_screen "screenUserInfo" $btnUserInfo })
$btnPrinterCard.Add_Click({ show_screen "screenPrinterCard" $btnPrinterCard })
$btnEmployeeID.Add_Click({ show_screen "screenEmployeeID" $btnEmployeeID })
$btnPaths.Add_Click({ show_screen "screenPaths" $btnPaths })
$btnTier2.Add_Click({ show_screen "screenTier2" $btnTier2 })

### LAPS LOGIC ###

### PING PANEL LOGIC ###

$global:PingUI    = @{
    Panel     = $pingPanel
    Title     = $pingTitle
    Subtitle  = $pingSubtitle
    StatusBox = $pingStatusBox
    Status    = $pingStatus
    Detail    = $pingDetail
    Stats     = $pingStats
    Log       = $pingLog
    Toggle    = $pingToggle
    Close     = $pingClose
}
$global:PingTask  = $null
$global:PingObj   = New-Object System.Net.NetworkInformation.Ping
$global:PingLines = New-Object System.Collections.Generic.List[string]

$global:PingTimer = New-Object System.Windows.Threading.DispatcherTimer
$global:PingTimer.Interval = [TimeSpan]::FromSeconds(1)
$global:PingTimer.Add_Tick({ ping_tick })

function set_ping_color ($hex) {
    $global:PingUI.StatusBox.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($hex)
}

$global:PingCount = 5

function reset_ping_state ($target, $tag) {
    $global:PingTarget = $target
    $global:PingLines  = New-Object System.Collections.Generic.List[string]

    $w = $global:PingUI
    $w.Title.Text    = "Ping - $tag"
    $w.Subtitle.Text = "Pinging $target ($($global:PingCount) times)"
    $w.Log.Text      = ""
}

function add_ping_line ($text) {
    $global:PingLines.Add("[$((Get-Date).ToString('HH:mm:ss'))] $text")
    while ($global:PingLines.Count -gt 100) { $global:PingLines.RemoveAt(0) }
    $global:PingUI.Log.Text = ($global:PingLines -join "`r`n")
    $global:PingUI.Log.ScrollToEnd()
}

function update_ping_stats {
    $lost = $global:PingSent - $global:PingOk
    $global:PingUI.Stats.Text = "Sent: $($global:PingSent)   Replies: $($global:PingOk)   Lost: $lost"
}

function start_ping_run {
    if ($global:PingTask -and -not $global:PingTask.IsCompleted) {
        $global:PingObj = New-Object System.Net.NetworkInformation.Ping
    }
    $global:PingTask  = $null
    $global:PingSent  = 0
    $global:PingOk    = 0
    $global:PingTimes = New-Object System.Collections.Generic.List[long]
    $global:PingAddr  = $null

    $w = $global:PingUI
    $w.Status.Text = "CHECKING..."
    $w.Detail.Text = ""
    set_ping_color "#888888"
    update_ping_stats
    if ($global:PingLines.Count -gt 0) { add_ping_line "----------------------------------------" }
    add_ping_line "Pinging $($global:PingTarget) $($global:PingCount) times:"

    $w.Toggle.Content = "Stop"
    $global:PingTimer.Start()
    ping_tick
}

function finish_ping_run ($stopped) {
    stop_ping
    $w = $global:PingUI
    $w.Toggle.Content = "Re-Ping"

    $sent = $global:PingSent
    $ok   = $global:PingOk
    if ($stopped) { add_ping_line "Stopped" }
    if ($sent -eq 0) {
        $w.Status.Text = "STOPPED"
        $w.Detail.Text = "No pings sent"
        set_ping_color "#888888"
        return
    }

    $lost    = $sent - $ok
    $lossPct = [Math]::Round(($lost / $sent) * 100)
    add_ping_line "Sent = $sent, Received = $ok, Lost = $lost ($lossPct% loss)"

    if ($ok -gt 0) {
        $min = ($global:PingTimes | Measure-Object -Minimum).Minimum
        $max = ($global:PingTimes | Measure-Object -Maximum).Maximum
        $avg = [Math]::Round(($global:PingTimes | Measure-Object -Average).Average)
        add_ping_line "Minimum = $($min)ms, Maximum = $($max)ms, Average = $($avg)ms"

        $w.Status.Text = "ONLINE"
        $w.Detail.Text = "$($global:PingAddr)  -  Avg $avg ms  ($ok/$sent replies)"
        set_ping_color $(if ($lost -gt 0) { "#C77C02" } else { "#2E9E5B" })
    } else {
        $w.Status.Text = "OFFLINE"
        $w.Detail.Text = "No replies  (0/$sent, 100% loss)"
        set_ping_color "#D13438"
    }
}

function ping_tick {
    if (-not $global:PingUI) { return }
    $w = $global:PingUI

    if ($global:PingTask) {
        if (-not $global:PingTask.IsCompleted) { return }
        $task = $global:PingTask
        $global:PingTask = $null
        $global:PingSent++

        if ($task.IsFaulted) {
            $msg = $task.Exception.GetBaseException().Message
            $w.Status.Text = "OFFLINE"
            $w.Detail.Text = $msg
            set_ping_color "#D13438"
            add_ping_line $msg
        } else {
            $r = $task.Result
            if ($r.Status -eq [System.Net.NetworkInformation.IPStatus]::Success) {
                $global:PingOk++
                $global:PingTimes.Add($r.RoundtripTime)
                $global:PingAddr = $r.Address
                $w.Status.Text = "ONLINE"
                $w.Detail.Text = "$($r.Address)  -  $($r.RoundtripTime) ms"
                set_ping_color "#2E9E5B"
                add_ping_line "Reply from $($r.Address): time=$($r.RoundtripTime)ms"
            } else {
                $w.Status.Text = "OFFLINE"
                $w.Detail.Text = "$($r.Status)"
                set_ping_color "#D13438"
                add_ping_line "$($r.Status)"
            }
        }
        update_ping_stats

        if ($global:PingSent -ge $global:PingCount) {
            finish_ping_run $false
            return
        }
    }

    try {
        $global:PingTask = $global:PingObj.SendPingAsync($global:PingTarget, 1000)
    } catch {
        $w.Status.Text = "ERROR"
        $w.Detail.Text = $_.Exception.Message
        add_ping_line $_.Exception.Message
        finish_ping_run $false
    }
}

function stop_ping {
    if ($global:PingTimer) { $global:PingTimer.Stop() }
}

function show_ping_panel ($target, $tag) {
    $global:PingUI.Panel.Visibility = "Visible"
    reset_ping_state $target $tag
    start_ping_run
}

function hide_ping_panel {
    stop_ping
    $global:PingUI.Panel.Visibility = "Collapsed"
}

$pingToggle.Add_Click({
    if ($global:PingTimer.IsEnabled) {
        finish_ping_run $true
    } else {
        start_ping_run
    }
})

$pingClose.Add_Click({ hide_ping_panel })

$window.Add_Closed({
    stop_ping
    if ($global:PingObj) { $global:PingObj.Dispose(); $global:PingObj = $null }
    if ($global:BgTimer) { $global:BgTimer.Stop() }
    if ($global:BgPool) { $null = $global:BgPool.BeginClose($null, $null) }
})

function add_laps_history ($tag) {
    $existing = @($listLapsHistory.Items | Where-Object { $_ -eq $tag })
    foreach ($e in $existing) { $listLapsHistory.Items.Remove($e) }

    $listLapsHistory.Items.Insert(0, $tag)
    while ($listLapsHistory.Items.Count -gt 5) { $listLapsHistory.Items.RemoveAt(5) }
}

function search_asset_tag {
    $tag = $assetTagSearch.Text.Trim()

    $lblLapsError.Visibility = "Collapsed"
    $lapsResultCard.Visibility = "Collapsed"

    if (-not $tag -or $tag -eq "Search Asset Tag...") { return }

    set_busy $btnsearchLaps $true

    start_bg "laps" {
        param($tag, $cred, $dc)

        $computer = $null; $computerError = $null; $computerNotFound = $false
        try {
            $computer = Get-ADComputer -Identity $tag -Properties CanonicalName, DNSHostName -Server $dc -Credential $cred -ErrorAction Stop
        } catch {
            $computerError    = $_.Exception.Message
            $computerNotFound = ($_.Exception.GetType().Name -eq "ADIdentityNotFoundException") -or ($computerError -match "Cannot find an object")
        }

        $account = $null; $password = $null; $lapsError = $null
        try {
            $info = Get-LapsADPassword -Identity $tag -AsPlainText -Credential $cred -DecryptionCredential $cred -ErrorAction Stop
            if (-not $info -or -not $info.Password) {
                throw "LAPS object found, but your credentials do not have permission to read the password attribute on this machine's OU."
            }
            $account  = "$($info.Account)"
            $password = "$($info.Password)"
        } catch {
            $lapsError = $_.Exception.Message
        }

        $ou  = $null; $dns = $null
        if ($computer) { $ou = $computer.CanonicalName; $dns = $computer.DNSHostName }

        [pscustomobject]@{
            Account = $account; Password = $password; LapsError = $lapsError
            OU = $ou; DNS = $dns; ComputerError = $computerError; ComputerNotFound = $computerNotFound
        }
    } @($tag, $global:MyCred, $global:CurrentDC) {
        param($r, $s)
        set_busy $btnsearchLaps $false
        $tag = $s.Tag
        $pingTarget = $tag
        $tagExists = $false

        if (-not $r.Ok) {
            log_error "LAPS" $tag $r.Error
            show_search_error $lblLapsError "LAPS error: $($r.Error)"
        } else {
            $d = $r.Data
            if ($d.DNS) { $pingTarget = $d.DNS }
            $tagExists = [bool]($d.Password -or $d.DNS -or -not $d.ComputerError)

            if ($d.Password) {
                $lblAssetTitle.Text = $tag
                $lblAdminUser.Text  = ".\$($d.Account)"
                $lblAdminPass.Text  = $d.Password
                $lblAssetOU.Text    = if ($d.OU) { $d.OU } else { "Unknown (could not read the computer object: $($d.ComputerError))" }

                $lapsResultCard.Visibility = "Visible"
                add_laps_history $tag
            } else {
                log_error "LAPS" $tag "$($d.LapsError) | Computer lookup: $($d.ComputerError)"
                if ($d.ComputerNotFound) {
                    show_search_error $lblLapsError "Asset Tag not found!"
                } else {
                    show_search_error $lblLapsError "LAPS error: $($d.LapsError)"
                }
                $assetTagSearch.Focus()
            }
        }

        if ($tagExists) {
            show_ping_panel $pingTarget $tag
        } else {
            hide_ping_panel
        }
    } @{ Tag = $tag }
}

$listLapsHistory.Add_SelectionChanged({
    if ($listLapsHistory.SelectedItem -ne $null) {
        $assetTagSearch.Text = $listLapsHistory.SelectedItem
        $assetTagSearch.Foreground = [System.Windows.Media.Brushes]::Black
        search_asset_tag

        $listLapsHistory.SelectedItem = $null
    }
})

$assetTagSearch.Add_KeyDown({ if ($_.Key -eq "Enter") { $_.Handled = $true; search_asset_tag } })
$assetTagSearch.Add_GotFocus({ if ($assetTagSearch.Text -eq "Search Asset Tag...") { $assetTagSearch.Text = ""; $assetTagSearch.Foreground = [System.Windows.Media.Brushes]::Black } })
$assetTagSearch.Add_LostFocus({ if ([string]::IsNullOrWhiteSpace($assetTagSearch.Text)) { $assetTagSearch.Text = "Search Asset Tag..."; $assetTagSearch.Foreground = [System.Windows.Media.Brushes]::Gray } })
$btnClearHistory.Add_Click({ $listLapsHistory.Items.Clear() })
$btnsearchLaps.Add_Click({ search_asset_tag })


### USER SEARCH LOGIC ###

function select_user_tab ($tab) {
    $userContentArea.Visibility = if ($tab -eq "info")   { "Visible" } else { "Collapsed" }
    $userGroupsArea.Visibility  = if ($tab -eq "groups") { "Visible" } else { "Collapsed" }
    $userAppsArea.Visibility    = if ($tab -eq "apps")   { "Visible" } else { "Collapsed" }

    $tabButtons = @{ info = $btnSubUserInfo; groups = $btnSubUserGroups; apps = $btnSubUserApps }
    foreach ($key in $tabButtons.Keys) {
        $btn = $tabButtons[$key]
        if ($key -eq $tab) {
            $btn.Foreground      = [System.Windows.Media.Brushes]::RoyalBlue
            $btn.FontWeight      = "SemiBold"
            $btn.BorderThickness = New-Object System.Windows.Thickness(0,0,0,2)
            $btn.BorderBrush     = [System.Windows.Media.Brushes]::RoyalBlue
        } else {
            $btn.Foreground      = [System.Windows.Media.Brushes]::Gray
            $btn.FontWeight      = "Normal"
            $btn.BorderThickness = New-Object System.Windows.Thickness(0)
        }
    }
}

function hide_user_areas {
    $userContentArea.Visibility     = "Collapsed"
    $userGroupsArea.Visibility      = "Collapsed"
    $userAppsArea.Visibility        = "Collapsed"
    $userSubNavbar.Visibility       = "Collapsed"
    $multipleResultsArea.Visibility = "Collapsed"
}

function search_user {
    $user = $userSearch.Text.Trim()
    
    $lblUserError.Visibility = "Collapsed"
    hide_user_areas

    $listUserResults.Items.Clear()
    $global:currentLoadedUser = $null

    if (-not $user -or $user -eq "Search User...") { return }

    if ($user.Length -le 2) {
        show_search_error $lblUserError "Please type more than 2 characters!"
        return
    }

    set_busy $btnsearchUser $true

    start_bg "user" {
        param($user, $dc)
        $safe = $user -replace "'", "''"
        $filter = "SamAccountName -eq '$safe' -or DisplayName -like '*$safe*' -or Name -like '*$safe*'"

        @(Get-ADUser -Filter $filter -Server $dc -Properties DisplayName, Title, EmailAddress, Manager -ErrorAction Stop | ForEach-Object {
            [pscustomobject]@{
                DisplayName = $_.DisplayName; Name = $_.Name; SamAccountName = $_.SamAccountName
                EmailAddress = $_.EmailAddress; Manager = $_.Manager; Enabled = $_.Enabled
            }
        })
    } @($user, $global:CurrentDC) {
        param($r, $s)
        set_busy $btnsearchUser $false

        if (-not $r.Ok) {
            log_error "USER SEARCH" $s.User $r.Error
            show_search_error $lblUserError "Search failed: $($r.Error)"
            return
        }

        $searchResults = @($r.Data | Where-Object { $null -ne $_ })

        if ($searchResults.Count -eq 0) {
            show_search_error $lblUserError "User not found!"

        } elseif ($searchResults.Count -eq 1) {
            load_user $searchResults[0].SamAccountName

        } else {
            foreach ($u in $searchResults) {
                $bestName = if ($u.DisplayName) { $u.DisplayName } else { $u.Name }

                $row = [PSCustomObject]@{
                    DisplayName    = $bestName
                    SamAccountName = $u.SamAccountName
                    EmailAddress   = if ($u.EmailAddress) { $u.EmailAddress } else { "N/A" }
                    Manager        = if ($u.Manager) { ($u.Manager -split ",")[0].Replace("CN=","") } else { "N/A" }
                    Color          = if ($u.Enabled) { "Black" } else { "Red" }
                }

                $listUserResults.Items.Add($row) | Out-Null
            }

            $multipleResultsArea.Visibility = "Visible"
        }
    } @{ User = $user }
}

$global:lastClickedHeader = $null
$global:sortDirection = "Ascending"

function sort_users {
    param($sender, $e)
    
    $column = $e.OriginalSource.Column
    if ($null -eq $column) { return }

    $headerClicked = $column.DisplayMemberBinding.Path.Path
    if ($null -eq $headerClicked) { return }

    if ($global:lastClickedHeader -eq $headerClicked) {
        $global:sortDirection = if ($global:sortDirection -eq "Ascending") { "Descending" } else { "Ascending" }
    } else {
        $global:sortDirection = "Ascending"
    }
    $global:lastClickedHeader = $headerClicked

    $items = @($listUserResults.Items)
    $listUserResults.Items.Clear()

    $sorted = if ($global:sortDirection -eq "Ascending") {
        $items | Sort-Object -Property $headerClicked
    } else {
        $items | Sort-Object -Property $headerClicked -Descending
    }

    foreach ($item in $sorted) {
        $listUserResults.Items.Add($item) | Out-Null
    }
}

$global:UserFetchWork = {
    param($user, $dc)
    $props = @("DisplayName", "Title", "EmailAddress", "Manager", "StreetAddress", "City", "State", "PostalCode", "Country",
               "PasswordLastSet", "lastLogonTimestamp", "LastBadPasswordAttempt", "badPwdCount", "whenChanged",
               "msExchRemoteRecipientType", "extensionAttribute2", "extensionAttribute3", "AccountExpirationDate",
               "employeeID", "MobilePhone", "OfficePhone", "LockedOut")

    $adUser = Get-ADUser -Identity $user -Server $dc -Properties $props -ErrorAction Stop |
              Select-Object -Property (@("DistinguishedName", "SamAccountName", "Enabled") + $props)

    $groups = @(Get-ADPrincipalGroupMembership -Identity $user -ErrorAction Stop | ForEach-Object { $_.DistinguishedName })

    [pscustomobject]@{ User = $adUser; Groups = $groups }
}

function format_user ($adUser, $groups) {
    $na = { param($v) if ($v) { "$v" } else { "N/A" } }
    $when = { param($d) if ($d) { $d.ToString("MMM dd, yyyy HH:mm") } else { "Never" } }

    $officePhone = & $na $adUser.OfficePhone
    $mobilePhone = & $na $adUser.MobilePhone

    $addressParts = @($adUser.StreetAddress, $adUser.City, $adUser.State, $adUser.PostalCode, $adUser.Country) |
                    Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

    if ($groups -match "Disabled Users") {
        $level = "Disabled";      $levelBrush = [System.Windows.Media.Brushes]::Red
    } elseif ($groups -match "Low Risk") {
        $level = "Low Risk User"; $levelBrush = [System.Windows.Media.Brushes]::Green
    } elseif ($groups -match "Domain Users") {
        $level = "Domain User";   $levelBrush = [System.Windows.Media.Brushes]::Blue
    } else {
        $level = "NOT DETECTED";  $levelBrush = [System.Windows.Media.Brushes]::Gray
    }

    if (-not $adUser.Enabled) {
        $status = "DISABLED"; $statusBrush = [System.Windows.Media.Brushes]::Red
    } elseif ($adUser.LockedOut) {
        $status = "LOCKED";   $statusBrush = [System.Windows.Media.Brushes]::Crimson
    } else {
        $status = "UNLOCKED"; $statusBrush = [System.Windows.Media.Brushes]::LimeGreen
    }

    $lastActiveDay = if ($adUser.AccountExpirationDate) { $adUser.AccountExpirationDate.AddDays(-1) } else { $null }

    [pscustomobject]@{
        Name          = $adUser.DisplayName
        Title         = $adUser.Title
        Sam           = $adUser.SamAccountName
        EmployeeID    = & $na $adUser.employeeID
        Email         = & $na $adUser.EmailAddress
        Manager       = if ($adUser.Manager) { ($adUser.Manager -split ",")[0].Replace("CN=","") } else { "N/A" }
        Phone         = "$officePhone / $mobilePhone"
        Address       = if ($addressParts) { $addressParts -join ", " } else { "N/A" }
        Level         = $level
        LevelBrush    = $levelBrush
        Status        = $status
        StatusBrush   = $statusBrush
        ExtAttr2      = & $na $adUser.extensionAttribute2
        ExtAttr3      = & $na $adUser.extensionAttribute3
        Exch          = & $na $adUser.msExchRemoteRecipientType
        PwdLastSet    = & $when $adUser.PasswordLastSet
        LastLogin     = if ($adUser.LastLogonTimestamp) { [DateTime]::FromFileTime($adUser.LastLogonTimestamp).ToString("MMM dd, yyyy HH:mm") } else { "Never" }
        LastBadLogin  = & $when $adUser.LastBadPasswordAttempt
        Modified      = & $when $adUser.whenChanged
        BadPwdCount   = "$($adUser.BadPwdCount)"
        LastActiveDay = $lastActiveDay
        Expiration    = if ($lastActiveDay) { $lastActiveDay.ToString("MMMM dd, yyyy") } else { "Never" }
    }
}

$global:CurrentUserData = $null

function load_user ($user) {
    $global:currentLoadedUser = $null
    $global:CurrentUserData = $null
    $lblUserError.Visibility = "Collapsed"
    $multipleResultsArea.Visibility = "Collapsed"

    set_busy $btnsearchUser $true "Loading..."

    start_bg "loaduser" $global:UserFetchWork @($user, $global:CurrentDC) {
        param($r, $s)
        set_busy $btnsearchUser $false

        if (-not $r.Ok) {
            log_error "USER LOAD" $s.User $r.Error
            show_search_error $lblUserError $r.Error
            hide_user_areas
            $global:currentLoadedUser = $null
            return
        }

        $adUser = $r.Data.User
        $f = format_user $adUser @($r.Data.Groups)

        $global:currentLoadedUser = $adUser.DistinguishedName
        $global:CurrentUserData = $r.Data

        $lblUserName.Text     = $f.Name
        $lblUserJobTitle.Text = $f.Title
        $lblEmployeeID.Text   = $f.EmployeeID
        $lblUserSam.Text      = $f.Sam
        $lblUserEmail.Text    = $f.Email
        $lblUserManager.Text  = $f.Manager
        $lblUserPhone.Text    = $f.Phone
        $lblUserAddress.Text  = $f.Address

        $lblUserLevel.Text       = $f.Level
        $lblUserLevel.Foreground = $f.LevelBrush

        $lblExtAttr2.Text = $f.ExtAttr2
        $lblExtAttr3.Text = $f.ExtAttr3
        $lblUserExch.Text = $f.Exch

        $lblPwdLastSet.Text       = $f.PwdLastSet
        $lblLastLogin.Text        = $f.LastLogin
        $lblLastBadLogin.Text     = $f.LastBadLogin
        $lblModified.Text         = $f.Modified
        $lblBadPasswordCount.Text = $f.BadPwdCount

        $lblUserStatus.Text       = $f.Status
        $brdUserStatus.Background = $f.StatusBrush
        $actionsVisibility = if ($adUser.Enabled) { "Visible" } else { "Collapsed" }
        $btnUnlockAccount.Visibility = $actionsVisibility
        $btnResetPassword.Visibility = $actionsVisibility

        $dpAccountExpiration.SelectedDate = $f.LastActiveDay
        $lblExpirationText.Text = $f.Expiration

        $userSubNavbar.Visibility = "Visible"
        select_user_tab "info"
    } @{ User = $user }
}

### USER POP-OUT WINDOW LOGIC ###

$global:UserPopups = New-Object System.Collections.ArrayList

$global:UserPopupXaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="User Info" Width="420" Height="640" MinWidth="360" MinHeight="400"
        Background="#F3F3F3" FontFamily="Segoe UI" WindowStartupLocation="Manual"
        UseLayoutRounding="True" TextOptions.TextFormattingMode="Display">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <Border Grid.Row="0" Background="White" BorderBrush="#E5E5E5" BorderThickness="0,0,0,1" Padding="15,12">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <Border Grid.Column="0" Width="40" Height="40" CornerRadius="20" Background="#007ACC" Margin="0,0,12,0" VerticalAlignment="Center">
                    <TextBlock Text="&#xE77B;" FontFamily="Segoe MDL2 Assets" Foreground="White" FontSize="18" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                </Border>
                <StackPanel Grid.Column="1" VerticalAlignment="Center">
                    <TextBox Name="popName" Text="-" IsReadOnly="True" FontSize="16" FontWeight="Bold" BorderThickness="0" Background="Transparent" TextWrapping="Wrap"/>
                    <TextBox Name="popTitle" Text="" IsReadOnly="True" FontSize="12" Foreground="#666" BorderThickness="0" Background="Transparent" TextWrapping="Wrap"/>
                </StackPanel>
                <Border Grid.Column="2" Name="popStatusBox" Padding="8,2" CornerRadius="4" Background="#888888" VerticalAlignment="Center" Margin="10,0,0,0">
                    <TextBlock Name="popStatus" Text="-" FontSize="11" FontWeight="Bold"/>
                </Border>
            </Grid>
        </Border>

        <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
            <StackPanel Margin="15">
                <TextBlock Name="popError" Foreground="#D13438" FontWeight="SemiBold" TextWrapping="Wrap" Margin="0,0,0,10" Visibility="Collapsed"/>

                <Border Background="White" CornerRadius="8" BorderBrush="#E5E5E5" BorderThickness="1" Padding="15" Margin="0,0,0,12">
                    <StackPanel>
                        <TextBlock Text="Details" FontWeight="Bold" Margin="0,0,0,8"/>
                        <StackPanel Name="popDetails"/>
                    </StackPanel>
                </Border>

                <Border Background="White" CornerRadius="8" BorderBrush="#E5E5E5" BorderThickness="1" Padding="15" Margin="0,0,0,12">
                    <StackPanel>
                        <TextBlock Text="Account Activity" FontWeight="Bold" Margin="0,0,0,8"/>
                        <StackPanel Name="popActivity"/>
                    </StackPanel>
                </Border>

                <Border Background="White" CornerRadius="8" BorderBrush="#E5E5E5" BorderThickness="1" Padding="15">
                    <StackPanel>
                        <TextBlock Name="popGroupsHeader" Text="Groups" FontWeight="Bold" Margin="0,0,0,8"/>
                        <ListBox Name="popGroups" Height="170" BorderBrush="#E5E5E5" FontSize="11"/>
                    </StackPanel>
                </Border>
            </StackPanel>
        </ScrollViewer>

        <Border Grid.Row="2" Background="White" BorderBrush="#E5E5E5" BorderThickness="0,1,0,0" Padding="15,8">
            <Grid>
                <TextBlock Name="popUpdated" Text="" FontSize="10" Foreground="#888" VerticalAlignment="Center"/>
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                    <Button Name="popRefresh" Content="Refresh" Width="90" Height="26" Margin="0,0,8,0" Background="#007ACC" Foreground="White" BorderThickness="0"/>
                    <Button Name="popClose" Content="Close" Width="80" Height="26" Background="#F1F1F1" BorderThickness="0"/>
                </StackPanel>
            </Grid>
        </Border>
    </Grid>
</Window>
'@

function add_popup_row ($panel, $label, $value, $brush) {
    $row = New-Object System.Windows.Controls.Grid
    $row.Margin = "0,0,0,6"
    $c1 = New-Object System.Windows.Controls.ColumnDefinition; $c1.Width = New-Object System.Windows.GridLength(120)
    $c2 = New-Object System.Windows.Controls.ColumnDefinition
    $row.ColumnDefinitions.Add($c1); $row.ColumnDefinitions.Add($c2)

    $lbl = New-Object System.Windows.Controls.TextBlock -Property @{ Text = $label; Foreground = "#888"; FontSize = 11; VerticalAlignment = "Top" }

    $val = New-Object System.Windows.Controls.TextBox -Property @{
        Text = "$value"; IsReadOnly = $true; BorderThickness = "0"; Background = "Transparent"
        FontWeight = "SemiBold"; FontSize = 11; TextWrapping = "Wrap"
    }
    if ($brush) { $val.Foreground = $brush }
    [System.Windows.Controls.Grid]::SetColumn($val, 1)

    $null = $row.Children.Add($lbl)
    $null = $row.Children.Add($val)
    $null = $panel.Children.Add($row)
}

function fill_user_popup ($ui, $data) {
    $f = format_user $data.User @($data.Groups)
    $ui.UserDN = $data.User.DistinguishedName

    $ui.Window.Title         = "$($f.Name) - User Info"
    $ui.Name.Text            = $f.Name
    $ui.Title.Text           = $f.Title
    $ui.Status.Text          = $f.Status
    $ui.StatusBox.Background = $f.StatusBrush
    $ui.Error.Visibility     = "Collapsed"

    $ui.Details.Children.Clear()
    add_popup_row $ui.Details "Username"         $f.Sam
    add_popup_row $ui.Details "Employee ID"      $f.EmployeeID
    add_popup_row $ui.Details "User Level"       $f.Level $f.LevelBrush
    add_popup_row $ui.Details "Email"            $f.Email
    add_popup_row $ui.Details "Manager"          $f.Manager
    add_popup_row $ui.Details "Phone/Mobile"     $f.Phone
    add_popup_row $ui.Details "Address"          $f.Address
    add_popup_row $ui.Details "Expiration Date"  $f.Expiration
    add_popup_row $ui.Details "Exch Remote Type" $f.Exch
    add_popup_row $ui.Details "Extension Attr 2" $f.ExtAttr2
    add_popup_row $ui.Details "Extension Attr 3" $f.ExtAttr3

    $ui.Activity.Children.Clear()
    add_popup_row $ui.Activity "Password Last Set"  $f.PwdLastSet
    add_popup_row $ui.Activity "Last Login"         $f.LastLogin
    add_popup_row $ui.Activity "Last Bad Login"     $f.LastBadLogin
    add_popup_row $ui.Activity "Last Modified"      $f.Modified
    add_popup_row $ui.Activity "Bad Password Count" $f.BadPwdCount

    $ui.Groups.Items.Clear()
    $names = @($data.Groups | Where-Object { $_ } | ForEach-Object { group_name_from_dn $_ } | Where-Object { $_ } | Sort-Object)
    foreach ($n in $names) { $null = $ui.Groups.Items.Add($n) }
    $ui.GroupsHeader.Text = "Groups ($($names.Count))"

    $ui.Updated.Text = "Loaded at $((Get-Date).ToString('HH:mm:ss'))  -  read-only"
}

function refresh_user_popup ($ui) {
    if (-not $ui.UserDN) { return }

    $ui.Refresh.IsEnabled = $false
    $ui.Refresh.Content   = "Refreshing..."

    start_bg "popup-$($ui.Id)" $global:UserFetchWork @($ui.UserDN, $global:CurrentDC) {
        param($r, $s)
        $ui = $s.UI
        if ($ui.IsClosed) { return }

        $ui.Refresh.IsEnabled = $true
        $ui.Refresh.Content   = "Refresh"

        if ($r.Ok) {
            fill_user_popup $ui $r.Data
        } else {
            $ui.Error.Text       = "Could not refresh: $($r.Error)"
            $ui.Error.Visibility = "Visible"
        }
    } @{ UI = $ui }
}

function open_user_popup ($data) {
    $reader = New-Object System.Xml.XmlNodeReader ([xml]$global:UserPopupXaml)
    $win = [Windows.Markup.XamlReader]::Load($reader)

    $ui = @{
        Id           = [guid]::NewGuid().ToString("N")
        Window       = $win
        IsClosed     = $false
        UserDN       = $null
        Name         = $win.FindName("popName")
        Title        = $win.FindName("popTitle")
        StatusBox    = $win.FindName("popStatusBox")
        Status       = $win.FindName("popStatus")
        Error        = $win.FindName("popError")
        Details      = $win.FindName("popDetails")
        Activity     = $win.FindName("popActivity")
        GroupsHeader = $win.FindName("popGroupsHeader")
        Groups       = $win.FindName("popGroups")
        Updated      = $win.FindName("popUpdated")
        Refresh      = $win.FindName("popRefresh")
        Close        = $win.FindName("popClose")
    }

    $win.Tag = $ui
    $ui.Refresh.Tag = $ui
    $ui.Close.Tag = $ui
    $ui.Refresh.Add_Click({ refresh_user_popup $this.Tag })
    $ui.Close.Add_Click({ $this.Tag.Window.Close() })
    $win.Add_Closed({
        $this.Tag.IsClosed = $true
        $global:UserPopups.Remove($this.Tag)
    })

    fill_user_popup $ui $data

    $offset = 30 * ($global:UserPopups.Count % 8)
    $screenRight = [System.Windows.SystemParameters]::VirtualScreenLeft + [System.Windows.SystemParameters]::VirtualScreenWidth
    $left = $window.Left + $window.ActualWidth + 10 + $offset
    if ($left + $win.Width -gt $screenRight) { $left = $window.Left + 60 + $offset }
    $win.Left = $left
    $win.Top  = $window.Top + $offset

    $null = $global:UserPopups.Add($ui)
    $win.Show()
}

$btnPopOutUser.Add_Click({
    if ($global:CurrentUserData) { open_user_popup $global:CurrentUserData }
})

$window.Add_Closed({
    foreach ($p in @($global:UserPopups)) { $p.Window.Close() }
})

function get_user_groups {
    if (-not $global:currentLoadedUser) { return }

    $listUserGroups.Items.Clear()
    $lblGroupCount.Text = "Loading groups..."

    start_bg "groups" {
        param($userDN, $dc)
        $u = Get-ADUser -Identity $userDN -Properties memberOf, PrimaryGroup -Server $dc -ErrorAction Stop
        [pscustomobject]@{ MemberOf = @($u.memberOf); PrimaryGroup = $u.PrimaryGroup }
    } @($global:currentLoadedUser, $global:CurrentDC) {
        param($r, $s)
        if ($s.UserDN -ne $global:currentLoadedUser) { return }

        if (-not $r.Ok) {
            Write-Host "Error loading groups: $($r.Error)" -ForegroundColor Red
            $lblGroupCount.Text = "Could not load groups: $($r.Error)"
            return
        }

        $listUserGroups.Items.Clear()
        $primaryDN = $r.Data.PrimaryGroup
        $dns = @($r.Data.MemberOf | Where-Object { $_ })
        if ($primaryDN -and $dns -notcontains $primaryDN) { $dns += $primaryDN }

        $rows = foreach ($dn in $dns) {
            [PSCustomObject]@{ GroupName = (group_name_from_dn $dn); DN = $dn; IsPrimary = ($dn -eq $primaryDN) }
        }
        $rows | Sort-Object GroupName | ForEach-Object { $listUserGroups.Items.Add($_) | Out-Null }

        $lblGroupCount.Text = "Total Groups: $($listUserGroups.Items.Count)"
    } @{ UserDN = $global:currentLoadedUser }
}

function add_user_to_group {
    if (-not $global:currentLoadedUser) {
        [System.Windows.MessageBox]::Show("Please load a user first.")
        return
    }

    $lblGroupActionError.Visibility = "Collapsed"

    $groupName = $txtAddGroupName.Text.Trim()

    if ([string]::IsNullOrWhiteSpace($groupName) -or $groupName -eq "Enter group name to add...") {
        $lblGroupActionError.Text = "Please enter a group name."
        $lblGroupActionError.Visibility = "Visible"
        return
    }

    try {
        $adGroup = Get-ADGroup -Identity $groupName -Server $global:CurrentDC -ErrorAction Stop

        $u = Get-ADUser -Identity $global:currentLoadedUser -Properties memberOf, PrimaryGroup -Server $global:CurrentDC -ErrorAction Stop
        $memberOfDNs = @($u.memberOf) + @($u.PrimaryGroup)

        if ($memberOfDNs -contains $adGroup.DistinguishedName) {
            $lblGroupActionError.Text = "User is already a member of '$($adGroup.Name)'."
            $lblGroupActionError.Visibility = "Visible"
            return
        }

        Add-ADGroupMember -Identity $adGroup -Members $global:currentLoadedUser -Credential $global:MyCred -Server $global:CurrentDC -ErrorAction Stop

        $txtAddGroupName.Text = "Enter group name to add..."
        $txtAddGroupName.Foreground = [System.Windows.Media.Brushes]::Gray

        get_user_groups
        get_apps

    } catch {
        $lblGroupActionError.Text = "Could not add to group: $($_.Exception.Message)"
        $lblGroupActionError.Visibility = "Visible"
    }
}

function remove_user_from_group {
    if (-not $global:currentLoadedUser) {
        [System.Windows.MessageBox]::Show("Please load a user first.")
        return
    }

    $lblGroupActionError.Visibility = "Collapsed"

    $selected = $listUserGroups.SelectedItem

    if ($null -eq $selected) {
        $lblGroupActionError.Text = "Select a group from the list to remove."
        $lblGroupActionError.Visibility = "Visible"
        return
    }

    $groupName = $selected.GroupName

    if ($selected.IsPrimary) {
        $lblGroupActionError.Text = "'$groupName' is the user's primary group, so it can't be removed."
        $lblGroupActionError.Visibility = "Visible"
        return
    }

    $confirm = [System.Windows.MessageBox]::Show("Remove $($lblUserName.Text) from '$groupName'?", "Confirm Removal", "YesNo", "Warning")

    if ($confirm -ne "Yes") { return }

    try {
        Remove-ADGroupMember -Identity $selected.DN -Members $global:currentLoadedUser -Credential $global:MyCred -Confirm:$false -Server $global:CurrentDC -ErrorAction Stop

        get_user_groups
        get_apps

    } catch {
        $lblGroupActionError.Text = "Could not remove from group: $($_.Exception.Message)"
        $lblGroupActionError.Visibility = "Visible"
    }
}

$txtAddGroupName.Add_GotFocus({ if ($txtAddGroupName.Text -eq "Enter group name to add...") { $txtAddGroupName.Text = ""; $txtAddGroupName.Foreground = [System.Windows.Media.Brushes]::Black } })
$txtAddGroupName.Add_LostFocus({ if ([string]::IsNullOrWhiteSpace($txtAddGroupName.Text)) { $txtAddGroupName.Text = "Enter group name to add..."; $txtAddGroupName.Foreground = [System.Windows.Media.Brushes]::Gray } })
$txtAddGroupName.Add_KeyDown({ if ($_.Key -eq "Enter") { $_.Handled = $true; add_user_to_group } })

$btnAddUserGroup.Add_Click({ add_user_to_group })
$btnRemoveUserGroup.Add_Click({ remove_user_from_group })

function get_apps {
    if (-not $global:currentLoadedUser) { return }

    start_bg "apps" {
        param($userDN, $dc)
        @((Get-ADUser -Identity $userDN -Properties memberOf -Server $dc -ErrorAction Stop).memberOf)
    } @($global:currentLoadedUser, $global:CurrentDC) {
        param($r, $s)
        if ($s.UserDN -ne $global:currentLoadedUser) { return }

        if (-not $r.Ok) {
            Write-Warning "Could not retrieve groups: $($r.Error)"
            return
        }

        $names = @($r.Data | Where-Object { $_ } | ForEach-Object { group_name_from_dn $_ })
        render_apps $names
    } @{ UserDN = $global:currentLoadedUser }
}

function render_apps ($userGroups) {
    $bc = New-Object System.Windows.Media.BrushConverter

    $AddListItem = {
        param($list, $groupName, $color)
        $container = New-Object System.Windows.Controls.StackPanel -Property @{Orientation="Horizontal"; Margin="0,2"}
        $icon = New-Object System.Windows.Controls.TextBlock -Property @{
            Text = [char]0xE73E; FontFamily = "Segoe MDL2 Assets"; Foreground = $color; Margin = "0,0,8,0"; FontSize = 10
        }
        $text = New-Object System.Windows.Controls.TextBlock -Property @{Text = $groupName; FontSize = 11}
        $container.Children.Add($icon); $container.Children.Add($text)
        $list.Items.Add($container)
    }

    ### TRUX LOGIC###

    $TruxUserGroup = "Trux User Group"
    $TruxAWS = "CTX - AWS - APP - Trux"
    
    $hasTruxUserGroup = $userGroups -contains $TruxUserGroup
    $hasTruxAWS = $userGroups -contains $TruxAWS

    $listTruxStatus.Items.Clear()

    if ($hasTruxAWS -and -not $hasTruxUserGroup) {
        $brdTruxHeader.Background = $bc.ConvertFromString("#FFEB9C")
        $truxColor = $bc.ConvertFromString("#9C5700")
        $txtTruxStatusIcon.Text = [char]0xE7BA
        $txtTruxVersion.Text = "Missing Trux User Group"

    } elseif ($hasTruxUserGroup -and -not $hasTruxAWS) {
        $brdTruxHeader.Background = $bc.ConvertFromString("#FFEB9C")
        $truxColor = $bc.ConvertFromString("#9C5700")
        $txtTruxStatusIcon.Text = [char]0xE7BA
        $txtTruxVersion.Text = "Missing Citrix AWS Group"

    } elseif ($hasTruxAWS -and $hasTruxUserGroup) {
        $brdTruxHeader.Background = $bc.ConvertFromString("#C6EFCE")
        $truxColor = $bc.ConvertFromString("#006100")
        $txtTruxStatusIcon.Text = [char]0xE73E
        $txtTruxVersion.Text = "AWS Access"

    } else {
        $brdTruxHeader.Background = $bc.ConvertFromString("#FFC7CE")
        $truxColor = $bc.ConvertFromString("#9C0006")
        $txtTruxStatusIcon.Text = [char]0xE711
        $txtTruxVersion.Text = "No Access"
    }
    
    $txtTruxTitle.Foreground = $truxColor
    $txtTruxVersion.Foreground = $truxColor
    $txtTruxStatusIcon.Foreground = $truxColor

    if ($hasTruxAWS) { &$AddListItem $listTruxStatus $TruxAWS $truxColor }
    if ($hasTruxUserGroup) { &$AddListItem $listTruxStatus $TruxUserGroup $truxColor }

    $btnToggleTruxAWS.Content = if ($hasTruxAWS) { "Remove AWS" } else { "Add AWS" }
    $btnToggleTruxMand.Content = if ($hasTruxUserGroup) { "Remove Trux Group" } else { "Add Trux Group" }

    ### TOWER LOGIC ###

    $TowerAWS = "CTX - AWS - APP - Tower"
    
    $hasTowerAWS = $userGroups -contains $TowerAWS

    $listTowerStatus.Items.Clear()

    if ($hasTowerAWS) {
        $brdTowerHeader.Background = $bc.ConvertFromString("#C6EFCE")
        $towerColor = $bc.ConvertFromString("#006100")
        $txtTowerStatusIcon.Text = [char]0xE73E
        $txtTowerVersion.Text = "AWS Access"
    } else {
        $brdTowerHeader.Background = $bc.ConvertFromString("#FFC7CE")
        $towerColor = $bc.ConvertFromString("#9C0006")
        $txtTowerStatusIcon.Text = [char]0xE711
        $txtTowerVersion.Text = "No Access"
    }

    $txtTowerTitle.Foreground = $towerColor
    $txtTowerVersion.Foreground = $towerColor
    $txtTowerStatusIcon.Foreground = $towerColor

    if ($hasTowerAWS) { &$AddListItem $listTowerStatus $TowerAWS $towerColor }

    $btnToggleTowerAWS.Content = if ($hasTowerAWS) { "Remove AWS" } else { "Add AWS" }

    ### M5 LOGIC ###

    $M5US = "M5 US Users"
    $M5CA = "M5 CA Users"
    
    $hasUS = $userGroups -contains $M5US
    $hasCA = $userGroups -contains $M5CA

    $listM5Status.Items.Clear()

    if ($hasUS -and $hasCA) {
        $brdM5Header.Background = $bc.ConvertFromString("#FFEB9C")
        $m5Color = $bc.ConvertFromString("#9C5700")
        $txtM5StatusIcon.Text = [char]0xE7BA
        $txtM5Version.Text = "Dual Region Access"
    }
    elseif ($hasUS -or $hasCA) {
        $brdM5Header.Background = $bc.ConvertFromString("#C6EFCE")
        $m5Color = $bc.ConvertFromString("#006100")
        $txtM5StatusIcon.Text = [char]0xE73E
        
        $region = if ($hasUS) { "US" } else { "CA" }
        $txtM5Version.Text = "Region: $region"
    }
    else {
        $brdM5Header.Background = $bc.ConvertFromString("#FFC7CE")
        $m5Color = $bc.ConvertFromString("#9C0006")
        $txtM5StatusIcon.Text = [char]0xE711
        $txtM5Version.Text = "No Access"
    }

    $txtM5Title.Foreground = $m5Color
    $txtM5Version.Foreground = $m5Color
    $txtM5StatusIcon.Foreground = $m5Color

    if ($hasUS) { &$AddListItem $listM5Status $M5US $m5Color }
    if ($hasCA) { &$AddListItem $listM5Status $M5CA $m5Color }

    $btnToggleM5US.Content = if ($hasUS) { "Remove US" } else { "Add US" }
    $btnToggleM5CA.Content = if ($hasCA) { "Remove CA" } else { "Add CA" }

    ### OMS LOGIC ###

    $OMSV30 = "OMSV30"
    $OMSV30DEV = "OMSV30DEV"
    
    $hasOMSV30 = $userGroups -contains $OMSV30
    $hasOMSV30DEV = $userGroups -contains $OMSV30DEV

    $listOMSStatus.Items.Clear()

    if ($hasOMSV30 -and $hasOMSV30DEV) {
        $brdOMSHeader.Background = $bc.ConvertFromString("#C6EFCE")
        $omsColor = $bc.ConvertFromString("#006100")
        $txtOMSStatusIcon.Text = [char]0xE73E
        $txtOMSVersion.Text = "Has Access"
    } elseif ($hasOMSV30 -and -not $hasOMSV30DEV) {
        $brdOMSHeader.Background = $bc.ConvertFromString("#FFEB9C")
        $omsColor = $bc.ConvertFromString("#9C5700")
        $txtOMSStatusIcon.Text = [char]0xE7BA
        $txtOMSVersion.Text = "Missing OMSV30DEV"
    } elseif ($hasOMSV30DEV -and -not $hasOMSV30) {
        $brdOMSHeader.Background = $bc.ConvertFromString("#FFEB9C")
        $omsColor = $bc.ConvertFromString("#9C5700")
        $txtOMSStatusIcon.Text = [char]0xE7BA
        $txtOMSVersion.Text = "Missing OMSV30"
    } else {
        $brdOMSHeader.Background = $bc.ConvertFromString("#FFC7CE")
        $omsColor = $bc.ConvertFromString("#9C0006")
        $txtOMSStatusIcon.Text = [char]0xE711
        $txtOMSVersion.Text = "No Access"
    }

    $txtOMSTitle.Foreground = $omsColor
    $txtOMSVersion.Foreground = $omsColor
    $txtOMSStatusIcon.Foreground = $omsColor

    if ($hasOMSV30) { &$AddListItem $listOMSStatus $OMSV30 $omsColor }
    if ($hasOMSV30DEV) { &$AddListItem $listOMSStatus $OMSV30DEV $omsColor }

    $btnToggleOMSV30.Content = if ($hasOMSV30) { "Remove V30" } else { "Add V30" }
    $btnToggleOMSV30DEV.Content = if ($hasOMSV30DEV) { "Remove V30DEV" } else { "Add V30DEV" }

    ### CieTrade LOGIC ###

    $CieAWS = "CTX - AWS - APP - Cietrade"
    $CieScale1 = "CTX - AWS - APP - Cietrade Scale 1"
    $CieScale2 = "CTX - AWS - APP - Cietrade Scale 2"
    
    $hasCieAWS = $userGroups -contains $CieAWS
    $hasCieScale1 = $userGroups -contains $CieScale1
    $hasCieScale2 = $userGroups -contains $CieScale2

    $listCieStatus.Items.Clear()

    if ($hasCieAWS) {
        $brdCieHeader.Background = $bc.ConvertFromString("#C6EFCE")
        $cieColor = $bc.ConvertFromString("#006100")
        $txtCieStatusIcon.Text = [char]0xE73E
        $txtCieVersion.Text = "AWS Access"
    } else {
        $brdCieHeader.Background = $bc.ConvertFromString("#FFC7CE")
        $cieColor = $bc.ConvertFromString("#9C0006")
        $txtCieStatusIcon.Text = [char]0xE711
        $txtCieVersion.Text = "No Access"
    }

    $txtCieTitle.Foreground = $cieColor
    $txtCieVersion.Foreground = $cieColor
    $txtCieStatusIcon.Foreground = $cieColor

    if ($hasCieAWS) { &$AddListItem $listCieStatus $CieAWS $cieColor }
    if ($hasCieScale1) { &$AddListItem $listCieStatus $CieScale1 $cieColor }
    if ($hasCieScale2) { &$AddListItem $listCieStatus $CieScale2 $cieColor }

    $btnToggleCieScale1.Content = if ($hasCieScale1) { "Remove Scale 1" } else { "Add Scale 1" }
    $btnToggleCieScale2.Content = if ($hasCieScale2) { "Remove Scale 2" } else { "Add Scale 2" }
    $btnToggleCieAWS.Content = if ($hasCieAWS) { "Remove AWS" } else { "Add AWS" }

    ### PCSCALE LOGIC ###

    $PCScaleAWS = "CTX - AWS - APP - PC Scale"
    
    $hasPCScaleAWS = $userGroups -contains $PCScaleAWS

    $listPCScaleStatus.Items.Clear()

    if ($hasPCScaleAWS) {
        $brdPCScaleHeader.Background = $bc.ConvertFromString("#C6EFCE")
        $PCScaleColor = $bc.ConvertFromString("#006100")
        $txtPCScaleStatusIcon.Text = [char]0xE73E 
        $txtPCScaleVersion.Text = "AWS Access"
    }
    else {
        $brdPCScaleHeader.Background = $bc.ConvertFromString("#FFC7CE")
        $PCScaleColor = $bc.ConvertFromString("#9C0006")
        $txtPCScaleStatusIcon.Text = [char]0xE711
        $txtPCScaleVersion.Text = "No Access"
    }

    $txtPCScaleTitle.Foreground = $PCScaleColor
    $txtPCScaleVersion.Foreground = $PCScaleColor
    $txtPCScaleStatusIcon.Foreground = $PCScaleColor

    if ($hasPCScaleAWS) { &$AddListItem $listPCScaleStatus $PCScaleAWS $PCScaleColor }

    $btnTogglePCScaleAWS.Content = if ($hasPCScaleAWS) { "Remove AWS" } else { "Add AWS" }

    ### COGNOS LOGIC ###

    $CognosCTX = "CTX - IBM Cognos TM1 Client"
    $CognosZscaler= "Zscaler-ZPA-Cognos"
    
    $hasCognosCTX = $userGroups -contains $CognosCTX
    $hasCognosZscaler = $userGroups -contains $CognosZscaler

    $listCognosStatus.Items.Clear()
    
    if ($hasCognosCTX -and $hasCognosZscaler) {
        $brdCognosHeader.Background = $bc.ConvertFromString("#C6EFCE")
        $cognosColor = $bc.ConvertFromString("#006100")
        $txtCognosStatusIcon.Text = [char]0xE73E
        $txtCognosVersion.Text = "Has Access"
    } elseif ($hasCognosCTX -and -not $hasCognosZscaler) {
        $brdCognosHeader.Background = $bc.ConvertFromString("#FFEB9C")
        $cognosColor = $bc.ConvertFromString("#9C5700")
        $txtCognosStatusIcon.Text = [char]0xE7BA
        $txtCognosVersion.Text = "Missing Zscaler-ZPA-Cognos"
    } elseif ($hasCognosZscaler -and -not $hasCognosCTX) {
        $brdCognosHeader.Background = $bc.ConvertFromString("#FFEB9C")
        $cognosColor = $bc.ConvertFromString("#9C5700")
        $txtCognosStatusIcon.Text = [char]0xE7BA
        $txtCognosVersion.Text = "Missing CTX - IBM Cognos TM1 Client"
    } else {
        $brdCognosHeader.Background = $bc.ConvertFromString("#FFC7CE")
        $cognosColor = $bc.ConvertFromString("#9C0006")
        $txtCognosStatusIcon.Text = [char]0xE711
        $txtCognosVersion.Text = "No Access"
    }

    $txtCognosTitle.Foreground = $cognosColor
    $txtCognosVersion.Foreground = $cognosColor
    $txtCognosStatusIcon.Foreground = $cognosColor

    if ($hasCognosCTX) { &$AddListItem $listCognosStatus $CognosCTX $cognosColor }
    if ($hasCognosZscaler) { &$AddListItem $listCognosStatus $CognosZscaler $cognosColor }

    $btnToggleCognosCTX.Content = if ($hasCognosCTX) { "Remove CTX" } else { "Add CTX" }
    $btnToggleCognosZscaler.Content = if ($hasCognosZscaler) { "Remove ZPA" } else { "Add ZPA" }
}

function toggle_groups ([string]$GroupName) {
    if (-not $global:currentLoadedUser) { 
        [System.Windows.MessageBox]::Show("Please load a user first.")
        return 
    }

    try {
        $memberOfDNs = @((Get-ADUser -Identity $global:currentLoadedUser -Properties memberOf -Server $global:CurrentDC -ErrorAction Stop).memberOf)
        $memberDN = $memberOfDNs | Where-Object { (group_name_from_dn $_) -eq $GroupName } | Select-Object -First 1

        if ($memberDN) {
            Remove-ADGroupMember -Identity $memberDN -Members $global:currentLoadedUser -Credential $global:MyCred -Confirm:$false -Server $global:CurrentDC -ErrorAction Stop
        } else {
            Add-ADGroupMember -Identity $GroupName -Members $global:currentLoadedUser -Credential $global:MyCred -Server $global:CurrentDC -ErrorAction Stop
        }

        get_apps
    } catch {
        [System.Windows.MessageBox]::Show("Error updating group: $($_.Exception.Message)")
    }
}

$btnToggleTruxAWS.Add_Click({ toggle_groups "CTX - AWS - APP - Trux" })
$btnToggleTruxMand.Add_Click({ toggle_groups "Trux User Group" })

$btnToggleTowerAWS.Add_Click({ toggle_groups "CTX - AWS - APP - Tower" })

$btnToggleM5US.Add_Click({ toggle_groups "M5 US Users" })
$btnToggleM5CA.Add_Click({ toggle_groups "M5 CA Users" })

$btnToggleOMSV30.Add_Click({ toggle_groups "OMSV30" })
$btnToggleOMSV30DEV.Add_Click({ toggle_groups "OMSV30DEV" })

$btnToggleCieAWS.Add_Click({ toggle_groups "CTX - AWS - APP - Cietrade" })
$btnToggleCieScale1.Add_Click({ toggle_groups "CTX - AWS - APP - Cietrade Scale 1" })
$btnToggleCieScale2.Add_Click({ toggle_groups "CTX - AWS - APP - Cietrade Scale 2" })

$btnTogglePCScaleAWS.Add_Click({ toggle_groups "CTX - AWS - APP - PC Scale" })

$btnToggleCognosCTX.Add_Click({ toggle_groups "CTX - IBM Cognos TM1 Client" })
$btnToggleCognosZscaler.Add_Click({ toggle_groups "Zscaler-ZPA-Cognos" })


$listUserResults.AddHandler([System.Windows.Controls.GridViewColumnHeader]::ClickEvent, [System.Windows.RoutedEventHandler]{ sort_users $args[0] $args[1] })

$btnResetPassword.Add_Click({
    if (-not $global:currentLoadedUser) { return }

    $newPassword = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the new password for $($lblUserSam.Text):", "Reset AD Password", "")

    if (-not [string]::IsNullOrWhiteSpace($newPassword)) {
        
        $confirm = [System.Windows.MessageBox]::Show("Are you sure you want to reset the password for $($lblUserName.Text)?", "Confirm Reset", "YesNo", "Warning")
        
        if ($confirm -eq "Yes") {
            try {
                $securePass = ConvertTo-SecureString $newPassword -AsPlainText -Force
                
                Set-ADAccountPassword -Identity $global:currentLoadedUser -NewPassword $securePass -Reset -Credential $global:MyCred -Server $global:CurrentDC -ErrorAction Stop
                Set-ADUser -Identity $global:currentLoadedUser -ChangePasswordAtLogon $false -Credential $global:MyCred -Server $global:CurrentDC -ErrorAction Stop
                Unlock-ADAccount -Identity $global:currentLoadedUser -Credential $global:MyCred -Server $global:CurrentDC -ErrorAction Stop
                
                [System.Windows.MessageBox]::Show("Password reset and account unlocked.", "Success", "OK", "Information")
                
                load_user $lblUserSam.Text
            }
            catch {
                [System.Windows.MessageBox]::Show("Failed to reset password: $($_.Exception.Message)", "Error", "OK", "Error")
            }
        }
    }
})

$btnUnlockAccount.Add_Click({
    if (-not $global:currentLoadedUser) { return }

    try {
        Unlock-ADAccount -Identity $global:currentLoadedUser -Credential $global:MyCred -Server $global:CurrentDC -ErrorAction Stop
        [System.Windows.MessageBox]::Show("Account unlocked successfully.", "Success", "OK", "Information")
        load_user $global:currentLoadedUser
    } catch {
        [System.Windows.MessageBox]::Show("Failed to unlock: $($_.Exception.Message)", "Error", "OK", "Error")
    }
})

$btnUpdateAttributes.Add_Click({
    if (-not $global:currentLoadedUser) { return }

    $val2 = $lblExtAttr2.Text.Trim()
    $val3 = $lblExtAttr3.Text.Trim()

    if (($val2 -ne "" -and $val2 -notmatch "^\d+$") -or ($val3 -ne "" -and $val3 -notmatch "^\d+$")) {
        [System.Windows.MessageBox]::Show("Invalid Input: Please enter numbers only or leave the field blank.", "Validation Error", "OK", "Error")
        return
    }

    $status2 = if ([string]::IsNullOrWhiteSpace($val2)) { "[WILL BE CLEARED]" } else { $val2 }
    $status3 = if ([string]::IsNullOrWhiteSpace($val3)) { "[WILL BE CLEARED]" } else { $val3 }

    $msg = "Confirming changes for user: $global:currentLoadedUser`n`n" +
           "Extension Attribute 2: $status2`n" +
           "Extension Attribute 3: $status3"

    $confirm = [System.Windows.MessageBox]::Show($msg, "Confirm AD Update", "YesNo", "Warning")

    if ($confirm -eq "Yes") {
        try {
            $adParams = @{
                Identity    = $global:currentLoadedUser
                Credential  = $global:MyCred
                Server      = $global:CurrentDC
                ErrorAction = "Stop"
            }
            $replaceHash = @{}
            $clearList = @()

            if ([string]::IsNullOrWhiteSpace($val2)) {
                $clearList += "extensionAttribute2"
            } else {
                $replaceHash.Add("extensionAttribute2", $val2)
            }

            if ([string]::IsNullOrWhiteSpace($val3)) {
                $clearList += "extensionAttribute3"
            } else {
                $replaceHash.Add("extensionAttribute3", $val3)
            }

            if ($replaceHash.Count -gt 0) { $adParams.Add("Replace", $replaceHash) }
            if ($clearList.Count -gt 0) { $adParams.Add("Clear", $clearList) }

            Set-ADUser @adParams
            [System.Windows.MessageBox]::Show("Successfully updated Active Directory.", "Success", "OK", "Information")
            load_user $global:currentLoadedUser
        }
        catch {
            [System.Windows.MessageBox]::Show("Failed to update: $($_.Exception.Message)", "Error", "OK", "Error")
        }
    }
})

$dpAccountExpiration.Add_SelectedDateChanged({
    if ($dpAccountExpiration.SelectedDate) {
        $lblExpirationText.Text = $dpAccountExpiration.SelectedDate.ToString("MMMM dd, yyyy")
    }
})

$btnClearExpiration.Add_Click({
    $dpAccountExpiration.SelectedDate = $null
    $lblExpirationText.Text = "Never"
})

$btnSaveExpiration.Add_Click({
    if ($global:currentLoadedUser) {
        try {
            $rawDate = $dpAccountExpiration.SelectedDate

            if ($null -eq $rawDate) {
                Clear-ADAccountExpiration -Identity $global:currentLoadedUser -Credential $global:MyCred -Server $global:CurrentDC -ErrorAction Stop
                $lblExpirationText.Text = "Never"
                [System.Windows.MessageBox]::Show("Account set to Never Expire.", "Success")

            } else {
                $adExpirationDate = ([datetime]$rawDate).Date.AddDays(1)

                Set-ADUser -Identity $global:currentLoadedUser -AccountExpirationDate $adExpirationDate -Credential $global:MyCred -Server $global:CurrentDC -ErrorAction Stop

                $lblExpirationText.Text = ([datetime]$rawDate).ToString("MMMM dd, yyyy")

                [System.Windows.MessageBox]::Show("Expiration date changed to $($lblExpirationText.Text)", "Success")
            }
        } catch {
            [System.Windows.MessageBox]::Show("Error saving to AD: $($_.Exception.Message)", "Error")
        }
    } else {
        [System.Windows.MessageBox]::Show("Please load a user first.", "Warning")
    }
})

$numericFilter = {
    $key  = $_.Key
    $mods = [System.Windows.Input.Keyboard]::Modifiers

    if (([int]$mods -band [int][System.Windows.Input.ModifierKeys]::Control) -ne 0) { return }

    $isShift  = ([int]$mods -band [int][System.Windows.Input.ModifierKeys]::Shift) -ne 0
    $isDigit  = ([int]$key -ge 34 -and [int]$key -le 43 -and -not $isShift) -or
                ([int]$key -ge 74 -and [int]$key -le 83)
    $isEdit   = $key.ToString() -in @("Back", "Delete", "Tab", "Left", "Right", "Home", "End", "Enter")

    if (-not ($isDigit -or $isEdit)) { $_.Handled = $true }
}

$lblExtAttr2.Add_KeyDown($numericFilter)
$lblExtAttr3.Add_KeyDown($numericFilter)

$btnSubUserInfo.Add_Click({ select_user_tab "info" })

$btnSubUserGroups.Add_Click({
    select_user_tab "groups"
    get_user_groups
})

$btnSubUserApps.Add_Click({
    select_user_tab "apps"
    get_apps
})

$listUserResults.Add_MouseDoubleClick({
    if ($listUserResults.SelectedItem -ne $null) {
        $selectedUsername = $listUserResults.SelectedItem.SamAccountName
        
        load_user $selectedUsername
    }
})

$userSearch.Add_KeyDown({ if ($_.Key -eq "Enter") { $_.Handled = $true; search_user } })
$userSearch.Add_GotFocus({ if ($userSearch.Text -eq "Search User...") { $userSearch.Text = ""; $userSearch.Foreground = [System.Windows.Media.Brushes]::Black } })
$userSearch.Add_LostFocus({ if ([string]::IsNullOrWhiteSpace($userSearch.Text)) { $userSearch.Text = "Search User..."; $userSearch.Foreground = [System.Windows.Media.Brushes]::Gray } })
$btnsearchUser.Add_Click({ search_user })


### EMPLOYEE ID LOGIC ###

function search_employee_id {
    $employeeID = $employeeIDSearch.Text.Trim()

    $lblEmployeeIDError.Visibility = "Collapsed"
    $employeeIDResultCard.Visibility = "Collapsed"
    $employeeMultipleArea.Visibility = "Collapsed"

    $listEmployeeResults.Items.Clear()

    if (-not $employeeID -or $employeeID -eq "Search Employee ID...") { return }

    if ($employeeID.Length -le 2) {
        show_search_error $lblEmployeeIDError "Please type at least 3 characters!"
        return
    }

    set_busy $btnSearchEmployeeID $true

    start_bg "employee" {
        param($employeeID)
        $safe = $employeeID -replace "'", "''"
        @(Get-ADUser -Filter "EmployeeID -eq '$safe'" -Properties DisplayName, EmployeeID -ErrorAction Stop | ForEach-Object {
            [pscustomobject]@{ DisplayName = $_.DisplayName; SamAccountName = $_.SamAccountName; EmployeeNumber = $_.EmployeeID }
        })
    } @($employeeID) {
        param($r, $s)
        set_busy $btnSearchEmployeeID $false

        if (-not $r.Ok) {
            log_error "EMPLOYEE ID" $s.ID $r.Error
            show_search_error $lblEmployeeIDError "Search failed: $($r.Error)"
            return
        }

        $employees = @($r.Data | Where-Object { $null -ne $_ })

        if ($employees.Count -eq 0) {
            show_search_error $lblEmployeeIDError "No users found."

        } elseif ($employees.Count -eq 1) {
            $employeeIDResultCard.Visibility = "Visible"
            $lblEmployeeName.Text   = $employees[0].DisplayName
            $lblEmployeeSam.Text    = $employees[0].SamAccountName
            $lblEmployeeNumber.Text = $employees[0].EmployeeNumber

            $global:tempEmployee = $employees[0].SamAccountName

        } else {
            $employeeMultipleArea.Visibility = "Visible"
            foreach ($u in $employees) { $listEmployeeResults.Items.Add($u) | Out-Null }
        }
    } @{ ID = $employeeID }
}

$employeeIDSearch.Add_KeyDown({ if ($_.Key -eq "Enter") { $_.Handled = $true; search_employee_id } })
$employeeIDSearch.Add_GotFocus({ if ($employeeIDSearch.Text -eq "Search Employee ID...") { $employeeIDSearch.Text = ""; $employeeIDSearch.Foreground = [System.Windows.Media.Brushes]::Black } })
$employeeIDSearch.Add_LostFocus({ if ([string]::IsNullOrWhiteSpace($employeeIDSearch.Text)) { $employeeIDSearch.Text = "Search Employee ID..."; $employeeIDSearch.Foreground = [System.Windows.Media.Brushes]::Gray } })
$btnSearchEmployeeID.Add_Click({ search_employee_id })

$btnGoToEmployeeProfile.Add_Click({
    if ($global:tempEmployee) {
        show_screen "screenUserInfo" $btnUserInfo 
        
        $userSearch.Text = $global:tempEmployee
        $userSearch.Foreground = "Black"
        load_user $global:tempEmployee
    }
})

$listEmployeeResults.Add_MouseDoubleClick({
    if ($listEmployeeResults.SelectedItem -ne $null) {
        $selectedUsername = $listEmployeeResults.SelectedItem.SamAccountName
        
        load_user $selectedUsername
        show_screen "screenUserInfo" $btnUserInfo 
    }
})

### PRINTER CARD LOGIC ###

function search_printer_card {
    $cardNumber = $printerCardSearch.Text.Trim()

    $lblPrinterCardError.Visibility = "Collapsed"
    $printerResultCard.Visibility = "Collapsed"
    $printerMultipleArea.Visibility = "Collapsed"

    $listPrinterResults.Items.Clear()

    if (-not $cardNumber -or $cardNumber -eq "Search Printer Card...") { return }

    if ($cardNumber.Length -le 2) {
        show_search_error $lblPrinterCardError "Please type at least 3 characters!"
        return
    }

    set_busy $btnSearchPrinterCard $true

    start_bg "printer" {
        param($cardNumber)
        $safe = $cardNumber -replace "'", "''"
        @(Get-ADUser -Filter "extensionAttribute2 -eq '$safe'" -Properties DisplayName, extensionAttribute2, extensionAttribute3 -ErrorAction Stop | ForEach-Object {
            [pscustomobject]@{
                DisplayName = $_.DisplayName; SamAccountName = $_.SamAccountName
                extensionAttribute2 = $_.extensionAttribute2; extensionAttribute3 = $_.extensionAttribute3
            }
        })
    } @($cardNumber) {
        param($r, $s)
        set_busy $btnSearchPrinterCard $false

        if (-not $r.Ok) {
            log_error "PRINTER CARD" $s.Card $r.Error
            show_search_error $lblPrinterCardError "Search failed: $($r.Error)"
            return
        }

        $owners = @($r.Data | Where-Object { $null -ne $_ })

        if ($owners.Count -eq 0) {
            show_search_error $lblPrinterCardError "No users assigned to this card."

        } elseif ($owners.Count -eq 1) {
            $printerResultCard.Visibility = "Visible"
            $lblPrinterOwnerName.Text  = $owners[0].DisplayName
            $lblPrinterOwnerSam.Text   = $owners[0].SamAccountName
            $lblPrinterOwnerAttr2.Text = $owners[0].extensionAttribute2
            $lblPrinterOwnerAttr3.Text = $owners[0].extensionAttribute3

            $global:tempPrinterUser = $owners[0].SamAccountName

        } else {
            $printerMultipleArea.Visibility = "Visible"
            foreach ($u in $owners) { $listPrinterResults.Items.Add($u) | Out-Null }
        }
    } @{ Card = $cardNumber }
}

$printerCardSearch.Add_KeyDown({ if ($_.Key -eq "Enter") { $_.Handled = $true; search_printer_card } })
$printerCardSearch.Add_GotFocus({ if ($printerCardSearch.Text -eq "Search Printer Card...") { $printerCardSearch.Text = ""; $printerCardSearch.Foreground = [System.Windows.Media.Brushes]::Black } })
$printerCardSearch.Add_LostFocus({ if ([string]::IsNullOrWhiteSpace($printerCardSearch.Text)) { $printerCardSearch.Text = "Search Printer Card..."; $printerCardSearch.Foreground = [System.Windows.Media.Brushes]::Gray } })
$btnSearchPrinterCard.Add_Click({ search_printer_card })

$btnGoToUserProfile.Add_Click({
    if ($global:tempPrinterUser) {
        show_screen "screenUserInfo" $btnUserInfo 
        
        $userSearch.Text = $global:tempPrinterUser
        $userSearch.Foreground = "Black"
        load_user $global:tempPrinterUser
    }
})

$listPrinterResults.Add_MouseDoubleClick({
    if ($listPrinterResults.SelectedItem -ne $null) {
        $selectedUsername = $listPrinterResults.SelectedItem.SamAccountName
        
        load_user $selectedUsername
        show_screen "screenUserInfo" $btnUserInfo 
    }
})


### TIME ZONES TIER 2 LOGIC ###

$global:T2Data = @{
    "Canada" = @{
        "British Columbia" = @{ Group = "Tier 2 Service Support - CA Western & Central"; TzId = "Pacific Standard Time"; Abbr = "PST/PDT" }
        "Manitoba"         = @{ Group = "Tier 2 Service Support - CA Western & Central"; TzId = "Central Standard Time"; Abbr = "CST/CDT" }
        "Ontario"          = @{ Group = "Tier 2 Service Support - CA Corporate";         TzId = "Eastern Standard Time"; Abbr = "EST/EDT" }
        "Quebec"           = @{ Group = "Tier 2 Service Support - CA Quebec";            TzId = "Eastern Standard Time"; Abbr = "EST/EDT" }
    }
    "USA" = @{
        "Arkansas"       = @{ Group = "Tier 2 Service Support - US South";   TzId = "Central Standard Time"; Abbr = "CST/CDT" }
        "Florida"        = @{ Group = "Tier 2 Service Support - US South";   TzId = "Eastern Standard Time"; Abbr = "EST/EDT" }
        "Georgia"        = @{ Group = "Tier 2 Service Support - US Central"; TzId = "Eastern Standard Time"; Abbr = "EST/EDT" }
        "Illinois"       = @{ Group = "Tier 2 Service Support - US North";   TzId = "Central Standard Time"; Abbr = "CST/CDT" }
        "Indiana"        = @{ Group = "Tier 2 Service Support - US North";   TzId = "Eastern Standard Time"; Abbr = "EST/EDT" }
        "Kansas"         = @{ Group = "Tier 2 Service Support - US South";   TzId = "Central Standard Time"; Abbr = "CST/CDT" }
        "Kentucky"       = @{ Group = "Tier 2 Service Support - US Central"; TzId = "Eastern Standard Time"; Abbr = "EST/EDT" }
        "Minnesota"      = @{ Group = "Tier 2 Service Support - US North";   TzId = "Central Standard Time"; Abbr = "CST/CDT" }
        "Michigan"       = @{ Group = "Tier 2 Service Support - US North";   TzId = "Eastern Standard Time"; Abbr = "EST/EDT" }
        "Missouri"       = @{ Group = "Tier 2 Service Support - US South";   TzId = "Central Standard Time"; Abbr = "CST/CDT" }
        "New York"       = @{ Group = "Tier 2 Service Support - US North";   TzId = "Eastern Standard Time"; Abbr = "EST/EDT" }
        "North Carolina" = @{ Group = "Tier 2 Service Support - US Central"; TzId = "Eastern Standard Time"; Abbr = "EST/EDT" }
        "Ohio"           = @{ Group = "Tier 2 Service Support - US North";   TzId = "Eastern Standard Time"; Abbr = "EST/EDT" }
        "Oklahoma"       = @{ Group = "Tier 2 Service Support - US South";   TzId = "Central Standard Time"; Abbr = "CST/CDT" }
        "Pennsylvania"   = @{ Group = "Tier 2 Service Support - US North";   TzId = "Eastern Standard Time"; Abbr = "EST/EDT" }
        "South Carolina" = @{ Group = "Tier 2 Service Support - US Central"; TzId = "Eastern Standard Time"; Abbr = "EST/EDT" }
        "Tennessee"      = @{ Group = "Tier 2 Service Support - US Central"; TzId = "Central Standard Time"; Abbr = "CST/CDT" }
        "Texas"          = @{ Group = "Tier 2 Service Support - US South";   TzId = "Central Standard Time"; Abbr = "CST/CDT" }
        "Virginia"       = @{ Group = "Tier 2 Service Support - US Central"; TzId = "Eastern Standard Time"; Abbr = "EST/EDT" }
        "Wisconsin"      = @{ Group = "Tier 2 Service Support - US North";   TzId = "Central Standard Time"; Abbr = "CST/CDT" }
    }
}

$global:T2Updating = $false
$global:T2TzCache  = @{}

function get_t2_timezone ($tzId) {
    if (-not $global:T2TzCache.ContainsKey($tzId)) {
        $global:T2TzCache[$tzId] = [System.TimeZoneInfo]::FindSystemTimeZoneById($tzId)
    }
    return $global:T2TzCache[$tzId]
}

function get_t2_reference {
    if ($cbT2Origin.SelectedItem -eq "Azores") {
        return @{ TimeZone = (get_t2_timezone "Azores Standard Time"); Name = "Azores" }
    }
    try {
        $tz = get_t2_timezone "GMT Standard Time"
    } catch {
        $tz = get_t2_timezone "Europe/Lisbon"
    }
    return @{ TimeZone = $tz; Name = "Porto" }
}

function get_t2_selection {
    $country = $cbT2Country.SelectedItem
    $state   = $cbT2State.SelectedItem
    if ($country -and $state) { return $global:T2Data[$country][$state] }
    return $null
}

function set_t2_clocks ($stateText, $originText) {
    $global:T2Updating = $true
    try {
        $txtT2StateTime.Text  = $stateText
        $txtT2OriginTime.Text = $originText
    } finally {
        $global:T2Updating = $false
    }
}

function update_t2_panel {
    $info = get_t2_selection
    if (-not $info) { return }

    $ref        = get_t2_reference
    $tzDest     = get_t2_timezone $info.TzId
    $nowUtc     = [System.DateTimeOffset]::UtcNow
    $timeDest   = [System.TimeZoneInfo]::ConvertTime($nowUtc, $tzDest)
    $timeOrigin = [System.TimeZoneInfo]::ConvertTime($nowUtc, $ref.TimeZone)

    $diffHours = [Math]::Round(($timeDest.Offset - $timeOrigin.Offset).TotalHours, 1)
    $sign = if ($diffHours -ge 0) { "+$diffHours" } else { "$diffHours" }

    $txtT2Group.Text = $info.Group
    $txtT2Diff.Text  = "$sign h (vs $($ref.Name))"
    $txtT2Zone.Text  = "$($info.Abbr) ($($info.TzId))"
    $txtT2Now.Text   = $timeDest.ToString("yyyy-MM-dd HH:mm:ss")

    $lblT2StateClock.Text  = "$($cbT2State.SelectedItem) Time"
    $lblT2OriginClock.Text = "$($ref.Name) Time"

    $txtT2StateTime.IsEnabled  = $true
    $txtT2OriginTime.IsEnabled = $true
    $btnT2Sync.IsEnabled       = $true
    set_t2_clocks $timeDest.ToString("HH:mm") $timeOrigin.ToString("HH:mm")
}

function sync_t2_clock ($fromState) {
    if ($global:T2Updating) { return }
    $info = get_t2_selection
    if (-not $info) { return }

    $srcBox = if ($fromState) { $txtT2StateTime } else { $txtT2OriginTime }
    $m = [regex]::Match($srcBox.Text.Trim(), '^([01]?\d|2[0-3]):([0-5]\d)$')
    if (-not $m.Success) { return }

    $tzState  = get_t2_timezone $info.TzId
    $tzOrigin = (get_t2_reference).TimeZone
    $tzSrc = if ($fromState) { $tzState } else { $tzOrigin }
    $tzDst = if ($fromState) { $tzOrigin } else { $tzState }

    try {
        $todaySrc = [System.TimeZoneInfo]::ConvertTime([System.DateTimeOffset]::UtcNow, $tzSrc).Date
        $dtSrc = $todaySrc.AddHours([int]$m.Groups[1].Value).AddMinutes([int]$m.Groups[2].Value)
        $utc   = [System.TimeZoneInfo]::ConvertTimeToUtc($dtSrc, $tzSrc)
        $dtDst = [System.TimeZoneInfo]::ConvertTimeFromUtc($utc, $tzDst)
    } catch {
        return
    }

    $global:T2Updating = $true
    try {
        $dstBox = if ($fromState) { $txtT2OriginTime } else { $txtT2StateTime }
        $dstBox.Text = $dtDst.ToString("HH:mm")
    } finally {
        $global:T2Updating = $false
    }
}

function clear_t2_screen {
    $global:T2Updating = $true
    try {
        $cbT2Country.SelectedIndex = -1
        $cbT2State.Items.Clear()
        $cbT2State.IsEnabled = $false
        $txtT2Group.Text = "-"
        $txtT2Diff.Text  = "-"
        $txtT2Zone.Text  = "-"
        $txtT2Now.Text   = "-"
        $txtT2StateTime.Text  = ""
        $txtT2OriginTime.Text = ""
        $txtT2StateTime.IsEnabled  = $false
        $txtT2OriginTime.IsEnabled = $false
        $btnT2Sync.IsEnabled = $false
        $lblT2StateClock.Text = "State Time"
    } finally {
        $global:T2Updating = $false
    }
}

$null = $cbT2Origin.Items.Add("Porto")
$null = $cbT2Origin.Items.Add("Azores")
$cbT2Origin.SelectedIndex = 0
$global:T2Data.Keys | Sort-Object | ForEach-Object { $null = $cbT2Country.Items.Add($_) }

$cbT2Origin.Add_SelectionChanged({
    $lblT2OriginClock.Text = "$((get_t2_reference).Name) Time"
    update_t2_panel
})

$cbT2Country.Add_SelectionChanged({
    $cbT2State.Items.Clear()
    $country = $cbT2Country.SelectedItem
    if ($country) {
        $global:T2Data[$country].Keys | Sort-Object | ForEach-Object { $null = $cbT2State.Items.Add($_) }
        $cbT2State.IsEnabled = $true
    } else {
        $cbT2State.IsEnabled = $false
    }
    if ($global:T2Updating) { return }

    $txtT2Group.Text = "-"; $txtT2Diff.Text = "-"; $txtT2Zone.Text = "-"; $txtT2Now.Text = "-"
    $txtT2StateTime.Text = ""; $txtT2OriginTime.Text = ""
    $txtT2StateTime.IsEnabled = $false; $txtT2OriginTime.IsEnabled = $false
    $btnT2Sync.IsEnabled = $false
})

$cbT2State.Add_SelectionChanged({ update_t2_panel })

$txtT2StateTime.Add_TextChanged({ sync_t2_clock $true })
$txtT2OriginTime.Add_TextChanged({ sync_t2_clock $false })

$btnT2Sync.Add_Click({ update_t2_panel })
$btnT2Clear.Add_Click({ clear_t2_screen })

### PATHS LOGIC ###

$fnOpenPath = {
    $btn  = $this
    $path = $btn.Tag

    set_busy $btn $true "Checking..."

    start_bg "path-$($btn.Name)" {
        param($path)
        Test-Path -LiteralPath $path
    } @($path) {
        param($r, $s)
        set_busy $s.Button $false

        if ($r.Ok -and $r.Data) {
            Invoke-Item -LiteralPath $s.Path
        } else {
            [System.Windows.MessageBox]::Show("Path not found: $($s.Path)", "Error")
        }
    } @{ Button = $btn; Path = $path }
}

@($btnOpenSDrive, $btnOpenKDrive, $btnOpenZDrive, $btnOpenAWS, $btnOpenLRS, $btnOpenPAFE, $btnOpenWallpaper) | ForEach-Object {
    if ($_) { $_.Add_Click($fnOpenPath) }
}


$window.ShowDialog() | Out-Null
