# GFL-SolvIT-Tools

## Running the tool

Double-click **`Start GFL SolvIT Tools.cmd`** (keep it in the same folder as `GFL SolvIT Tools v2.ps1`).

It starts PowerShell the way the tool needs (STA mode, no profile, execution policy bypassed for this run only).
If something goes wrong, the error stays on screen instead of the window closing.

If the tool still won't start:

- The file may be marked as downloaded from the internet. In PowerShell run:
  `Unblock-File -Path ".\GFL SolvIT Tools v2.ps1"`
- Startup errors are also saved to `%TEMP%\GFLSolvITTools_error.log`.
- Requires the RSAT Active Directory module and the Windows LAPS module.
