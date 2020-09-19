# John's Powershell Toolkit

The tools of the guy that despises RDP.

## Installing

To install, save the contents of this repository to your Documents\WindowsPowershell Folder.

## Configuring

Configuration options can be set in the config.json file.

- admin_id: your saved admin ID, this is set automatically for you on first run.
- store_admin_id: whether or not you want to store your admin ID in a file. Obviously this encrypted, and saves time when starting up a new powershell session.
- info_preference: turn on information messages with "Continue" or be less noisy with "SilentlyContinue"
- vmware_autoconnect: connect to vSphere at startup. This adds about 9 seconds to your PS session startup, so good if you leave terminals open all the time, annoying if you just want to open, do something, and close.
